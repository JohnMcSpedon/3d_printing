// ============================================================
//  Craftsman metric combination wrench display rack — 7..18 mm
//
//  An extruded trapezoid ring: open top, open bottom, open
//  interior, straight sides, symmetric about the centreline.  A
//  leaning kerf is cut down from the top edge of each slanted
//  wall.  Each wrench drops in edge-first and stands at `tilt`
//  off vertical, fanned like a card file.
//
//  Top view:                      Side view (looking along -x):
//       back (18 mm)
//   +-----------------+           \ \ \ \ \ \ \ \ \ \ \ \
//  /  u             u  \         __\_\_\_\_\_\_\_\_\_\_\_\__
// /   u             u   \       |                          | 25
// +---------------------+       +--------------------------+
//      front (7 mm)              front                 back
//
//  Every rack dimension comes from three measured numbers per
//  wrench — handle length, width and depth.  Nothing depends on
//  overall length or head size, which are only estimated for the
//  preview.
//
//  Handle length sets the span.  The walls must land on the
//  constant-width part of the handle, clear of the flare into
//  each head, so span(i) <= handle_len(i) - wall - 2*flare_clear.
//  One straight line has to satisfy all twelve of those at once;
//  see span_front / span_back below.
//
//  Handle depth sets the kerf width — this is what actually grips
//  the wrench.  Handle width sets how deep the kerf is cut, so
//  each wrench sinks proportionally and stands the same amount
//  proud.
//
//  Print flat on the bed as drawn — one piece, no supports.
// ============================================================

// Measured 2026-09-16.  Handle length is the constant-width
// section only (flare into either head excluded); width and depth
// are at the widest point near the middle.
// [ nominal size, handle_len, handle_width, handle_depth ]
wrenches = [
    [  7,  75,  8.4, 4.3 ],
    [  8,  75,  9.2, 4.5 ],
    [  9,  85,  9.9, 4.0 ],
    [ 10,  95, 11.0, 5.1 ],
    [ 11, 100, 11.0, 5.4 ],
    [ 12, 105, 11.3, 5.7 ],
    [ 13, 110, 12.5, 6.3 ],
    [ 14, 120, 13.3, 6.4 ],
    [ 15, 125, 14.8, 7.2 ],
    [ 16, 135, 15.1, 7.6 ],
    [ 17, 140, 16.1, 8.2 ],
    [ 18, 150, 15.5, 8.6 ],
];

// ---- Trapezoid ----------------------------------------------
// Wall-centreline spacing at the first and last kerf; the sides
// are one straight line between them.  These are the widest such
// line that keeps flare_clear on all twelve wrenches — the 8 mm
// and 13 mm wrenches are what pin it (both land exactly on 4 mm;
// everything else has 1..7 mm to spare).  Retune by hand if the
// table changes; the per-wrench clearance is echoed below.
span_front = 56;
span_back  = 133;
flare_clear = 4.0;     // wanted between the outer wall face and
                       // the start of the flare into the head, mm

// ---- Wrench seating ------------------------------------------
tilt        = 30;      // lean off vertical, deg.  See the note at
                       // the foot of this file before raising it.
engage_frac = 0.80;    // how much of the handle width sits down in
                       // the kerf; the rest stands proud
slot_clear  = 1.0;     // added to handle depth for the kerf width.
                       // Deliberately loose — a leaning kerf's
                       // upper face is an overhang and tends to
                       // print a touch narrow than drawn.
mouth_lead  = 12;      // lead-in taper at the kerf mouth, deg.
                       // tilt + mouth_lead must stay <= 45 or the
                       // flared face needs support.

// ---- Rack ----------------------------------------------------
wall       = 4.0;      // wall thickness, mm
height     = 25.0;     // wall height, mm
pitch      = 18.0;     // kerf centre-to-centre, mm
end_margin = 18.0;     // wall beyond the first / last kerf, mm

bed = 256;             // P1S build plate, mm — checked in the report

// ---- Preview -------------------------------------------------
show_wrenches = true;  // ghost the wrenches (F5).  Drawn with %,
                       // so they never reach the STL.
// ESTIMATES, preview only — no rack dimension depends on these.
head_od_k  = 1.55;     // head OD        / nominal size
head_len_k = 1.40;     // handle end -> head centre / nominal size
head_t_k   = 1.35;     // head thickness / handle depth
head_offset = 0;       // box end cranked out of the handle plane,
                       // mm.  0 = flat.  If this set's box ends are
                       // offset, measure it and set it — it drives
                       // the loaded height and the table check.

// ---- Derived geometry ---------------------------------------
$fn = 48;
eps = 0.01;

n     = len(wrenches);
depth = 2 * end_margin + (n - 1) * pitch;   // centreline, front to back

