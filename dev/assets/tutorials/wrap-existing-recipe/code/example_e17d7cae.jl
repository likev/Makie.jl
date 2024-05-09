# This file was generated, do not modify it. # hide
using Makie.LaTeXStrings: @L_str                       # hide
__result = begin                                       # hide
    function Makie.plot!(plot::Hist{<:Tuple{<:MyHist}})
    barplot!(plot, plot[1])
    plot
end
h = MyHist([1, 10, 100], 1:3)
hist(h; color=:red, direction=:x)
end                                                    # hide
sz = size(Makie.parent_scene(__result))                # hide
open(joinpath(@OUTPUT, "example_e17d7cae_size.txt"), "w") do io # hide
    print(io, sz[1], " ", sz[2])                       # hide
end                                                    # hide
save(joinpath(@OUTPUT, "example_e17d7cae.png"), __result; px_per_unit = 2, pt_per_unit = 0.75, ) # hide
save(joinpath(@OUTPUT, "example_e17d7cae.svg"), __result; px_per_unit = 2, pt_per_unit = 0.75, ) # hide
nothing # hide