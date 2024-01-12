#linear_removal.jl
using SpectralParams
using HDF5

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

doubleLine_removal(im,λ)