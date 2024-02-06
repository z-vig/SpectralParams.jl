#slope_map.jl

using SpectralParams
using HDF5

function get_slope_map()
    h5file = h5open("C:/Users/zvig/.julia/dev/JENVI.jl/Data/gamma_maps.hdf5")
    arr = read(h5file["2pRemoved"])
    close(h5file)

    λ = [parse(Float64,i) for i in readlines(open("C:/Users/zvig/.julia/dev/SpectralParams.jl/Data/wvl/smoothed_wvl_data.txt"))]

    vis_slope = slopemap(arr,λ,500.,1000.)
    oh_slope = slopemap(arr,λ,2000.,2600.)

    h5save = h5open("C:/Users/zvig/.julia/dev/JENVI.jl/Data/gamma_maps.hdf5","r+")
    h5save["VisSlope"][:,:,:] = vis_slope
    h5save["SwirSlope"][:,:,:] = oh_slope
    close(h5save)

    return nothing
end

function examine_maps()
    h5file = h5open("C:/Users/zvig/.julia/dev/JENVI.jl/Data/gamma_maps.hdf5")
    vis_slope = read(h5file["VisSlope"])
    sw_slope = read(h5file["SwirSlope"])
    close(h5file)

    println(maximum(vis_slope))
end

@time get_slope_map()
examine_maps()
GC.gc()

