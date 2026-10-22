"""Preserve the combined edition when a later HTML-only render clears _site."""
from pathlib import Path
import shutil

root = Path(__file__).resolve().parent.parent
rendered = root/'_site/sw-ssb-textbook.pdf'
snapshot = root/'downloads/sw-ssb-textbook.pdf'
if rendered.exists():
    snapshot.parent.mkdir(exist_ok=True)
    shutil.copy2(rendered, snapshot)
elif snapshot.exists():
    rendered.parent.mkdir(exist_ok=True)
    shutil.copy2(snapshot, rendered)
