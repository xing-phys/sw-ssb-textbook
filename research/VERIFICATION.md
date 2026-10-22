# Verification record

Checked on 22 October 2026.

## Artifacts and scope

- Quarto book: 19 numbered chapters, welcome, two appendices and references (23 HTML pages).
- 84 unique primary/review bibliography entries; every entry cited in the book.
- Approximately 50,200 source words including mathematics and tables; 76 worked-solution blocks.
- Combined PDF: 153 pages, 1,879,395 bytes; preserved at `downloads/sw-ssb-textbook.pdf`.
- Literature search cutoff: 22 October 2026. Topic maps record source/assumption/version checks.

## Completed checks

- `quarto render`: HTML and XeLaTeX PDF build successfully with no unresolved-reference diagnostics.
- `scripts/check_sources.py`: configured chapters, unique explicit labels, citations, figure paths and Mermaid option syntax pass.
- `scripts/check_site.py`: 23 pages and 2,014 relative URLs/fragments pass; search index and PDF download exist.
- Search index, responsive viewport, MathJax loader, both interactive panels and their JavaScript resource present.
- `node --check assets/lab.js` passes.
- `numerics/generate.jl` passes normalization, charge support, exact chain correlators, affinity bounds and diffusion conservation.
- `numerics/core_checks.jl` independently checks full density matrices, exact statistical mappings, counterexamples, noncommuting overlaps and squared-fidelity response; chain discrepancy below 2.2e-14.
- `numerics/check_topology.jl` passes cluster stabilizers, strings, entropy/rank, strong/weak symmetry, parity reduction, coherent information and four-spin singlet negativity.
- PDF text bounding boxes: no words outside page bounds on any page; no unresolved `??` markers.
- Visually inspected representative cover, contents, foundation, nonlinear diagnostics, response derivation, purification diagram, decoding diagram, topology, hydrodynamics, numerical lab, source atlas, glossary and reference pages.
- Original numerical and conceptual figures visually inspected; Mermaid metadata and captions checked in generated HTML.

## Verification limit

No browser surface is enabled in the available computer-use connection (inventory empty and in-app browser unavailable). Browser interaction, light/dark screenshots and mobile screenshots could not be exercised. Static HTML/CSS/resource/link checks and rendered PDF inspection were completed. Publication status and HTTP checks are recorded in the final Git commit/report.

## Build environment

Quarto 1.10.18; Julia 1.12.6 with standard libraries; XeTeX/TeX Live 2023; Python for SVG/PDF conversion and validation. Numerical examples require no external Julia packages.
