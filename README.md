# Strong-to-Weak Spontaneous Symmetry Breaking

**From Fundamentals to Research Frontiers** — a Quarto web textbook for senior undergraduates and beginning graduate students. Literature cutoff: **22 October 2026**.

- Website: https://xing-phys.github.io/sw-ssb-textbook/
- Source: https://github.com/xing-phys/sw-ssb-textbook
- Start with `index.qmd`; chapter order is in `_quarto.yml`.
- Concept-indexed research audit: `19-literature-map.qmd` and `research/*-map.md`.

## Build

Requires Quarto (tested with 1.10.18). Build both editions with XeLaTeX, Libertinus Serif and DejaVu fonts installed:

```sh
quarto render
quarto preview --no-browser
```

For an HTML-only rebuild, including the versioned PDF download:

```sh
quarto render --to html
```

The web book and combined PDF are written to `_site/`. The post-render script preserves the latest combined PDF in `downloads/` and restores it after HTML-only rebuilds. The Pages workflow uses this verified PDF without requiring a TeX installation.

## Reproduce the calculations

```sh
julia --project=numerics numerics/generate.jl
julia numerics/frontier_diagram.jl
python3 scripts/convert_figures.py
```

Julia uses standard libraries only (tested with 1.12.6, compatible with 1.10+). Figure conversion needs `cairosvg` (`python3 -m pip install cairosvg`); this only converts original SVGs to PNG/PDF. Generated CSVs and SVGs are versioned. No stochastic simulation is needed; the single random matrix example fixes its seed.

## Verify

```sh
python3 scripts/check_sources.py
julia numerics/core_checks.jl
julia numerics/check_topology.jl
quarto render --to html
python3 scripts/check_site.py _site
```

Math macros are kept equivalent in `assets/macros.sty` and `assets/mathjax-config.html`. Citations are merged from checked topic bibliographies using `scripts/merge_bibliography.py`. Numerical assumptions, exact versus asymptotic statements, and the distinctions between global/local symmetry and different phase frameworks are discussed in the text.

This project uses the user's Quarto book conventions. Text and diagrams were developed with AI assistance and checked against the primary sources listed in the book; contributions and corrections can be submitted through repository issues or pull requests.