function size_of(i)    = wrenches[i][0];
function handle_l(i)   = wrenches[i][1];
function handle_w(i)   = wrenches[i][2];
function handle_t(i)   = wrenches[i][3];
function slot_w(i)     = handle_t(i) + slot_clear;    // kerf width
function slot_d(i)     = handle_w(i) * engage_frac;   // kerf depth, along its axis
function notch_y(i)    = end_margin + i * pitch;      // kerf centre at the top face
function span(i)       = span_front + (span_back - span_front) * i / (n - 1);
function flare_gap(i)  = (handle_l(i) - span(i) - wall) / 2;

// Wall centreline half-width, straight from the first kerf to the last.
half_slope = ((span_back - span_front) / 2) / ((n - 1) * pitch);
function half_w(y) = span_front / 2 + (y - notch_y(0)) * half_slope;

// Same, out at the outside face: the walls are offset perpendicular
// to their own run, so the outer face sits wall/2/cos further out in
// x, not wall/2.
slant = atan(half_slope);        // wall angle off the y axis, deg
function outer_half_w(y) = half_w(y) + (wall / 2) / cos(slant);

// Centreline trapezoid, CCW.
centreline = [
    [ -half_w(0),     0     ],
    [  half_w(0),     0     ],
    [  half_w(depth), depth ],
    [ -half_w(depth), depth ],
];

// ---- Modules -------------------------------------------------

// The trapezoid ring.
module shell() {
    linear_extrude(height = height)
        difference() {
            offset(delta =  wall / 2) polygon(centreline);
            offset(delta = -wall / 2) polygon(centreline);
        }
}

// One kerf, cut clean through both slanted walls in a single pass.
// Rotated about x only, so it stays aligned to the wrench axis and
// the wrench beds flat on the kerf floor.  That floor is the raised
// bottom that sets the lean — it stops well above the base.
//
// Profile is drawn in the kerf's own frame: u runs along the kerf
// axis (-d = floor, +over = out through the top face), v across its
// width.  The mouth opens out at mouth_lead from u0, which sits
// below the lowest point where the kerf breaks the top face, so the
// whole mouth gets the lead-in rather than just one side.
module kerf(i) {
    sw   = slot_w(i);
    d    = slot_d(i);
    over = 2 * sw + 6;
    u0   = -(sw / 2) * tan(tilt) - 1;
    f    = (over - u0) * tan(mouth_lead);
    translate([ 0, notch_y(i), height ])
        rotate([ tilt, 0, 0 ])
            rotate([ 0, -90, 0 ])
                linear_extrude(height = 3 * span_back, center = true)
                    polygon([ [ -d,   -sw/2     ], [ -d,    sw/2     ],
                              [  u0,   sw/2     ], [  over, sw/2 + f ],
                              [  over, -sw/2 - f], [  u0,  -sw/2     ] ]);
}

// Stand-in wrench: straight handle to measurement, box ring at +x,
// open end at -x, both sized from the estimates above.  Rough shape
// only — enough to eyeball lean, shingling and drawer height.  Built
// flat in the xy plane, thickness in +z; the caller stands it up.
module wrench_mock(i) {
    sz = size_of(i);
    Lh = handle_l(i);
    bw = handle_w(i);
    t  = handle_t(i);
    od = sz * head_od_k;
    hl = sz * head_len_k;
    ht = t  * head_t_k;
    hz = head_offset + (t - ht) / 2;      // head underside, mock z

    difference() {
        union() {
            translate([ -Lh/2, -bw/2, 0 ]) cube([ Lh, bw, t ]);
            for (s = [-1, 1]) hull() {
                translate([ s * Lh/2,        0, 0  ]) cylinder(d = bw, h = t);
                translate([ s * (Lh/2 + hl), 0, hz ]) cylinder(d = od, h = ht);
            }
        }
        // box end at +x
        translate([  Lh/2 + hl, 0, -od ]) cylinder(d = sz, h = 3 * od);
        // open end at -x
        translate([ -(Lh/2 + hl), 0, -od ]) {
            cylinder(d = sz, h = 3 * od);
            translate([ -od, -sz/2, 0 ]) cube([ od, sz, 3 * od ]);
        }
    }
}

// Wrench i seated in its kerf: lower edge on the kerf floor, handle
// centred across the kerf width.
module seated_wrench(i) {
    translate([ 0, notch_y(i), height ])
        rotate([ tilt, 0, 0 ])
            translate([ 0, -handle_t(i)/2, -slot_d(i) + handle_w(i)/2 ])
                rotate([ -90, 0, 0 ])
                    wrench_mock(i);
}

// ---- Assemble -------------------------------------------------
color("SteelBlue", 0.9)
difference() {
    shell();
    for (i = [0 : n-1]) kerf(i);
}

if (show_wrenches)
    for (i = [0 : n-1]) %seated_wrench(i);

