# This file was generated, do not modify it. # hide
using Makie.LaTeXStrings: @L_str                       # hide
__result = begin                                       # hide
    using CairoMakie
CairoMakie.activate!() # hide

f = Figure()
Axis(f[1, 1])

ps = 0.8 .* Point2f[(-0.2, -0.5), (0.5, -0.5), (0.5, 0.5), (-0.5, 0.5), (-0.5, -0.2)]

for i in 1:3, j in 1:3
    lines!(
        ps .+ Point2f(i, -j), linewidth = 20,
        linecap = (:butt, :square, :round)[i],
        joinstyle = (:miter, :bevel, :round)[j]
    )
    scatterlines!(ps .+ Point2f(i, -j), color = :gray)
end

f
end                                                    # hide
sz = size(Makie.parent_scene(__result))                # hide
open(joinpath(@OUTPUT, "example_099fefe2_size.txt"), "w") do io # hide
    print(io, sz[1], " ", sz[2])                       # hide
end                                                    # hide
save(joinpath(@OUTPUT, "example_099fefe2.png"), __result; px_per_unit = 2, pt_per_unit = 0.75, ) # hide
save(joinpath(@OUTPUT, "example_099fefe2.svg"), __result; px_per_unit = 2, pt_per_unit = 0.75, ) # hide
nothing # hide