using HDF5
using SpectralParams

function smooth_im(h5path)
    h5file = h5open(h5path,"r")
    arr = read(h5file["RawSpectra"])
    close(h5file)

    wvl = [parse(Float64,i) for i in readlines(open("C:/Users/zvig/.julia/dev/JENVI.jl/Data/global_wvl/raw_wvl.txt"))]

    smooth_arr,smooth_λ = movingavg(arr,wvl,9)

    # h5file = h5open("C:/Users/zvig/.julia/dev/JENVI.jl/Data/gamma_maps_global1.hdf5","r+")
    # h5file["SmoothSpectra"] = smooth_arr
    # close(h5file)

    f = open("C:/Users/zvig/.julia/dev/JENVI.jl/Data/global_wvl/smoooth_wvl.txt","w")
    for i in smooth_λ
        write(f,"$(i)\n")
    end
    close(f)

end

smooth_im("C:/Users/zvig/.julia/dev/JENVI.jl/Data/gamma_maps_global1.hdf5")