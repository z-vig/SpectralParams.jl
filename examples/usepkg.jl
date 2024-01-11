#usepkg.jl

using SpectralParams
using HDF5
using GLMakie

function get_data(str::String ; folder=false)
    hmdir = joinpath(dirname(@__DIR__),"Data")
    if folder != false
        hmdir = joinpath(hmdir,folder)
    end
    return joinpath(hmdir,str)
end


h5file = h5open(get_data("gd_region_smoothed.hdf5"),"r")
im = read(h5file["gamma"])
close(h5file)

λ = [parse(Float64,i) for i ∈ readlines(open(get_data("smoothed_wvl_data.txt",folder="wvl")))]

cv_removal = convexhull_removal(im,λ)

h5save = h5open(get_data(""))

f = Figure()
ax_im = Axis(f[1,1])
ax_spec = Axis(f[1,2])

image!(ax_im,im[:,:,end])
XTEST = 20
YTEST = 200
lines!(ax_spec,λ,cv_removal[XTEST,YTEST,:])

f
