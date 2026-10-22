"""Convert original SVG figures for portable HTML and vector-quality PDF output."""
from pathlib import Path
import cairosvg

root = Path(__file__).resolve().parent.parent
figures = list((root / 'figs').glob('*.svg'))
figures += [root/'assets'/name for name in ['cluster-dephasing.svg', 'fusion-records.svg']]
for svg in sorted(figures):
    cairosvg.svg2png(url=str(svg), write_to=str(svg.with_suffix('.png')), scale=2)
    cairosvg.svg2pdf(url=str(svg), write_to=str(svg.with_suffix('.pdf')))
    print(svg.name)
