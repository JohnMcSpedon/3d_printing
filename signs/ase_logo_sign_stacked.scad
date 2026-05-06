// Analytic Services Express logo sign — stacked variant
// Larger logo on the left, company name as 3 lines (one word per line)
// on the right. Two-color print: 1 mm black base + raised white logo & text.
//
// Requires Raleway font installed (`brew install --cask font-raleway`).
//
// Two-color export workflow (no MMU/AMS scripting in OpenSCAD):
//   1. Set PART = "base", F6 render, export ase_logo_sign_stacked_base.stl
//   2. Set PART = "top",  F6 render, export ase_logo_sign_stacked_top.stl
//   3. In Bambu Studio: load base.stl, right-click -> Add Part -> top.stl
//      (shared origin -> auto-aligned). Assign black to base, white to top.

$fn = 60;

// Base rectangle (the black layer)
BASE_WIDTH      = 180;  // mm, X
BASE_DEPTH      = 80;   // mm, Y
BASE_HEIGHT     = 1;    // mm, Z

// Top (white) layer — logo + text raised above the base
TOP_HEIGHT      = 1;    // mm, raised height of logo + text
LOGO_SIZE       = 40;   // mm, square (logo native aspect is 1:1)
TEXT_SIZE       = 15;   // mm, font cap height per line
LINE_SPACING    = 20;   // mm, baseline-to-baseline spacing between stacked lines

// One word per line, top-to-bottom
LINES           = ["Analytic", "Services", "Express"];
FONT_NAME       = "Raleway:style=SemiBold";

// Width of the WIDEST line, in mm. Used to center the logo+text group.
// For Raleway SemiBold at 12 mm:
//   "Analytic" = 63.3,  "Services" = 65.8,  "Express" = 59.7  -> widest 65.8.
// To remeasure: enable Preferences > Features > textmetrics and run:
//   echo(textmetrics(text=line, size=TEXT_SIZE, font=FONT_NAME).size);
TEXT_WIDTH      = 66;   // mm, X (widest line)

// Layout (left-to-right: [LOGO][LOGO_TEXT_GAP][TEXT], group centered on base)
LOGO_TEXT_GAP   = 6;    // mm, gap between logo right edge and text start

// Render mode: "all" (preview, both colored), "base", or "top"
PART            = "all";


// 2D logo in its native 33 x 33 coordinate system: a rounded square frame
// (white border) with a 4-pointed concave star window cut out of the
// interior. Matches ASE-logo.svg geometry exactly.
module ase_logo_2d() {
    difference() {
        // Outer: 33x33 rounded square, corner radius 5
        offset(r = 5) translate([5, 5]) square([23, 23]);

        // Inner star window
        intersection() {
            translate([4, 4]) square([25, 25]);
            difference() {
                translate([4, 4]) square([25, 25]);
                translate([4,  4])  circle(r = 12);
                translate([29, 4])  circle(r = 12);
                translate([29, 29]) circle(r = 12);
                translate([4,  29]) circle(r = 12);
            }
        }
    }
}

// 3D logo: scaled to LOGO_SIZE x LOGO_SIZE x TOP_HEIGHT, centered at origin
// in XY (sits on Z=0).
module ase_logo_3d() {
    s = LOGO_SIZE / 33;
    translate([-LOGO_SIZE/2, -LOGO_SIZE/2, 0])
        linear_extrude(height = TOP_HEIGHT)
            scale([s, s])
                ase_logo_2d();
}

// 3D stacked text: each line left-aligned at x=0, vertically centered as
// a group around y=0. Top-most line is the first entry of LINES.
//
// We position by BASELINE (not bbox center) so baseline-to-baseline
// spacing is exactly LINE_SPACING regardless of which lines have
// descenders ('y', 'p', etc). Lines with mixed ascender/descender content
// would otherwise produce uneven visual gaps under valign="center".
//
// CAP_MID_OFFSET shifts baselines down by ~half a cap height so the
// visual midline of the group lands near y=0. 0.35*TEXT_SIZE is a good
// approximation for Raleway (cap height ~ 0.7 * font size).
module stacked_text_3d() {
    n = len(LINES);
    cap_mid_offset = -TEXT_SIZE * 0.35;
    for (i = [0 : n - 1]) {
        baseline_y = ((n - 1) / 2 - i) * LINE_SPACING + cap_mid_offset;
        translate([0, baseline_y, 0])
            linear_extrude(height = TOP_HEIGHT)
                text(LINES[i],
                     size    = TEXT_SIZE,
                     font    = FONT_NAME,
                     halign  = "left",
                     valign  = "baseline");
    }
}

// The raised white layer: logo on the left, stacked text to its right,
// both vertically centered on the base AND centered as a group horizontally.
module top_layer() {
    content_w = LOGO_SIZE + LOGO_TEXT_GAP + TEXT_WIDTH;
    logo_center_x = -content_w/2 + LOGO_SIZE/2;
    text_left_x   = -content_w/2 + LOGO_SIZE + LOGO_TEXT_GAP;

    translate([0, 0, BASE_HEIGHT]) {
        translate([logo_center_x, 0, 0]) ase_logo_3d();
        translate([text_left_x,  0, 0]) stacked_text_3d();
    }
}

// The black base: a flat rectangle, centered in XY, sitting on Z=0.
module base_layer() {
    translate([-BASE_WIDTH/2, -BASE_DEPTH/2, 0])
        cube([BASE_WIDTH, BASE_DEPTH, BASE_HEIGHT]);
}

module ase_logo_sign_stacked() {
    if (PART == "base") {
        base_layer();
    } else if (PART == "top") {
        top_layer();
    } else {
        color("black") base_layer();
        color("white") top_layer();
    }
}

ase_logo_sign_stacked();
