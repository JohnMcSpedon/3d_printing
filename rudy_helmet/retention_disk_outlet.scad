// Rudy Project RSR7 retention disk outlet — replacement part
// Traced from broken original (20260807_helmet_trace.pdf), vectorized in Figma.
// Geometry data is generated from the SVG by svg_to_scad.py (part is 120mm x ~51.6mm);
// re-run that script if the trace or overall size changes.

include <part_geometry.scad>

thickness = 3;        // plate height, mm
right_hole_d = 4.45;  // through-hole OD, mm
counterbore_d = 10;   // cutout under the right hole, mm
counterbore_h = 1.5;  // from z=0 up to this height, mm

tab_w = 3;            // rounded-rect boss near right edge: X size, mm
tab_l = 15;           // Y size, mm
tab_h = 2;            // height above top surface, mm
tab_r = 1;            // corner radius, mm
tab_offset = 7.25;    // right hole center to boss left edge, mm

$fn = 64;
eps = 0.01;

// Peg: cylindrical base with a wider head that tapers at the top.
// Heights are above the surface the peg stands on.
module peg(base_d = 3, base_h = 2.5, head_d = 4, head_h = 3, tip_d = 2, taper_frac = 0.5) {
    cylinder(d = base_d, h = base_h + eps);
    translate([0, 0, base_h]) {
        straight_h = head_h * (1 - taper_frac);
        cylinder(d = head_d, h = straight_h + eps);
        translate([0, 0, straight_h])
            cylinder(d1 = head_d, d2 = tip_d, h = head_h - straight_h);
    }
}

// Solid plate from the outer trace, minus the inner slot and the right hole
difference() {
    linear_extrude(height = thickness)
        polygon(outline_pts);
    translate([0, 0, -eps])
        linear_extrude(height = thickness + 2 * eps)
            polygon(slot_pts);
    translate([right_hole_pos[0], right_hole_pos[1], -eps])
        cylinder(d = right_hole_d, h = thickness + 2 * eps);
    translate([right_hole_pos[0], right_hole_pos[1], -eps])
        cylinder(d = counterbore_d, h = counterbore_h + eps);
}

// Peg standing on the top surface, centered on the left circle of the trace
translate([left_hole_pos[0], left_hole_pos[1], thickness])
    peg();

// Rounded-rect boss on the top surface, parallel to the right edge,
// vertically centered on the right hole
translate([right_hole_pos[0] + tab_offset + tab_w / 2, right_hole_pos[1], thickness - eps])
    linear_extrude(height = tab_h + eps)
        offset(r = tab_r)
            square([tab_w - 2 * tab_r, tab_l - 2 * tab_r], center = true);
