// Analytic Services Express logo sign
// Two-color print: 1 mm black base + raised white logo & company name on top.
// Logo + text are centered as a group on the base.
//
// Requires Raleway font installed (`brew install --cask font-raleway`).
//
// Two-color export workflow (no MMU/AMS scripting in OpenSCAD):
//   1. Set PART = "base", F6 render, export ase_logo_sign_base.stl
//   2. Set PART = "top",  F6 render, export ase_logo_sign_top.stl
//   3. In Bambu Studio: load base.stl, right-click -> Add Part -> top.stl
//      (shared origin -> auto-aligned). Assign black filament to base,
//      white to top.

$fn = 60;

// Base rectangle (the black layer)
BASE_WIDTH      = 250;  // mm, X
BASE_DEPTH      = 60;   // mm, Y
BASE_HEIGHT     = 1;    // mm, Z

// Top (white) layer — logo + text raised above the base
TOP_HEIGHT      = 1;    // mm, raised height of logo + text
LOGO_SIZE       = 20;   // mm, square (logo native aspect is 1:1)
TEXT_SIZE       = 12;   // mm, font cap height for company name
COMPANY_NAME    = "Analytic Services Express";
FONT_NAME       = "Raleway:style=SemiBold";

// Rendered width of COMPANY_NAME in mm. Used to center the logo+text group
// on the base. If you change COMPANY_NAME, FONT_NAME, or TEXT_SIZE, update
// this. To measure the exact value, enable Preferences > Features >
// textmetrics in OpenSCAD and run, in any .scad file:
//   echo(textmetrics(text=COMPANY_NAME, size=TEXT_SIZE, font=FONT_NAME).size);
// Or as a quick estimate: ~ len(COMPANY_NAME) * TEXT_SIZE * 0.62 for Raleway.
TEXT_WIDTH      = 200;  // mm, X (Raleway SemiBold, 12 mm, "Analytic Services Express")

// Layout (left-to-right: [LOGO][LOGO_TEXT_GAP][TEXT], group centered on base)
LOGO_TEXT_GAP   = 5;    // mm, gap between logo right edge and text start

// Render mode: "all" (preview, both colored), "base", or "top"
PART            = "all";


// 2D logo in its native 33 x 33 coordinate system: a rounded square frame
// (white border) with a 4-pointed concave star window cut out of the
// interior. Matches ASE-logo.svg geometry exactly. When printed in white
// on the black base, the black base shows through the star window.
module ase_logo_2d() {
    difference() {
        // Outer: 33x33 rounded square, corner radius 5, spanning (0,0)..(33,33)
        offset(r = 5) translate([5, 5]) square([23, 23]);

        // Inner star window: 25x25 inset region (truncates star tips at
        // distance 4 from each outer edge -> 1 mm flat tips, per the SVG)
        // with 4 corner-anchored arcs (r=12) carving the concave sides.
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

// 3D company name text. Origin is the left edge horizontally, vertical
// midline (per halign/valign), at the bottom of the extrusion (Z=0).
module company_text_3d() {
    linear_extrude(height = TOP_HEIGHT)
        text(COMPANY_NAME,
             size    = TEXT_SIZE,
             font    = FONT_NAME,
             halign  = "left",
             valign  = "center");
}

// The raised white layer: logo on the left, text to its right, both
// centered vertically on the base AND centered as a group horizontally.
// Sits on top of the base (Z=BASE_HEIGHT).
module top_layer() {
    content_w = LOGO_SIZE + LOGO_TEXT_GAP + TEXT_WIDTH;
    logo_center_x = -content_w/2 + LOGO_SIZE/2;
    text_left_x   = -content_w/2 + LOGO_SIZE + LOGO_TEXT_GAP;

    translate([0, 0, BASE_HEIGHT]) {
        translate([logo_center_x, 0, 0]) ase_logo_3d();
        translate([text_left_x,  0, 0]) company_text_3d();
    }
}

// The black base: a flat rectangle, centered in XY, sitting on Z=0.
module base_layer() {
    translate([-BASE_WIDTH/2, -BASE_DEPTH/2, 0])
        cube([BASE_WIDTH, BASE_DEPTH, BASE_HEIGHT]);
}

module ase_logo_sign() {
    if (PART == "base") {
        base_layer();
    } else if (PART == "top") {
        top_layer();
    } else {
        color("black") base_layer();
        color("white") top_layer();
    }
}

ase_logo_sign();
