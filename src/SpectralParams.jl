module SpectralParams

export SpecUtils,pullλ,findλ
export RemoveContinuum,convexhull_removal,doubleLine_removal
export IBD,IBD_map

include("SpecUtils.jl")
using .SpecUtils

include("RemoveContinuum.jl")
using .RemoveContinuum

include("BandDepths/IBD.jl")
using .IBD

end
