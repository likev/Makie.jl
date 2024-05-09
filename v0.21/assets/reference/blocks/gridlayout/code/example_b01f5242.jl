# This file was generated, do not modify it. # hide
using Makie.LaTeXStrings: @L_str                       # hide
__result = begin                                       # hide
    using CairoMakie
CairoMakie.activate!() # hide

f = Figure()

Axis(f[1, 1], title = "My column has size Fixed(400)")
Axis(f[1, 2], title = "My column has size Auto()")

colsize!(f.layout, 1, Fixed(400))
# colsize!(f.layout, 1, 400) would also work

f
end                                                    # hide
sz = size(Makie.parent_scene(__result))                # hide
open(joinpath(@OUTPUT, "example_b01f5242_size.txt"), "w") do io # hide
    print(io, sz[1], " ", sz[2])                       # hide
end                                                    # hide
save(joinpath(@OUTPUT, "example_b01f5242.png"), __result; px_per_unit = 2, pt_per_unit = 0.75, ) # hide
save(joinpath(@OUTPUT, "example_b01f5242.svg"), __result; px_per_unit = 2, pt_per_unit = 0.75, ) # hide
nothing # hide