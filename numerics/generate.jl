#=
Reproduce all numerical data and original SVG figures using Julia standard libraries.
Run from any directory: julia --project=numerics numerics/generate.jl
CSV columns and plot axes are documented in 17-computational-lab.qmd.
No sampling is used: calculations are exact finite-size enumeration or linear algebra.
=#
using LinearAlgebra, Printf, Random
const ROOT = dirname(@__DIR__)
const FIG = joinpath(ROOT, "figs")
const DATA = joinpath(@__DIR__, "data")
mkpath(FIG); mkpath(DATA)
const COLORS = ["#007f86", "#d17637", "#5863a6", "#ba5262"]
esc(s) = replace(string(s), "&"=>"&amp;", "<"=>"&lt;", ">"=>"&gt;")
function txt(io,x,y,s; size=20,fill="#223640",anchor="start",weight="normal")
    println(io,"<text x='$x' y='$y' font-size='$size' fill='$fill' text-anchor='$anchor' font-weight='$weight'>$(esc(s))</text>")
end
function svgfile(name, draw; w=1000,h=560)
    open(joinpath(FIG,name*".svg"),"w") do io
        println(io,"<svg xmlns='http://www.w3.org/2000/svg' width='$w' height='$h' viewBox='0 0 $w $h'><rect width='$w' height='$h' rx='12' fill='#faf8f3'/><g font-family='DejaVu Sans, sans-serif'>")
        draw(io)
        println(io,"</g></svg>")
    end
end
function plot(name,title,xlabel,ylabel,series; xlim,ylim,xticks,yticks,note="")
    svgfile(name, io->begin
        x0,y0,pw,ph=100.,90.,850.,340.
        X(x)=x0+pw*(x-xlim[1])/(xlim[2]-xlim[1])
        Y(y)=y0+ph-ph*(y-ylim[1])/(ylim[2]-ylim[1])
        txt(io,60,44,title;size=25,weight="bold")
        for y in yticks
            yy=Y(y)
            println(io,"<path d='M $x0 $yy H $(x0+pw)' stroke='#dce2df' stroke-width='1'/>")
            txt(io,x0-14,yy+6,@sprintf("%.2g",y);size=17,anchor="end")
        end
        for x in xticks
            xx=X(x)
            txt(io,xx,y0+ph+28,@sprintf("%.3g",x);size=17,anchor="middle")
        end
        println(io,"<path d='M $x0 $y0 V $(y0+ph) H $(x0+pw)' fill='none' stroke='#52646b' stroke-width='2'/>")
        for (k,s) in enumerate(series)
            coords=join([@sprintf("%.3f,%.3f",X(x),Y(y)) for (x,y) in zip(s.x,s.y)]," ")
            println(io,"<polyline points='$coords' fill='none' stroke='$(COLORS[k])' stroke-width='3'/>")
            lx=110+(k-1)*215
            println(io,"<path d='M $lx 500 h 28' stroke='$(COLORS[k])' stroke-width='4'/>")
            txt(io,lx+38,506,s.label;size=17)
        end
        txt(io,x0+pw/2,478,xlabel;size=19,anchor="middle")
        txt(io,96,76,ylabel;size=17)
        txt(io,60,545,note;size=15,fill="#60717a")
    end)
end
function csv(name,header,rows)
    open(joinpath(DATA,name),"w") do io
        println(io,join(header,","))
        foreach(r->println(io,join(r,",")),rows)
    end
end

# Independent bond errors. Integer s labels an X-basis configuration.
function bond_distribution(N, edges, p)
    P=zeros(2^N); P[1]=1
    for (i,j) in edges
        mask=(1<<(i-1)) ⊻ (1<<(j-1))
        P=[(1-p)*P[s+1]+p*P[(s⊻mask)+1] for s in 0:2^N-1]
    end
    P
end
function diagonal_correlators(P,i,j)
    mask=(1<<(i-1)) ⊻ (1<<(j-1))
    Q=[P[(s⊻mask)+1] for s in 0:length(P)-1]
    (sum(sqrt.(P.*Q)),dot(P,Q)/dot(P,P))
