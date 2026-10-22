"""Check chapter presence, unique labels, cited keys and local figure files."""
from pathlib import Path
import re

root = Path(__file__).resolve().parent.parent
chapters = sorted(root.glob('*.qmd'))
bib = (root/'assets/bibliography.bib').read_text()
keys = set(re.findall(r'@\w+\s*\{\s*([^,]+),', bib))
labels = {}
references = []
errors = []
for path in chapters:
    text = path.read_text()
    for diagram in re.findall(r'```\{mermaid\}(.*?)```', text, flags=re.S):
        if re.search(r'(?m)^#\|', diagram):
            errors.append(f'Invalid Mermaid options in {path.name}: use %%| comments')
    text = re.sub(r'```.*?```', '', text, flags=re.S)
    for label in re.findall(r'\{#([\w:-]+)', text):
        if label in labels:
            errors.append(f'Duplicate label {label}: {path.name} and {labels[label]}')
        labels[label] = path.name
    for ref in re.findall(r'(?<![\w/])@([\w-]+)', text):
        references.append((path.name, ref))
    for asset in re.findall(r'!\[[^\]]*\]\(([^)]+)\)', text):
        if '://' not in asset and not (root/asset.split()[0]).exists():
            errors.append(f'Missing figure {asset}: {path.name}')
for path, ref in references:
    if ref not in labels and ref not in keys:
        errors.append(f'Unresolved source reference @{ref}: {path}')
config = (root/'_quarto.yml').read_text()
for filename in re.findall(r'\b([\w-]+\.qmd)', config):
    if not (root/filename).exists():
        errors.append(f'Missing configured chapter {filename}')
if errors:
    raise SystemExit('\n'.join(errors))
print(f'PASS: {len(chapters)} chapters, {len(labels)} unique labels, {len(keys)} bibliography entries, {len(references)} resolved source references.')
