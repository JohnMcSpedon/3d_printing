// Rudy Project RSR7 retention disk outlet — replacement part
// Traced from broken original (20260807_helmet_trace.pdf), vectorized in Figma.
// Geometry data is generated from the SVG by svg_to_scad.py (part is 120mm x ~51.6mm);
// re-run that script if the trace or overall size changes.

include <part_geometry.scad>

thickness = 2.5;      // plate height, mm
right_hole_d = 4.45;  // through-hole OD, mm
counterbore_d = 10;   // cutout under the right hole, mm
counterbore_h = 1.5;  // from z=0 up to this height, mm

tab_w = 3;            // rounded-rect boss near right edge: width, mm
tab_l = 15;           // length, mm
tab_h = 2;            // height above top surface, mm
tab_r = 1;            // corner radius, mm
tab_edge_gap = 1;     // tab outside edge to base right edge, mm
tab_hole_gap = 7.5;   // tab inside edge to right hole center, mm

// The base's rightmost side is the straight outline segment from
// outline_pts[3] (bottom) to outline_pts[2] (top), tilted ~3.3 deg off
// vertical. The tab runs parallel to it; the hole is placed off the tab's
// inside face, keeping its original y from the trace.
edge_bot = outline_pts[3];
edge_top = outline_pts[2];
edge_dir = (edge_top - edge_bot) / norm(edge_top - edge_bot);
edge_n_out = [edge_dir[1], -edge_dir[0]];      // outward normal (+x side)
edge_tilt = atan2(-edge_dir[0], edge_dir[1]);  // tab rotation from +Y, deg

hole_edge_dist = tab_edge_gap + tab_w + tab_hole_gap; // hole center to base edge
hole_y = right_hole_pos[1];
hole_x = edge_bot[0] + (-hole_edge_dist - edge_n_out[1] * (hole_y - edge_bot[1])) / edge_n_out[0];
hole_pos = [hole_x, hole_y];
tab_center = hole_pos + (tab_hole_gap + tab_w / 2) * edge_n_out;

echo(hole_pos = hole_pos, tab_center = tab_center, edge_tilt = edge_tilt);

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
    translate([hole_pos[0], hole_pos[1], -eps])
        cylinder(d = right_hole_d, h = thickness + 2 * eps);
    translate([hole_pos[0], hole_pos[1], -eps])
        cylinder(d = counterbore_d, h = counterbore_h + eps);
}

// Peg standing on the top surface, centered on the left circle of the trace
translate([left_hole_pos[0], left_hole_pos[1], thickness])
    peg();

// Rounded-rect boss on the top surface, parallel to the base's right edge
translate([tab_center[0], tab_center[1], thickness - eps])
    rotate([0, 0, edge_tilt])
        linear_extrude(height = tab_h + eps)
            offset(r = tab_r)
                square([tab_w - 2 * tab_r, tab_l - 2 * tab_r], center = true);
