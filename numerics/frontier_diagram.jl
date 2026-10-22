# Original scaling schematic for chapter 13. No external Julia packages.
using Printf
out = joinpath(dirname(@__DIR__), "figs", "frontier-information-scales.svg")
open(out,"w") do io
    println(io,"<svg xmlns='http://www.w3.org/2000/svg' width='1000' height='470' viewBox='0 0 1000 470'><rect width='1000' height='470' rx='14' fill='#faf8f3'/><g font-family='DejaVu Sans,sans-serif' fill='#223640'>")
    println(io,"<text x='48' y='42' font-size='25' font-weight='bold'>Transport and loss of charge-position information</text>")
    println(io,"<text x='52' y='78' font-size='18'>A local disturbance spreads diffusively.</text><text x='52' y='105' font-size='18'>Global probability overlaps build order faster.</text>")
    x(t)=120+750*log10(t)/2
    y(l)=385-240*log10(l)/2
    for tick in [1,10,100]
        println(io,"<path d='M $(x(tick)) 140 V 385' stroke='#dce2df'/><text x='$(x(tick))' y='411' text-anchor='middle' font-size='17'>$tick</text>")
        println(io,"<path d='M 120 $(y(tick)) H 870' stroke='#dce2df'/><text x='100' y='$(y(tick)+6)' text-anchor='end' font-size='17'>$tick</text>")
    end
    println(io,"<path d='M 120 140 V 385 H 900' fill='none' stroke='#52646b' stroke-width='2'/>")
    for (power,color) in [(1.0,"#007f86"),(.5,"#d17637")]
        points=join([@sprintf("%.3f,%.3f",x(t),y(t^power)) for t in 10 .^ range(0,2;length=100)]," ")
        println(io,"<polyline points='$points' fill='none' stroke='$color' stroke-width='4'/>")
    end
    println(io,"<text x='500' y='170' font-size='21' fill='#007f86'>Information length ∝ t</text><text x='570' y='355' font-size='21' fill='#b8692d'>Transport length ∝ √t</text>")
    println(io,"<text x='500' y='451' text-anchor='middle' font-size='18'>Time (logarithmic scale; arbitrary units)</text><text x='50' y='134' font-size='17'>Length (log scale)</text></g></svg>")
end
println(out)
