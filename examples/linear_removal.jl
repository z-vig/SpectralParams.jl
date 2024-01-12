#linear_removal.jl
using SpectralParams
using HDF5
using GLMakie

function get_data(str::String ; folder=false)
    #Function for getting data from Data folder in the package
    hmdir = joinpath(dirname(@__DIR__),"Data")
    if folder != false
        hmdir = joinpath(hmdir,folder)
    end
    return joinpath(hmdir,str)
end

h5file = h5open(get_data("gd_region_smoothed.hdf5"))
im = read(h5file["gamma"])
close(h5file)

λ = pullλ(get_data("smoothed_wvl_data.txt",folder="wvl"))

cont1_inds,cont1r,cont1,cont2_inds,wvls,cont2,cont2r = doubleLine_removal(im,λ)

h5save = h5open(get_data("gd_region_2pcontinuum.hdf5"),"w")
h5save["gamma"] = cont2
close(h5save)


function plot()
    XTest = rand(range(1,size(im,1)))
    YTest = rand(range(1,size(im,2)))
    f = Figure()
    ax1 = GLMakie.Axis(f[1,1])
    ax1.title = "Original Spectrum w/ Continuum 1"
    ax2 = GLMakie.Axis(f[1,2])
    ax2.title = "First Continuum Removed"
    ax3 = GLMakie.Axis(f[2,1])
    ax3.title = "Original Spectrum w/ Continuum 2"
    ax4 = GLMakie.Axis(f[2,2])
    ax4.title = "Second Continuum Removed"
    Label(f[0,:],"Showing Point: ($XTest, $YTest)")

    lines!(ax1,λ,im[XTest,YTest,:])
    lines!(ax1,λ,cont1[XTest,YTest,:],color=:blue,label="Continuum 1")
    sc1 = scatter!(ax1,[700,1550,2600],im[XTest,YTest,cont1_inds],color=:blue,label="Continuum 1 Tie Points")
    sc2 = scatter!(ax1,wvls[XTest,YTest,:][1],im[XTest,YTest,cont2_inds[XTest,YTest,:]],color=:red,label="Continuum 2 Tie Points")
    axislegend(ax1)

    lines!(ax2,λ,cont1r[XTest,YTest,:])
    sc1 = scatter!(ax2,[700,1550,2600],cont1r[XTest,YTest,cont1_inds],color=:blue,label="Continuum 1 Tie Points")
    sc2 = scatter!(ax2,wvls[XTest,YTest,:][1],cont1r[XTest,YTest,cont2_inds[XTest,YTest,:]],label="Continuum 2 Tie Points",color=:red)
    vlines!(ax2,[650,1000,1350,1600,2000,2600],0,0.12,color=:red)
    arrows!(ax2,[700,1550,2600],cont1r[XTest,YTest,cont1_inds],wvls[XTest,YTest,:][1].-[700,1550,2600],cont1r[XTest,YTest,cont2_inds[XTest,YTest,:]].-cont1r[XTest,YTest,cont1_inds])
    axislegend(ax2)

    lines!(ax3,λ,im[XTest,YTest,:])
    lines!(ax3,λ,cont2[XTest,YTest,:],color=:red,label="Continuum 2")
    sc1 = scatter!(ax3,[700,1550,2600],im[XTest,YTest,cont1_inds],color=:blue,label="Continuum 1 Tie Points")
    sc2 = scatter!(ax3,wvls[XTest,YTest,:][1],im[XTest,YTest,cont2_inds[XTest,YTest,:]],color=:red,label="Continuum 2 Tie Points")
    axislegend(ax3)

    lines!(ax4,λ,cont2r[XTest,YTest,:],color=:red,label="Continuum 2")
    lines!(ax4,λ,cont1r[XTest,YTest,:],color=:blue,label="Continuum 1")
    axislegend(ax4)

    fim = Figure()
    axim = GLMakie.Axis(fim[1,1])
    image!(axim,im[:,:,end])
    scatter!(axim,XTest,YTest,marker='X',markersize=10,color=:red)

    display(GLMakie.Screen(),f)
    display(GLMakie.Screen(),fim)
end

plot()
