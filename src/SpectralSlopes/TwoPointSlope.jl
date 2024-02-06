module TwoPointSlope

using ..SpectralParams: findλ
export slopemap

function slopemap(image::Array{<:AbstractFloat,3},λ::Vector{Float64},λmin::Float64,λmax::Float64)
    
    min_index = findλ(λ,λmin)[1]
    max_index = findλ(λ,λmax)[1]

    slope_map = Array{Float64}(undef,(size(image)[1:2]...,1))

    slope_map[:,:,1] .= (image[:,:,max_index] .- image[:,:,min_index]) ./ (max_index-min_index)

    return slope_map
end

end #TwoPointSlope