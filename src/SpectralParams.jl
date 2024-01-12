module SpectralParams

export RemoveContinuum,convexhull_removal,doubleLine_removal
export SpecUtils,pullλ,findλ

include("RemoveContinuum.jl")
using .RemoveContinuum

include("SpecUtils.jl")
using .SpecUtils

end
