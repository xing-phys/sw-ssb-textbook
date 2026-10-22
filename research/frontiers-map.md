# Frontier literature map

Cutoff checked against arXiv submission histories: **22 October 2026**. Started from [Wang's review](https://arxiv.org/abs/2606.02555), then followed its primary references and searched newer work. An arXiv identifier's apparent position within a month is not a reliable submission-date filter: 2610.26229 explicitly records 19 October and is included. HTML document headers sometimes display an unrelated processing date; use the abstract-page version history.

## Conceptual dependency graph

Conservation + locality → continuity equation → constitutive assumptions → diffusion. Fixed-charge mixed states → canonical purification → off-diagonal replica order → SW-SSB. The bridge between these routes needs a nontrivial static charge structure factor, suitable steady-state assumptions, and a dynamical generator. Neither extensive charge variance nor a nonlinear correlator alone determines transport.

Finite-time evolution from a charge product state → discrete worldlines and charge inference → distinction between ballistic information length and diffusive transport length → compact phase field/BKT in two dimensions. Gauging charge inference → topological decoding → disordered clock/loop models → information-critical phases. Detection requires specifying access: copies, canonical purification, local tomography, known channel, or a trained probability model.

## Hydrodynamics and limits

| Primary work | Metadata and URL | Role, assumptions, status |
|---|---|---|
| Ogunnaike, Feldmeier, Lee | 25 Apr 2023; PRL **131**, 220403 (2023); [2304.13028](https://arxiv.org/abs/2304.13028), DOI 10.1103/PhysRevLett.131.220403 | Brownian average mapped to doubled Lindblad operator; single-mode construction gives diffusion, multipole subdiffusion, long-range variants. Microscopic model results, not a theorem that arbitrary SW-SSB implies diffusion. |
| Moudgalya, Motrunich | 26 Sep 2023; PRX Quantum **5**, 040330 (2024); [2309.15167](https://arxiv.org/abs/2309.15167) | Symmetry commutants as frustration-free super-Hamiltonian ground states; approximate symmetries give low modes; fragmentation and scars broaden examples. |
| Huang, Qi, Zhang, Lucas | 9 Jul 2024; v2 20 Mar 2025; PRB **111**, 125147 (2025); [2407.08760](https://arxiv.org/abs/2407.08760) | U(1) SW-SSB EFT reproduces Schwinger–Keldysh diffusion, interprets response field as Goldstone. Equilibrium/detailed-balance and derivative-expansion qualifications essential. |
| Watanabe, Katsura, Lee | PRL **133**, 176001 (24 Oct 2024); [publisher](https://doi.org/10.1103/PhysRevLett.133.176001) | Frustration-free 1D zero-temperature U(1) SSB explains why ordinary finite-temperature HMW reasoning cannot be transferred indiscriminately to doubled Lindbladian ground states. |
| Gu, Wang, Wang | PRB **112**, 245123 (9 Dec 2025); [publisher](https://doi.org/10.1103/3g6d-gn7b) | Concrete Liouvillians and broken-symmetry patterns; Goldstone/diffusive modes for strong U(1). Qualify generality of claims by its model/dynamical conditions. |
| Hauser, Su, Ha, Lloyd, Kiely, Vasseur, Gopalakrishnan, Xu, Fisher | 17 Feb 2026; [2602.16045](https://arxiv.org/abs/2602.16045) | Three models; 1D nonlinear information length ∝t versus density diffusion ∝√t; field theory and numerics support 2D finite-time BKT-like transition; continuum hydrodynamics loses particle discreteness earlier than microscopic dynamics. |
| Delacrétaz | 1 Jun 2026; [2606.02391](https://arxiv.org/abs/2606.02391) | Pedagogical hydrodynamic EFT lectures, generalized symmetry/anomaly connections; supplementary reading, not substitute for derivations. |

Derivation opportunities: exact lattice exclusion-process density modes; stationary fixed-charge combinatorics; response-field diffusion action; Gaussian probability-overlap integral showing exp(−const r/t) in 1D and power law in 2D. Explicitly distinguish equal-time information length from transport length.

## Charge fluctuations, records, and learning

| Primary work | Metadata and URL | Claims and limitations |
|---|---|---|
| Lee | 6 May 2026; [2605.05288](https://arxiv.org/abs/2605.05288) | Rényi-1 order plus sufficiently fast asymptotic convergence (summable tail; stated as faster than r^−d) bounds block-charge variance from below extensively. Dephased nonnegative superfluid is a counterexample without fast convergence. Sparse fixed-charge projectors disprove converse. Twist overlaps separate doubled Q+ and Q−; Wigner–Yanase skew information is half Var(Q−). |
| Agrawal et al. | PRX **12**, 041002 (2022); [publisher](https://doi.org/10.1103/PhysRevX.12.041002) | Entanglement and charge-sharpening transitions in U(1) monitored circuits; keep records and posterior conditioning explicit. |
| Singh, Vasseur, Potter, Gopalakrishnan | 13 Mar 2025; PRB **113**, 054305 (2026); [2503.10308](https://arxiv.org/abs/2503.10308) | Learnability transitions in monitored noisy dynamics; inference is observer/access dependent. |
| Zerba, Gopalakrishnan, Knap | 16 Dec 2025; [2512.14830](https://arxiv.org/abs/2512.14830) | Dipole-conserving monitored circuits; charge and dipole sharpening differ; 2D critical phase with smectic-like anisotropic scaling. Theory/field-theory phase diagram. |
| Kumar, Zou, Negari, Melko, Hsieh | 11 Feb 2026, v2 18 Mar; [2602.11262](https://arxiv.org/abs/2602.11262) | Restricted statistical-query hardness theorem and neural-network demonstrations for globally constrained distributions. Does not prohibit every learner using arbitrary physical prior knowledge. |

## Information-critical and other transitions

| Primary work | Metadata and URL | Claims and limitations |
|---|---|---|
| Vijay, Lee | 26 Dec 2025; **v2 10 Aug 2026**; [2512.22121v2](https://arxiv.org/abs/2512.22121v2) | Decohered Z_N toric code maps directly to random-bond clock models for von Neumann CMI/coherent information. N>4 intermediate information-critical phase, partial logical memory; emergent U(1) in ungauged off-diagonal symmetry. Analytic mappings + numerics/continuum interpretation. |
| Temkin, Weinstein, Fan, Podolsky, Altman | 26 Dec 2025; [2512.22119](https://arxiv.org/abs/2512.22119) | U(1)-enriched quantum memories with locally resolved charge; disordered integer loops, optimal-decoder BKT, altered winding jump; loop-glass behavior is numerical evidence. |
| Ziereis, Moudgalya, Knap | 11 Sep 2025; [2509.09669](https://arxiv.org/abs/2509.09669) | Symmetry-sector steady ensembles, weak postselection phases and transitions; distinguish nonlinear conditioned operations from CPTP dynamics. |
| Zhang | 27 May 2026; [2605.29113](https://arxiv.org/abs/2605.29113) | Reaction-diffusion/absorbing states; 1+1D parity-conserving branching-annihilation scaling; 2+1D pair-Toom evidence. Marginal/global fidelity comparison requires stated local indistinguishability assumptions. |
| Fechisin et al. | 30 Sep 2026; [2610.00480](https://arxiv.org/abs/2610.00480) | Long-range pair dephasing of MPS yields 1D R2 phase diagram; mixed-SPT logical memory; explicitly R2 diagnostics, not unconditional intrinsic-fidelity equivalence. |
| Sarma | 29 Sep 2026; [2609.37965](https://arxiv.org/abs/2609.37965) | Exact compact-XY/FCS representation of every Rényi correlator for infinite dephasing; R2 uses parent-state FCS, R1 uses square-root-probability escort. Metallic and insulating IR kernels differ; insulators can be ordered depending on UV details. Finite-dephasing replica conclusions restricted to even indices. |
| Chen, Grover | 4 Feb 2026; v2 2 Aug; [2602.04961v2](https://arxiv.org/abs/2602.04961v2) | CMI-based nonperturbative RG/stability constraints. UV-finiteness and crossover assumptions stated; not an unconditional monotonicity theorem for arbitrary CMI. |
| Sala et al. | 5 Oct 2026; [2610.06692](https://arxiv.org/abs/2610.06692) | Non-Abelian fusion/decoder hierarchy; center ordering. Covered by topology chapter, included in cutoff audit. |
| Kim, Altman, Lee | 31 Oct 2024; PRB **114**, L051101 (2026); [2410.24225](https://arxiv.org/abs/2410.24225) | SYK/low-rank approximate codes; parity-conserving versus parity-exchanging noise; large-N/Rényi saddle threshold and SW parity order. Low-temperature/large-N limits and tolerated logical loss matter; no efficient decoder supplied. |

## Detection and experiments

| Primary work | Metadata and URL | Access and status |
|---|---|---|
| Weinstein | 30 Oct 2024; PRL **134**, 150405 (2025); [2410.23512](https://arxiv.org/abs/2410.23512) | R1 is ordinary correlator if canonical purification can be prepared. Access to arbitrary purification is insufficient. |
| Sun, Zhang, Feng | 24 Dec 2024; PRL **135**, 090403 (2025); [2412.18397](https://arxiv.org/abs/2412.18397) | Randomized-measurement R2 protocol; sample cost and purity normalization matter. |
| Feng, Cheng, Ippoliti | 16 Apr 2025; PRL **135**, 200402 (2025); [2504.12233](https://arxiv.org/abs/2504.12233) | Pseudorandom-state construction rules out efficient state-agnostic detection under computational assumptions. Structured experimental estimators do not contradict it. |
| Liu, Zou | 19 Jan 2026; [2601.13333](https://arxiv.org/abs/2601.13333) | Certified MPDO fidelity bounds using variational sequential circuits. Polynomial algorithm assumes tractable MPDO representation and optimization. |
| Wang et al. | 17 Apr 2026; [2604.16137](https://arxiv.org/abs/2604.16137) | Cold Fermi gas snapshots; learned Gaussian probability reference; R1/R2 QC estimates and metal/insulator comparison. Preprint reports observation; finite T and finite subsystem limitations important. |
| Divi, Lessa, Wang | 27 May 2026; [2605.28967](https://arxiv.org/abs/2605.28967) | Local SW-SSB definition and logarithmic accessible volume for polynomial resources. Local is necessary not universally sufficient for global two-point order. |
| Liu, Yi, Else | 27 May 2026; **v3 12 Aug**; [2605.28925v3](https://arxiv.org/abs/2605.28925v3) | Rigorous infinite-volume strong/local symmetry formulation, intermediate von Neumann symmetries. |
| Cao, Bi, Murch | 25 Aug 2026; [2608.24993](https://arxiv.org/abs/2608.24993) | Five superconducting qubits; cluster-state conditioning versus discarded records; finite-size fidelity signatures. |
| Wei et al. | 19 Oct 2026; [2610.26229](https://arxiv.org/abs/2610.26229) | Superconducting processor, known-channel kernels, two measurement settings, finite-size crossings/collapse, string observables. Claims are finite-size critical signatures. |

## Unresolved questions and exclusions

No universal equivalence of diffusion and SW-SSB is established by the listed work. Ordinary static fluctuations are distinct from response outside fluctuation-dissipation settings. Finite-time U(1) behavior, infinite-time stationary order, and finite-depth local-channel restrictions are different limits. Long-range channels deliberately evade local preparation obstructions. Generic fast-mixing steady-state SW-SSB remains more subtle than a gap statement. A public June 2026 talk advertised an ongoing hydrodynamic Nambu–Goldstone theorem; an unpublished talk is not treated as an established theorem or bibliographic paper here. Post-cutoff talks and papers are excluded even if searches find them.
