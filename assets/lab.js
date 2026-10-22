document.addEventListener('DOMContentLoaded', () => {
  const parity = document.getElementById('parity-lab');
  if (parity) {
    const n = parity.querySelector('[name="size"]');
    const p = parity.querySelector('[name="noise"]');
    const render = () => {
      const N = Number(n.value), q = Number(p.value);
      const lam = Math.pow(1 - 2 * q, N);
      const x = (1 + lam) / 2;
      const h = x === 0 || x === 1 ? 0 : -x * Math.log(x) - (1 - x) * Math.log(1 - x);
      parity.querySelector('[data-size]').textContent = N;
      parity.querySelector('[data-noise]').textContent = q.toFixed(4);
      parity.querySelector('[data-lambda]').textContent = lam.toFixed(5);
      parity.querySelector('[data-f]').textContent = Math.sqrt(Math.max(0, 1 - lam * lam)).toFixed(5);
      parity.querySelector('[data-cmi]').textContent = (1 - h / Math.log(2)).toFixed(5);
      parity.querySelector('[data-status]').textContent = q === 0
        ? 'Exactly strong: one-point F = 0, pair F = 1.'
        : 'Only weak symmetry remains at this nonzero p; the channel breaks strong symmetry explicitly.';
    };
    n.addEventListener('input', render); p.addEventListener('input', render); render();
  }
  const chain = document.getElementById('chain-lab');
  if (chain) {
    const p = chain.querySelector('[name="pairnoise"]');
    const r = chain.querySelector('[name="distance"]');
    const render = () => {
      const q=Number(p.value), d=Number(r.value), f=2*Math.sqrt(q*(1-q));
      const b=2*q*(1-q)/(q*q+(1-q)*(1-q));
      chain.querySelector('[data-p]').textContent=q.toFixed(2);
      chain.querySelector('[data-r]').textContent=d;
      chain.querySelector('[data-f]').textContent=Math.pow(f,d).toExponential(4);
      chain.querySelector('[data-r2]').textContent=Math.pow(b,d).toExponential(4);
      chain.querySelector('[data-xi]').textContent=q===0?'0':q===0.5?'∞':(-1/Math.log(f)).toFixed(3);
    };
    p.addEventListener('input',render); r.addEventListener('input',render); render();
  }
});
