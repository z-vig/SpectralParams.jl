#IBD.jl
module IBD
export IBD_map

using ..SpectralParams: findλ

"""
This module allows the mapping of integrated band depths by specifying the begining wavelength, ending wavelength and the integration step number
"""

function IBD_map(image::Array{<:AbstractFloat,3},continuum::Array{<:AbstractFloat,3},λvec::Vector{Float64},λ₁::Real,λ₂::Real)
    min_λindex = findλ(λvec,λ₁)[1]
    max_λindex = findλ(λvec,λ₂)[1]
    λindices = min_λindex:1:max_λindex

    R = image[:,:,λindices]
    Rc = continuum[:,:,λindices]

    IBDmap = sum((1 .- (R ./ Rc)),dims=3)

    return IBDmap

end


end #IBD