// ---- Dimension report ----------------------------------------
// Where each mock head ends up in world coords, for the drawer and
// table-strike checks.  Head centre sits on the handle axis, so its
// local y is just head_offset and its local z is the handle centre.
function head_od(i)   = size_of(i) * head_od_k;
function head_t(i)    = handle_t(i) * head_t_k;
function beam_zc(i)   = -slot_d(i) + handle_w(i)/2;
function head_zmax(i) = height + (head_offset + head_t(i)/2) * sin(tilt)
                               + (beam_zc(i) + head_od(i)/2) * cos(tilt);
function head_zmin(i) = height + (head_offset - head_t(i)/2) * sin(tilt)
                               + (beam_zc(i) - head_od(i)/2) * cos(tilt);
function head_ymax(i) = notch_y(i) + (head_offset + head_t(i)/2) * cos(tilt)
                                   - (beam_zc(i) - head_od(i)/2) * sin(tilt);
function overall_l(i) = handle_l(i) + 2 * size_of(i) * head_len_k
                                    + size_of(i) * head_od_k;
// Wall left between neighbouring kerf mouths, measured along the wall.
function web(i) = pitch / cos(slant)
                  - (slot_w(i) + slot_w(i+1)) / 2 / (cos(tilt) * cos(slant));
// How far the last kerf reaches back, vs the inner face of the back wall.
function back_gap() = (depth - wall/2)
                      - (notch_y(n-1) + slot_w(n-1)/2 * cos(tilt)
                                      + slot_d(n-1) * sin(tilt));

rack_w  = 2 * outer_half_w(depth + wall/2);
rack_d  = depth + wall;
tall    = max([ for (i = [0:n-1]) head_zmax(i) ]);
lowest  = min([ for (i = [0:n-1]) head_zmin(i) ]);
loaded  = max([ for (i = [0:n-1]) overall_l(i) ]);
occup_d = max(rack_d, max([ for (i = [0:n-1]) head_ymax(i) ]));

echo("=== Wrench rack ===");
echo(str("Printed part   : ", rack_w, " x ", rack_d, " x ", height, " mm"));
echo(str("Front / back   : ", 2 * outer_half_w(-wall/2), " / ", rack_w, " mm outside"));
echo(str("Wall slant     : ", slant, " deg off the y axis"));
echo(str("Lean / pitch   : ", tilt, " deg / ", pitch, " mm"));
echo(str("Loaded envelope: ", loaded, " x ", occup_d, " x ", tall,
         " mm  (drawer space, wrenches included)"));
echo(str("Lowest head    : ", lowest, " mm above the table"));

if (rack_w > bed || rack_d > bed)
    echo(str("WARNING: ", rack_w, " x ", rack_d,
             " does not fit a ", bed, " mm plate in one piece."));
else
    echo(str("P1S fit        : OK, ", bed - max(rack_w, rack_d),
             " mm to spare on the long axis"));
if (lowest < 0)
    echo("WARNING: heads strike the table — raise `height` or drop head_offset.");
if (tilt + mouth_lead > 45)
    echo(str("WARNING: tilt + mouth_lead = ", tilt + mouth_lead,
             " deg — the flared kerf face now needs support."));
if (back_gap() < 2)
    echo(str("WARNING: last kerf reaches within ", back_gap(),
             " mm of the back wall — raise end_margin."));

for (i = [0 : n-1]) {
    echo(str("  ", size_of(i), " mm",
             "  y=",     notch_y(i),
             "  kerf=",  slot_w(i), " x ", slot_d(i), " mm",
             "  proud=", handle_w(i) - slot_d(i), " mm",
             "  span=",  span(i), " mm",
             "  flare clear=", flare_gap(i), " mm"));
    if (flare_gap(i) < flare_clear)
        echo(str("  WARNING: ", size_of(i), " mm wall lands only ", flare_gap(i),
                 " mm from the flare — shorten the span or respace."));
}
echo(str("Wall web between kerfs (min) : ",
         min([ for (i = [0:n-2]) web(i) ]), " mm"));
echo(str("Back wall gap                : ", back_gap(), " mm"));
echo(str("Face-to-face gap, shingled   : ", pitch * cos(tilt),
         " mm  (must clear the thickest box ring — est. ",
         max([ for (i = [0:n-1]) head_t(i) ]), " mm)"));

// ---- Why the lean is 30 and not 45 ---------------------------
// Leaning further costs on both counts that set the pitch:
//   kerf mouth  = slot_w / cos(tilt)   — wider as tilt rises
//   shingle gap = pitch  * cos(tilt)   — tighter as tilt rises
// At 45 deg the twelve kerfs need pitch 22 to keep the box rings
// apart, which makes the part 278 mm deep and it no longer fits the
// plate in one piece.  Cutting back to pitch 18 to fit leaves only
// ~1 mm between the 17 and 18 mm rings.  At 30 deg the same pitch 18
// gives ~4 mm of ring clearance and a 7 mm web, and the part fits
// with room to spare.  35-40 deg also works if you want more of a
// fan; re-run and read the "Face-to-face gap" line before printing.
