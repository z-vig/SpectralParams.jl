#band_centers.jl

using SpectralParams
using HDF5
using GLMakie
using Statistics

h5file = h5open("C:/Users/zvig/.julia/dev/SpectralParams.jl/Data/gd_region_2p_removed.hdf5")
im = read(h5file["gamma"])
close(h5file)

h5file = h5open("C:/Users/zvig/.julia/dev/SpectralParams.jl/Data/gd_region_smoothed.hdf5")
ogim = read(h5file["gamma"])
close(h5file)

λ = pullλ("C:/Users/zvig/.julia/dev/SpectralParams.jl/Data/wvl/smoothed_wvl_data.txt")

println("Spline...")
crop_im,cropλ,spline_im,splineλ,bcmap_spline = locate_bandcenter(im,λ,(650.,1350.))
println("Polynomial...")
crop_im,cropλ,polyim,polyλ,bcmap_poly = locate_bandcenter(im,λ,(650.,1350.),fit_type="Polynomial")

# h5file = h5open("C:/Users/zvig/.julia/dev/SpectralParams.jl/Data/gd_region_bcmap.hdf5")
# bcmap_spline = read(h5file["spline"])
# bcmap_poly = read(h5file["poly"])
# close(h5file)

h5save = h5open("C:/Users/zvig/.julia/dev/JENVI.jl/Data/gamma_maps.hdf5","r+")
h5save["BCspline"] = bcmap_spline
h5save["BCpoly"] = bcmap_poly
close(h5save)

#println(size(bcmap_poly))

function plot()

    XTest = 289#rand(1:size(im,1))
    YTest = 318#rand(1:size(im,2))

    f = Figure()
    Label(f[0,:],"Showing: ($XTest, $YTest)",tellwidth=false)
    ax1 = GLMakie.Axis(f[1,1])
    ax2 = GLMakie.Axis(f[1,2])
    ax3 = GLMakie.Axis(f[2,1])
    ax4 = GLMakie.Axis(f[2,2])

    lines!(ax1,λ,ogim[XTest,YTest,:])

    lines!(ax2,λ,im[XTest,YTest,:])
    vspan!(ax2,cropλ[1],cropλ[end],0,1,color=:blue,alpha=0.3)

    lines!(ax3,cropλ,crop_im[XTest,YTest,:],linestyle=:dash)
    lines!(ax3,splineλ,spline_im[XTest,YTest,:])

    lines!(ax4,cropλ,crop_im[XTest,YTest,:],linestyle=:dash)
    lines!(ax4,polyλ,polyim[XTest,YTest,:])

    println("Poly BC: $(bcmap_poly[XTest,YTest])")
    println("Spline BC: $(bcmap_spline[XTest,YTest])")
    # shadow_mask = mean(ogim,dims=3)[:,:,1].<0.05
    # println(count(shadow_mask.==1))

    # bcmap_spline[shadow_mask] .= NaN
    # bcmap_poly[shadow_mask] .= NaN

    # fim = Figure()
    # axim1 = GLMakie.Axis(fim[1,1])
    # axim2 = GLMakie.Axis(fim[1,2])
    # axim3 = GLMakie.Axis(fim[2,1])
    # axim4 = GLMakie.Axis(fim[2,2])
    # axim1.title = "Spline Fit"
    # axim2.title = "4th order Polynomial Fit"
    # image!(axim1,bcmap_spline)
    # image!(axim2,bcmap_poly)
    # hist!(axim3,vec(bcmap_spline[isnan.(bcmap_spline).==0]))
    # hist!(axim4,vec(bcmap_poly[isnan.(bcmap_poly).==0]))

    display(GLMakie.Screen(),f)
    #display(GLMakie.Screen(),fim)
end

plot()
