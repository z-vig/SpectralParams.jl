#RemoveContinuum.jl
module RemoveContinuum



export convexhull_removal

"""
This module allows the user to remove the continuum using various methods.

1. Convex Hull Removal
2. 1000 μm band Removal
3. 2000 μm band Removal
4. 2-point line Removal

All input images must be 3 dimensions, with the third dimension being spectral
"""

using LazySets
using Interpolations
function convexhull_removal(image::Array{<:AbstractFloat,3},λ::Vector{Float64})
    #Make sure the image has dimension 3 as the spectral dimension

    #Augmenting ends of spectra with bottom points of convex hull
    augim = zeros(size(image,1),size(image,2),size(image,3)+2)
    augim[:,:,2:end-1] = image
    augim[:,:,1] = minimum(image,dims=3).-1
    augim[:,:,end] = minimum(image,dims=3).-1

    augλ = zeros(size(λ,1)+2)
    augλ[2:end-1] = λ
    augλ[1] = λ[1]-1
    augλ[end] = λ[end]+1
    
    #Getting coord array to broadcast the following functions: run_cvhx, run_cvhy
    coord_arr = [(x,y) for x in 1:size(augim,1),y in 1:size(augim,2)]

    function run_cvhx(pt)
        #Function that returns x coordinates of convex hull
        x = first(pt)
        y = last(pt)
        pts = [[i,j] for (i,j) in zip(augim[x,y,:],augλ)]
        [i[1] for i in convex_hull(pts)][2:end-1]
    end

    function run_cvhy(pt)
        #Function that returns y coordinates of convex hull
        x = first(pt)
        y = last(pt)
        pts = [[i,j] for (i,j) in zip(augim[x,y,:],augλ)]
        [i[2] for i in convex_hull(pts)][2:end-1]
    end

    #Running functions...
    hull_arr_y = run_cvhx.(coord_arr)
    hull_arr_x = run_cvhy.(coord_arr)

    
    function run_linearinterp(pt)
        #Interpolating between convex hull points and applying to desired wavelengths
        xs = hull_arr_x[pt...]
        ys = hull_arr_y[pt...]
        lin_interp = linear_interpolation(xs,ys,extrapolation_bc=Interpolations.Line())
        return lin_interp.(λ)
    end
    
    #Getting continuum...
    continuum = run_linearinterp.(coord_arr)

    #Turning 2d array of vectors into a 3d array
    continuum = permutedims([continuum[I][k] for k=eachindex(continuum[1,1]),I=CartesianIndices(continuum)],(2,3,1))

    #Removing convexhull continuum
    im_contrem = image./continuum

    return im_contrem

end




end #RemoveContinuum