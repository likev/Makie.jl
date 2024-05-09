# This file was generated, do not modify it. # hide
using Makie.LaTeXStrings: @L_str                       # hide
__result = begin                                       # hide
    function Makie.plot!(plot::Hist{<:Tuple{<:MyHist}})
    # Only forward valid attributes for BarPlot
    valid_attributes = Makie.shared_attributes(plot, BarPlot)
    barplot!(plot, valid_attributes, plot[1])
end
h = MyHist([1, 10, 100], 1:3)
hist(h; color=:red, direction=:x)
end                                                    # hide
sz = size(Makie.parent_scene(__result))                # hide
open(joinpath(@OUTPUT, "wrapping-recipes_size.txt"), "w") do io # hide
    print(io, sz[1], " ", sz[2])                       # hide
end                                                    # hide
save(joinpath(@OUTPUT, "wrapping-recipes.png"), __result; px_per_unit = 2, pt_per_unit = 0.75, ) # hide
save(joinpath(@OUTPUT, "wrapping-recipes.svg"), __result; px_per_unit = 2, pt_per_unit = 0.75, ) # hide
nothing # hide