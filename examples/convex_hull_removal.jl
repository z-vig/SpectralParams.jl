#usepkg.jl

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

#Opening hdf5 file
h5file = h5open(get_data("gd_region_smoothed.hdf5"),"r")
im = read(h5file["gamma"])
close(h5file)

#Getting band values
λ = [parse(Float64,i) for i ∈ readlines(open(get_data("smoothed_wvl_data.txt",folder="wvl")))]

#Removing convex hull continuum
println("Removing Convex Hull...")
cv_removal = convexhull_removal(im,λ)

println("Saving Results...")
h5save = h5open(get_data("gd_region_cvh_removed.hdf5"),"w")
h5save["gamma"] = cv_removal
close(h5save)

f = Figure()
ax_im = Axis(f[1,1])
ax_spec = Axis(f[1,2])

image!(ax_im,im[:,:,end])
XTEST = 20
YTEST = 200
lines!(ax_spec,λ,cv_removal[XTEST,YTEST,:])

f
