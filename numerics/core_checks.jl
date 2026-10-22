# Independent exact checks supporting Chapters 5--9.
# Run: julia --startup-file=no numerics/core_checks.jl
# Uses only Julia standard libraries.
using LinearAlgebra, Random

const Xc = ComplexF64[0 1; 1 0]
const Zc = ComplexF64[1 0; 0 -1]
const Ic = Matrix{ComplexF64}(I, 2, 2)

function onsite(op, site, n)
    reduce(kron, [i == site ? op : Ic for i in 1:n])
end

function psqrt(m)
    e = eigen(Hermitian((m + m') / 2))
    e.vectors * Diagonal(sqrt.(max.(e.values, 0))) * e.vectors'
end

function diagnostics(rho, a)
    sr = psqrt(rho)
    (sum(svdvals(sr * a * sr)),
     real(tr(sr * a * sr * a')),
     real(tr(rho * a * rho * a')) / real(tr(rho * rho)))
end

function bond_state(n, edges, p)
    plus = fill(ComplexF64(2.0^(-n/2)), 2^n)
    rho = plus * plus'
    for (i, j) in edges
        a = onsite(Zc, i, n) * onsite(Zc, j, n)
        rho = (1-p) * rho + p * a * rho * a'
    end
    rho
end

function clean_ising_corr(n, edges, coupling, i, j)
    num = 0.0
    den = 0.0
    for s in 0:2^n-1
        spins = [iszero(s & (1 << (k-1))) ? 1 : -1 for k in 1:n]
        weight = exp(coupling * sum(spins[a] * spins[b] for (a,b) in edges))
        den += weight
        num += weight * spins[i] * spins[j]
    end
    num / den
end

Random.seed!(260622)
maxerr = 0.0
for n in 3:6, p in (0.07, 0.23, 0.41), r in 1:n-1
    rho = bond_state(n, [(i,i+1) for i in 1:n-1], p)
    a = onsite(Zc, 1, n) * onsite(Zc, 1+r, n)
    f, r1, r2 = diagnostics(rho, a)
    expectedf = (2sqrt(p*(1-p)))^r
    expected2 = (2p*(1-p)/(p^2+(1-p)^2))^r
    err = maximum(abs.([f-expectedf, r1-expectedf, r2-expected2]))
    global maxerr = max(maxerr, err)
    @assert err < 2e-7
end

# Four sites on an open square: compares matrix-channel output with the
# separately enumerated clean classical model.
edges = [(1,2), (2,4), (4,3), (3,1)]
for p in (0.03, 0.17, 0.37)
    rho = bond_state(4, edges, p)
    a = onsite(Zc, 1, 4) * onsite(Zc, 4, 4)
    _, _, r2 = diagnostics(rho, a)
    exact = clean_ising_corr(4, edges, -log(1-2p), 1, 4)
    @assert abs(r2-exact) < 1e-12
end

# Noncommuting random positive matrices: verifies both affinity bounds,
# including cases where R1 and fidelity differ.
for _ in 1:50
    m = randn(ComplexF64, 6, 6)
    rho = m*m'
    rho /= tr(rho)
    a = Matrix(qr(randn(ComplexF64, 6, 6)).Q)
    f, r1, r2 = diagnostics(rho, a)
    @assert f^2 <= r1 + 1e-12
    @assert r1 <= f + 1e-12
    @assert -1e-12 <= r2 <= 1 + 1e-12
end

# Spectral counterexample with finite fidelity and vanishing Renyi-2.
for n in 3:6
    d = 2^(n-1)
    plus = fill(ComplexF64(2.0^(-n/2)), 2^n)
    u = reduce(kron, fill(Xc, n))
    sector = (Matrix{ComplexF64}(I,2^n,2^n)+u)/2^n
    w = 0.37
    rho = w*(plus*plus') + (1-w)*sector
    a = onsite(Zc, 1, n) * onsite(Zc, n, n)
    f, r1, r2 = diagnostics(rho, a)
    t = (1-w)/d
    @assert abs(f-((d-2)*t+2sqrt(t*(w+t)))) < 1e-7
    @assert abs(r2-(1-w^2)/(d*w^2+1-w^2)) < 1e-12
end

# Channel-response factor: squared one-point fidelity differentiates to
# 4N times the squared fidelity with the averaged pair-insertion state.
# The test uses a noncommuting mixed state of full rank in one parity sector.
nresponse = 3
uresponse = reduce(kron, fill(Xc, nresponse))
presponse = (Matrix{ComplexF64}(I, 2^nresponse, 2^nresponse)+uresponse)/2
mresponse = randn(ComplexF64, 2^nresponse, 2^nresponse)
rresponse = presponse*mresponse*mresponse'*presponse
rresponse /= tr(rresponse)
zresponse = [onsite(Zc,j,nresponse) for j in 1:nresponse]
state_fidelity(r,s) = sum(svdvals(psqrt(r)*psqrt(s)))
chiresponse = 0.0
for zi in zresponse
    averaged = sum(zi*zj*rresponse*zj*zi for zj in zresponse)/nresponse
    coefficient = nresponse*state_fidelity(rresponse,averaged)^2
    pairvalues = [state_fidelity(rresponse,zi*zj*rresponse*zj*zi) for zj in zresponse]
    @assert sum(pairvalues.^2) <= coefficient + 1e-7
    @assert coefficient <= min(nresponse,sum(pairvalues)^2) + 1e-7
    global chiresponse += 4coefficient/nresponse
end
presponsenoise = 1e-5
rperturbed = copy(rresponse)
for zi in zresponse
    global rperturbed = (1-presponsenoise)*rperturbed + presponsenoise*zi*rperturbed*zi
end
measuredresponse = sum(state_fidelity(rperturbed,zi*rperturbed*zi)^2 for zi in zresponse)/nresponse/presponsenoise
@assert abs(measuredresponse-chiresponse)/chiresponse < 1e-3

println("All exact core checks passed; largest chain discrepancy = ", maxerr)
println("Squared-fidelity susceptibility: analytic = ", chiresponse,
        "; finite p = ", measuredresponse)
