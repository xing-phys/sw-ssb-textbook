"""Check local URLs and fragments relative to every containing HTML page."""
from html.parser import HTMLParser
from pathlib import Path
from urllib.parse import urlsplit, unquote
import sys

root = Path(sys.argv[1] if len(sys.argv)>1 else '_site').resolve()
class Page(HTMLParser):
    def __init__(self):
        super().__init__(); self.ids=set(); self.links=[]
    def handle_starttag(self, tag, attrs):
        a=dict(attrs)
        if 'id' in a: self.ids.add(a['id'])
        for attr in ('href','src'):
            if attr in a: self.links.append(a[attr])
pages={}
for file in root.rglob('*.html'):
    p=Page(); p.feed(file.read_text()); pages[file]=p
errors=[]; checked=0
for file,p in pages.items():
    for link in p.links:
        u=urlsplit(link)
        if u.scheme or u.netloc or link.startswith(('javascript:','data:')): continue
        if u.path.startswith('/'):
            # Book deployments have a repository subpath, not a filesystem root.
            relative=u.path.removeprefix('/sw-ssb-textbook/').lstrip('/')
            target=root/relative
        else:
            target=(file.parent/unquote(u.path)).resolve() if u.path else file
        if target.is_dir(): target=target/'index.html'
        if not target.exists():
            errors.append(f'{file.name}: missing {link}'); continue
        if u.fragment and target in pages and unquote(u.fragment) not in pages[target].ids:
            errors.append(f'{file.name}: missing anchor {link}')
        checked+=1
if errors: raise SystemExit('\n'.join(sorted(set(errors))))
assert (root/'search.json').exists(), 'Missing search index'
assert (root/'sw-ssb-textbook.pdf').exists(), 'Missing PDF download'
print(f'PASS: {len(pages)} HTML pages, {checked} local URLs/fragments, search index and PDF download.')
