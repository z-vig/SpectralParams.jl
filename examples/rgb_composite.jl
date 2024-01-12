#ibd_mapping.jl
using SpectralParams
using HDF5
using GLMakie
using Colors
using Statistics

function get_data(str::String ; folder=false)
    #Function for getting data from Data folder in the package
    hmdir = joinpath(dirname(@__DIR__),"Data")
    if folder != false
        hmdir = joinpath(hmdir,folder)
    end
    return joinpath(hmdir,str)
end

function clip_im(im::Array{<:AbstractFloat,2},minval::Float64,maxval::Float64)
    im[im.<minval] .= minval
    im[im.>maxval] .= maxval
end

function normalize_im(im::Array{<:AbstractFloat,2})
    (im.-minimum(im))./maximum(im.-minimum(im))
end

h5file = h5open(get_data("gd_region_smoothed.hdf5"),"r")
im = read(h5file["gamma"])
close(h5file)

h5file = h5open(get_data("gd_region_2pcontinuum.hdf5"),"r")
cont = read(h5file["gamma"])
close(h5file)

shadow_mask = (mean(im,dims=3)[:,:,1].<0.05)

λ = pullλ(get_data("smoothed_wvl_data.txt",folder="wvl"))

upper_quantile = 0.95
lower_quantile = 0.05

i1_min = 789
i1_max = i1_min + 20*26
ibd1000 = IBD_map(im,cont,λ,i1_min,i1_max)[:,:,1]
clip_im(ibd1000,quantile(vec(ibd1000),lower_quantile),quantile(vec(ibd1000),upper_quantile))

i2_min = 1658
i2_max = i2_min + 40*21
ibd2000 = IBD_map(im,cont,λ,i2_min,i2_max)[:,:,1]
clip_im(ibd2000,quantile(vec(ibd2000),lower_quantile),quantile(vec(ibd2000),upper_quantile))

albedo = im[:,:,findλ(λ,1580)[1]]
clip_im(albedo,quantile(vec(albedo),lower_quantile),quantile(vec(albedo),upper_quantile))

# for i in [ibd1000,ibd2000,albedo]
#     i[shadow_mask] .= NaN
# end

ibd1000 = normalize_im(ibd1000)
ibd2000 = normalize_im(ibd2000)
albedo = normalize_im(albedo)



coord_arr = [(x,y) for x in 1:size(ibd1000,1),y in 1:size(ibd1000,2)]
function compile_composite(pt)
    RGB(ibd1000[pt...],ibd2000[pt...],albedo[pt...])
end

rgb_composite = compile_composite.(coord_arr)
rgb_composite[shadow_mask] .= NaN

function plot()
    XTest = rand(range(1,size(im,1)))
    YTest = rand(range(1,size(im,2)))

    f1 = Figure()
    Label(f1[0,:],"Showing point: ($XTest, $YTest)",tellwidth=false)
    ax1 = GLMakie.Axis(f1[1,1])
    ax2 = GLMakie.Axis(f1[1,2])
    lines!(ax1,λ,im[XTest,YTest,:])
    lines!(ax1,λ,cont[XTest,YTest,:])
    hist!(ax2,vec(ibd1000),label="IBD1000",color=:transparent,strokecolor=:red,strokewidth=1)
    hist!(ax2,vec(ibd2000),label="IBD2000",color=:transparent,strokecolor=:green,strokewidth=1)
    hist!(ax2,vec(albedo),label="Albedo",color=:transparent,strokecolor=:blue,strokewidth=1)
    axislegend(ax2)

    fim = Figure()
    axim = GLMakie.Axis(fim[1,1])
    image!(axim,rgb_composite,nan_color=RGB(0,0,0),colorrange=(0,0.01))
    elem1 = PolyElement(color=:red)
    elem2 = PolyElement(color=:green)
    elem3 = PolyElement(color=:blue)
    axislegend(axim,[elem1,elem2,elem3],[L"IBD$1000$",L"IBD$2000$",L"$1580 \text{\mu}$m"])

    display(GLMakie.Screen(),f1)
    display(GLMakie.Screen(),fim)
end

plot()