"""Merge topic bibliographies without changing verified citation keys."""
from pathlib import Path
import re

root = Path(__file__).resolve().parent.parent
entries = {}
aliases = {
    'cao2026array': 'cao2026mixed',
    'garratt2021delocalisation': 'garratt2021',
    'liu2026localsymmetries': 'liu2026local',
    'sang2025local': 'sang2025reversibility',
    'weinstein2025renyi': 'weinstein2025',
    'zhang2026localdiagnostics': 'zhang2026local',
}
for path in sorted((root/'research').glob('*.bib')):
    for entry in re.split(r'(?m)(?=^@\w+\s*\{)', path.read_text()):
        match = re.match(r'@\w+\s*\{\s*([^,]+),', entry)
        if not match:
            continue
        key = match[1].strip()
        if key in aliases:
            continue
        if key in entries and re.sub(r'\s+', '', entries[key]) != re.sub(r'\s+', '', entry):
            identity = lambda s: re.findall(r'(?:doi|eprint)\s*=\s*\{([^}]+)\}', s, flags=re.I)
            if not set(identity(entries[key])) & set(identity(entry)):
                raise SystemExit(f'Conflicting bibliography key: {key} in {path}')
            entry = max([entries[key], entry], key=len)
        entries[key] = entry.strip()
(root/'assets/bibliography.bib').write_text('\n\n'.join(entries[k] for k in sorted(entries))+'\n')
for path in root.glob('*.qmd'):
    source = path.read_text()
    for old, new in aliases.items():
        source = re.sub(r'@'+re.escape(old)+r'(?![\w-])', '@'+new, source)
    path.write_text(source)
print(f'Merged {len(entries)} entries from topic bibliographies.')
