#IBD.jl
module IBD
export IBD_map

"""
This module allows the mapping of integrated band depths by specifying the begining wavelength, ending wavelength and the integration step size
"""

function IBD_map(image::Array{<:AbstractFloat,3}continuum::Array{<:AbstractFloat,3},λvec::Vector{Float64},λ₁::Real,λ₂::Real,step::Int)
    println("Hello World!")
end


end #IBD