# Rudy RSR7 retention disk outlet — print log

## v1 — 2026-08-10 — PLA (tag `v1`, commit 1f6f126)

3mm plate, guide tab 7.25mm from hole center (~1.9mm gap to base edge at its top end).
100% rectilinear print.

**Result:** Printed 3mm in PLA and doesn't flex. Front hole guide too far from edge.

## v2 — 2026-08-13 — PETG

- Thickness 3mm → 2.5mm; PETG for flex.
- Guide tab re-anchored to the base's right edge: outside edge 1mm from the
  base edge (tab tilted ~3.3° to run parallel to it, so the gap is uniform),
  inside edge 7.5mm from the hole center.
- Hole (and counterbore) moved with the tab: center x 46.93 → ~47.9mm,
  i.e. ~1mm closer to the edge. Hole y unchanged.
- PETG
- 75% grid print

**Result:** It fits, but it's a bit too rigid and pops out at the peg. Next
version should be similar shape but more flexible.

## v3 — 2026-08-13 — PETG (planned)

- Thickness 2.5mm → 2mm for more flex.
- Peg head widened 4mm → 5mm OD to hold better (taper to 2mm tip unchanged).
- Print at 30% infill, grid pattern.