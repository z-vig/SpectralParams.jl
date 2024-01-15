#band_centers.jl

using SpectralParams
using HDF5
using GLMakie

h5file = h5open("C:/Users/zvig/.julia/dev/SpectralParams.jl/Data/gd_region_2p_removed.hdf5")
im = read(h5file["gamma"])
close(h5file)

h5file = h5open("C:/Users/zvig/.julia/dev/SpectralParams.jl/Data/gd_region_smoothed.hdf5")
ogim = read(h5file["gamma"])
close(h5file)

λ = pullλ("C:/Users/zvig/.julia/dev/SpectralParams.jl/Data/wvl/smoothed_wvl_data.txt")

crop_im,cropλ,smoothim,smoothλ,spline_im,splineλ = locate_bandcenter(im,λ,(650.,1350.))

println(size(spline_im))

XTest = rand(1:size(im,1))
YTest = rand(1:size(im,2))

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
lines!(ax3,splineλ,spline_im[XTest,YTest])
# scatter!(ax3)
# scatter!()

display(GLMakie.Screen(),f)