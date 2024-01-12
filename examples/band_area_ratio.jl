#band_area_ratio.jl

using SpectralParams
using GLMakie

h5file = h5open("C:/Users/zvig/.julia/dev/SpectralParams.jl/Data/gd_region_smoothed.hdf5")
im = read(h5file["gamma"])
close(h5file)

h5file = h5open("C:/Users/zvig/.julia/dev/SpectralParams.jl/Data/IBD_maps/gd_region_IBD1000.hdf5")
ibd1 = read(h5file["gamma"])
close(h5file)

h5file = h5open("C:/Users/zvig/.julia/dev/SpectralParams.jl/Data/IBD_maps/gd_region_IBD2000.hdf5")
ibd2 = read(h5file["gamma"])
close(h5file)

bdr_map = band_area_ratio(ibd1,ibd2)
shadowmask = mean(im,dims=3)[:,:,1].<0.05
bdr_map[shadowmask] .= -9999

hist_vals = vec(bdr_map[((bdr_map.>0).&&(bdr_map.<5))])

f = Figure()
ax1 = GLMakie.Axis(f[1,1])
ax2 = GLMakie.Axis(f[1,2])
ax3 = GLMakie.Axis(f[2,1])
ax4 = GLMakie.Axis(f[2,2])
image!(ax1,bdr_map,colorrange=(0,5))
hist!(ax2,hist_vals)

sl = Slider(f[3,1],range=range(1,6,1000),startvalue=3)

bdr_copy = zeros(size(bdr_map))
clustered_im = lift(sl.value) do val
    println(val)
    bdr_copy[bdr_map.<0] .= 1
    bdr_copy[0 .< bdr_map .< val] .= 2
    bdr_copy[val .< bdr_map .< 7] .= 3
    bdr_copy[bdr_map.>7] .= 4
    return bdr_copy
end


flattened_im = reshape(im,size(im,1)*size(im,2),size(im,3))

cl1av = lift(clustered_im) do c_im
    flat_clusters = vec(c_im)
    return vec(mean(flattened_im[flat_clusters.==2,:],dims=1))
end

cl2av = lift(clustered_im) do c_im
    flat_clusters = vec(c_im)
    return vec(mean(flattened_im[flat_clusters.==3,:],dims=1))
end

println(size(to_value(cl1av)))

image!(ax3,im[:,:,end])
image!(ax3,clustered_im,colormap=[:black,:green,:blue,:white],alpha=0.5)

slider_val = lift(sl.value) do val
    "Cutoff Band Depth Ratio: $(round(val,digits=2))"
end

Label(f[4,1],slider_val,tellwidth=false)

λ = pullλ("C:/Users/zvig/.julia/dev/SpectralParams.jl/Data/wvl/smoothed_wvl_data.txt")
lines!(ax4,λ,cl1av,color=:green,label="Cluster 1 Average")
lines!(ax4,λ,cl2av,color=:blue,label="Cluster 2 Average")
axislegend(ax4)

f