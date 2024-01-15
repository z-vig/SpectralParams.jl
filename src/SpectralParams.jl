module SpectralParams

export SpecUtils,pullλ,findλ,movingavg
export RemoveContinuum,convexhull_removal,doubleLine_removal
export IBD,IBD_map,band_area_ratio
export BandCenter,locate_bandcenter

include("SpecUtils.jl")
using .SpecUtils

include("RemoveContinuum.jl")
using .RemoveContinuum

include("BandMath/IBD.jl")
using .IBD

include("BandMath/BandCenter.jl")
using .BandCenter

end
