#BandCenter.jl
module BandCenter

using ..SpectralParams: findλ,movingavg,make3d
using BSplineKit
using Polynomials
export locate_bandcenter

"""
This module allows the user to map the band centers around specified absorption minima
"""

function locate_bandcenter(image::Array{<:AbstractFloat,3},λ,λrange::Tuple{Float64,Float64} ; fit_type="Spline",degree=4)
    """
    This function will first pick out the specified range to look for an absorption minimum, then it will either fit a cubic spline or a fourth order polynomial to find the minimum. The wavelength of this minimum is then returned.
    """
    
    minλ_ind = findλ(λ,λrange[1])[1]
    maxλ_ind = findλ(λ,λrange[2])[1]
    cropim = image[:,:,minλ_ind:maxλ_ind]
    cropλ = λ[minλ_ind:maxλ_ind]

    coord_arr = [(x,y) for x in 1:size(image,1),y in 1:size(image,2)]

    if fit_type == "Spline"
        spl_range = 1:3:size(cropim,3)
        pre_im = cropim[:,:,spl_range]
        pre_λ = cropλ[spl_range]
        splineλ = cropλ[1:spl_range[end]]

        function run_spline(pt)
            spec = pre_im[pt...,:]
            itp = BSplineKit.interpolate(pre_λ,spec,BSplineOrder(4))
            return itp.(splineλ)
        end

        spline_im = run_spline.(coord_arr)
        spline_im = make3d(spline_im)
        bc_map = splineλ[getindex.(argmin(spline_im,dims=3),3)]

        return cropim,cropλ,spline_im,splineλ,bc_map[:,:,1]
    end

    if fit_type == "Polynomial"
        polyλ = cropλ[1]:10:cropλ[end]
        function run_polynomial(pt)
            spec = cropim[pt...,:]
            p = fit(cropλ,spec,degree)
            return p.(polyλ)
        end

        polyim = run_polynomial.(coord_arr)
        polyim = make3d(polyim)
        bc_map = polyλ[getindex.(argmin(polyim,dims=3),3)]

        return cropim,cropλ,polyim,polyλ,bc_map[:,:,1]
    end

    

end

end #BandCenter