end
openchain(N)=[(i,i+1) for i in 1:N-1]
rows=Vector{Any}()
for N in [4,6,8], p in [0.0,0.1,0.25,0.4,0.5], r in 1:N-1
    P=bond_distribution(N,openchain(N),p)
    F,R2=diagonal_correlators(P,1,1+r)
    f=(2sqrt(p*(1-p)))^r
    r2=(2p*(1-p)/(p^2+(1-p)^2))^r
    @assert isapprox(sum(P),1;atol=1e-12)
    @assert all(P[s+1]==0 for s in 0:2^N-1 if isodd(count_ones(s)))
    @assert isapprox(F,f;atol=1e-12)
    @assert isapprox(R2,r2;atol=1e-12)
    push!(rows,[N,p,r,F,F,R2,f,r2])
end
csv("chain.csv",["N","p","r","F","R1","R2","F_formula","R2_formula"],rows)
r=collect(0:20)
plot("chain-overlaps","Exact one-dimensional pair-error channel","Separation r","Root fidelity F = R1",
    [(x=r,y=(2sqrt(p*(1-p))).^r,label="p = $p") for p in [0.1,0.25,0.4,0.5]];
    xlim=(0,20),ylim=(0,1),xticks=0:5:20,yticks=0:.25:1,
    note="Analytic transfer result; finite-chain enumeration agrees to < 10^-12.")

# Two-dimensional periodic small lattices: a demonstration, not threshold fitting.
rows=Vector{Any}()
for L in [3,4]
    site(x,y)=mod(x,L)+L*mod(y,L)+1
    edges=Tuple{Int,Int}[]
    for x in 0:L-1,y in 0:L-1
        push!(edges,(site(x,y),site(x+1,y)),(site(x,y),site(x,y+1)))
    end
    for p in [0.05,0.1,0.109,0.15,0.178203,0.25,0.5]
        P=bond_distribution(L^2,edges,p)
        F,R2=diagonal_correlators(P,1,site(L÷2,L÷2))
        push!(rows,[L,L^2,p,F,F,R2])
    end
end
csv("square-finite.csv",["L","N","p","F","R1","R2"],rows)

# General noncommuting density matrix in one fixed parity sector.
Random.seed!(73021)
N=4; d=2^N
sector=[s+1 for s in 0:d-1 if iseven(count_ones(s))]
M=randn(ComplexF64,length(sector),length(sector))
B=M*M'; B/=tr(B)
rho=zeros(ComplexF64,d,d); rho[sector,sector]=B
A=zeros(ComplexF64,d,d)
for s in 0:d-1
    A[(s⊻3)+1,s+1]=1
end
ev=eigen(Hermitian(rho)); sr=ev.vectors*Diagonal(sqrt.(max.(ev.values,0)))*ev.vectors'
F=sum(svdvals(sr*A*sr)); R1=real(tr(sr*A*sr*A')); R2=real(tr(rho*A*rho*A'))/real(tr(rho*rho))
@assert -1e-12<=R1<=F+1e-12<=1+1e-12
@assert F^2<=R1+1e-12
csv("noncommuting.csv",["seed","N","F","R1","R2","linear"],[[73021,N,F,R1,R2,real(tr(rho*A))]])

# Weakly symmetry-breaking noise on the parity ensemble.
h2(x)=x==0||x==1 ? 0.0 : -x*log(x)-(1-x)*log1p(-x)
ps=collect(range(0,.08;length=161))
rows=Vector{Any}()
for N in [8,32,128],p in ps
    lambda=(1-2p)^N
    push!(rows,[N,p,lambda,sqrt(max(0,1-lambda^2)),log(2)-h2((1+lambda)/2)])
end
csv("parity-perturbation.csv",["N","p","lambda","one_point_F","CMI_nats"],rows)
plot("parity-response","A small explicit symmetry-breaking channel","Single-site error probability p","One-point root fidelity",
    [(x=ps,y=sqrt.(max.(0,1 .-(1 .-2ps).^(2N))),label="N = $N") for N in [8,32,128]];
    xlim=(0,.08),ylim=(0,1),xticks=0:.02:.08,yticks=0:.25:1,
    note="Exact finite N; the thermodynamic and zero-noise limits do not commute.")

