#SpecUtils.jl
module SpecUtils
export pullλ,findλ

"""
Module for all of your various spectral needs
"""


function pullλ(path::String)
    [parse(Float64,i) for i ∈ readlines(open(path))]
end

function findλ(wvls::Vector{Float64},targetλ::Real)
    diff_vec = abs.(wvls.-targetλ)
    located_ind = findall(diff_vec.==minimum(diff_vec))
    actualλ = diff_vec[located_ind]
    return located_ind[1],actualλ[1]
end

end