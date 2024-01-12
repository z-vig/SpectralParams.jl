using SpectralParams

λ=pullλ("./Data/wvl/wvl_data.txt")
ind,realλ = findλ(λ,1200)
println(ind,"   ",realλ)