# Diffusion on a periodic lattice, exactly diagonalized in Fourier space.
N=64; D=1.; times=[1.,8.,32.,128.]; xs=collect(0:N-1)
function diffusion_profile(t)
    [real(sum(exp(-4D*sin(pi*m/N)^2*t)*exp(2pi*im*m*x/N) for m in 0:N-1))/N for x in xs]
end
profiles=[diffusion_profile(t) for t in times]
for P in profiles
    @assert isapprox(sum(P),1;atol=1e-12)
    @assert minimum(P)>-1e-12
end
csv("diffusion.csv",["x","t1","t8","t32","t128"],[[x;[P[x+1] for P in profiles]] for x in xs])
plot("diffusion","Diffusion from an initially localized charge","Position relative to initial site","Density",
    [(x=collect(-32:31),y=[P[mod(x,N)+1] for x in -32:31],label="t = $(Int(t))") for (t,P) in zip(times,profiles)];
    xlim=(-32,32),ylim=(0,.32),xticks=-30:10:30,yticks=0:.08:.32,
    note="Periodic N = 64; eigenvalues -4D sin^2(k/2), D = 1; no Monte Carlo noise.")

ells=collect(0:100);nu=.4
plot("block-variance","Local fluctuations with an exactly fixed total charge","Block size l (N = 100)","Variance of block charge",
    [(x=ells,y=ells.*nu*(1-nu).*(100 .-ells)/99,label="Fixed Q = 40"),
     (x=ells,y=ells.*nu*(1-nu),label="Independent sites")];
    xlim=(0,100),ylim=(0,25),xticks=0:20:100,yticks=0:5:25,
    note="Hypergeometric finite-population correction; local agreement does not imply global agreement.")
csv("block-variance.csv",["ell","canonical","grand_canonical"],[[l,l*nu*(1-nu)*(100-l)/99,l*nu*(1-nu)] for l in ells])

function box(io,x,y,w,h,color,title,lines)
    println(io,"<rect x='$x' y='$y' width='$w' height='$h' rx='14' fill='$color' stroke='#a8b8b8'/>")
    txt(io,x+20,y+34,title;size=23,weight="bold")
    for (k,l) in enumerate(lines);txt(io,x+20,y+62+26k,l;size=18);end
end
svgfile("information-regions",io->begin
    txt(io,45,45,"Local correlations and global constraints";size=27,weight="bold")
    box(io,45,100,210,230,"#dceeed","A: probe",["Fixed local region","Charged operation","Untouched by recovery"])
    box(io,280,100,285,230,"#eee5d3","B: buffer",["Width l_B is varied","Mediates ordinary","short-range correlations"])
    box(io,590,100,365,230,"#e1e5f2","C: distant remainder",["Can hold a global constraint","Invisible to separate probes","Correlated after conditioning"])
    txt(io,50,395,"MI: what do A and C share without knowing B?";size=23)
    txt(io,50,444,"CMI: what remains shared when B is known?";size=23)
    txt(io,50,512,"Fixed parity: MI = 0, CMI = ln 2 for nonempty A, B, C covering the system.";size=19)
end)
svgfile("symmetry-map",io->begin
    txt(io,45,45,"A symmetry has two meanings for a mixed state";size=27,weight="bold")
    box(io,45,90,420,200,"#dceeed","Strong symmetry",["U rho = exp(i alpha) rho","One global charge sector","Every ensemble vector shares charge"])
    box(io,525,90,430,200,"#eee5d3","Weak symmetry",["U rho U* = rho  (* = adjoint)","The ensemble is invariant","Different charge sectors may mix"])
    txt(io,495,200,"implies";size=17,anchor="middle")
    box(io,130,340,740,145,"#e1e5f2","Strong-to-weak spontaneous order",["Exact strong symmetry at finite size; long-range nonlinear overlap.","Ordinary charged two-point correlations decay."])
    txt(io,50,535,"Spontaneous order does not mean the finite-size density matrix loses its exact symmetry.";size=18)
end)
println("Generated ",length(readdir(DATA))," CSV files and ",count(endswith(".svg"),readdir(FIG))," SVG figures.")
println("Verified normalization, parity support, exact 1D formulas, fidelity bounds, and diffusion conservation.")
