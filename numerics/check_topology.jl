# Exact small-system checks for Chapters 10–12. Julia standard library only.
# Run: julia numerics/check_topology.jl
using LinearAlgebra

const SX = ComplexF64[0 1; 1 0]
const SZ = ComplexF64[1 0; 0 -1]
const S0 = Matrix{ComplexF64}(I, 2, 2)
function pauli(n, assignments)
    reduce(kron, [get(assignments, j, S0) for j in 1:n])
end
function entropy(rho)
    vals = eigvals(Hermitian((rho + rho') / 2))
    -sum(x * log(x) for x in vals if x > 1e-12)
end
# Partial trace with site 1 the most significant bit.
function marginal(rho, n, kept)
    lost = setdiff(1:n, kept)
    out = zeros(ComplexF64, 2^length(kept), 2^length(kept))
    bits(x, sites) = [Int((x >> (n-j)) & 1) for j in sites]
    pack(bs) = foldl((a,b) -> 2a+b, bs; init=0)
    for a in 0:2^n-1, b in 0:2^n-1
        bits(a, lost) == bits(b, lost) || continue
        out[pack(bits(a, kept))+1, pack(bits(b, kept))+1] += rho[a+1,b+1]
    end
    out
end
function dephase(rho, ops, p)
    for op in ops
        rho = (1-p)*rho + p*op*rho*op'
    end
    rho
end

n = 6
d = 2^n
identity_n = Matrix{ComplexF64}(I, d, d)
Ks = [pauli(n, Dict(mod1(j-1,n)=>SZ, j=>SX, mod1(j+1,n)=>SZ)) for j in 1:n]
rho_C = reduce(*, [identity_n+K for K in Ks]) / d
@assert isapprox(tr(rho_C), 1; atol=1e-12)
@assert isapprox(tr(rho_C^2), 1; atol=1e-12)
ops_B = [pauli(n, Dict(j=>SZ)) for j in 2:2:n]
rho_star = dephase(rho_C, ops_B, 0.5)
expected_star = reduce(*, [identity_n+Ks[j] for j in 1:2:n]) / d
@assert isapprox(rho_star, expected_star; atol=1e-12)
@assert count(>(1e-10), eigvals(Hermitian(rho_star))) == 2^(n÷2)
@assert isapprox(entropy(rho_star), (n÷2)*log(2); atol=1e-12)
GA = pauli(n, Dict(j=>SX for j in 1:2:n))
GB = pauli(n, Dict(j=>SX for j in 2:2:n))
@assert isapprox(GA*rho_star, rho_star; atol=1e-12)
@assert isapprox(GB*rho_star*GB, rho_star; atol=1e-12)
@assert !isapprox(GB*rho_star, rho_star; atol=1e-12)
pair = pauli(n, Dict(1=>SZ,3=>SZ))
@assert norm(rho_star * pair * rho_star * pair) < 1e-12
p = 0.17
rho_p = dephase(rho_C, ops_B, p)
@assert isapprox(real(tr(rho_p*Ks[1]*Ks[3])), 1; atol=1e-12)
@assert isapprox(real(tr(rho_p*Ks[2]*Ks[4])), (1-2p)^2; atol=1e-12)
rho_A = marginal(rho_star, n, [1,3,5])
GA_small = kron(SX,SX,SX)
@assert isapprox(rho_A, (Matrix{ComplexF64}(I,8,8)+GA_small)/8; atol=1e-12)
ops_pairs = [pauli(n, Dict(a=>SZ,b=>SZ)) for (a,b) in [(1,3),(3,5),(5,1)]]
rho_end = dephase(rho_star, ops_pairs, 0.5)
@assert isapprox(rho_end, (identity_n+GA)/d; atol=1e-12)

# Reference-entangled repetition code under independent X noise.
p_code = 0.12
bell = zeros(ComplexF64, 16)
bell[1] = inv(sqrt(2))
bell[16] = inv(sqrt(2))
rho_RB = zeros(ComplexF64,16,16)
joint = Dict{Tuple{Int,Int,Int},Float64}()
syndrome = Dict{Tuple{Int,Int},Float64}()
for e in 0:7
    eb = [Int((e >> (3-j)) & 1) for j in 1:3]
    weight = p_code^sum(eb) * (1-p_code)^(3-sum(eb))
    err = pauli(3, Dict(j=>SX for j in 1:3 if eb[j]==1))
    vec = kron(S0,err)*bell
    global rho_RB += weight * vec * vec'
    s = (xor(eb[1],eb[2]), xor(eb[2],eb[3]))
    joint[(s[1],s[2],eb[1])] = weight
    syndrome[s] = get(syndrome,s,0.0)+weight
end
shannon(xs) = -sum(x*log(x) for x in xs if x>0)
Ic = entropy(marginal(rho_RB,4,[2,3,4]))-entropy(rho_RB)
Ic_posterior = log(2)-shannon(values(joint))+shannon(values(syndrome))
@assert isapprox(Ic,Ic_posterior; atol=1e-12)
# Four-spin maximally mixed singlet: logarithmic negativity across 12|34.
alpha = zeros(ComplexF64,16)
beta = zeros(ComplexF64,16)
for (i,amplitude) in [(5,0.5),(6,-0.5),(9,-0.5),(10,0.5)]
    alpha[i+1] = amplitude
end
for i in [3,12]
    beta[i+1] = 1/sqrt(3)
end
for i in [5,6,9,10]
    beta[i+1] = -1/(2sqrt(3))
end
rho_singlet = (alpha*alpha'+beta*beta')/2
ptB = zeros(ComplexF64,16,16)
for a in 0:15, b in 0:15
    aA,aB = divrem(a,4)
    bA,bB = divrem(b,4)
    ptB[4aA+bB+1,4bA+aB+1] = rho_singlet[a+1,b+1]
end
@assert isapprox(log(sum(abs,eigvals(Hermitian(ptB)))), log(2); atol=1e-12)
totalX = sum(pauli(4,Dict(j=>SX)) for j in 1:4)/2
totalZ = sum(pauli(4,Dict(j=>SZ)) for j in 1:4)/2
@assert norm(totalX*rho_singlet)<1e-12 && norm(totalZ*rho_singlet)<1e-12
println("PASS: cluster stabilizers, dephasing, strings, rank/entropy, strong/weak symmetry,")
println("      traced parity state, pair-noise endpoint, coherent-information posterior,")
println("      and four-spin singlet logarithmic negativity.")
