module SpectralParams

export SpecUtils,pullλ,findλ,movingavg,make3d
export RemoveContinuum,convexhull_removal,doubleLine_removal
export IBD,IBD_map,band_area_ratio
export BandCenter,locate_bandcenter
export TwoPointSlope,slopemap


include("SpecUtils.jl")
using .SpecUtils

include("RemoveContinuum.jl")
using .RemoveContinuum

include("BandMath/IBD.jl")
using .IBD

include("BandMath/BandCenter.jl")
using .BandCenter

include("SpectralSlopes/TwoPointSlope.jl")
using .TwoPointSlope


end
