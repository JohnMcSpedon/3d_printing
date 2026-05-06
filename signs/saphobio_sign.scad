// SaphoBio logo sign
// Two-color print: 1 mm black base + raised green logo+wordmark on top.
// The logo+text graphic is imported from a vectorized SVG of the
// saphobio.com header logo (potrace-traced from the source PNG).
//
// Two-color export workflow (no MMU/AMS scripting in OpenSCAD):
//   1. Set PART = "base", F6 render, export saphobio_sign_base.stl
//   2. Set PART = "top",  F6 render, export saphobio_sign_top.stl
//   3. In Bambu Studio: load base.stl, right-click -> Add Part -> top.stl
//      (shared origin -> auto-aligned). Assign black to base, green to top.

$fn = 60;

// Base rectangle (the black layer)
BASE_WIDTH      = 240;  // mm, X
BASE_DEPTH      = 70;   // mm, Y
BASE_HEIGHT     = 1;    // mm, Z

// Top (green) layer — logo + text raised above the base
TOP_HEIGHT      = 1;    // mm, raised height
LOGO_WIDTH      = 200;  // mm, target width of the imported logo+wordmark

// SVG asset is at signs/assets/saphobio_logo.svg. OpenSCAD imports SVG
// using pt units (1 pt = 1/72 in ≈ 0.353 mm), so the asset comes in at
// approximately 1050 mm x 212 mm in OpenSCAD's coordinate system, and
// the content's bounding box is offset slightly from the origin (the
// native bottom-left of the geometry is at SVG_MIN_*, not 0,0).
// Constants below were measured from `linear_extrude(1) import(...)`
// STL bounds. LOGO_WIDTH drives the scale we apply on import.
SVG_NATIVE_W    = 1050.16;  // mm, content width
SVG_NATIVE_H    = 211.68;   // mm, content height
SVG_MIN_X       = 4.23;     // mm, X offset of content bbox from origin
SVG_MIN_Y       = 2.12;     // mm, Y offset of content bbox from origin
LOGO_HEIGHT     = LOGO_WIDTH * SVG_NATIVE_H / SVG_NATIVE_W;

// Render mode: "all" (preview, both colored), "base", or "top"
PART            = "all";


// 3D logo + wordmark: imported SVG, scaled to LOGO_WIDTH wide, centered
// at origin in XY (sits on Z=0).
module saphobio_logo_3d() {
    s = LOGO_WIDTH / SVG_NATIVE_W;
    // Translate by -(content bbox origin)*s to bring the bbox bottom-left
    // to OpenSCAD origin, then by -(LOGO_WIDTH/2, LOGO_HEIGHT/2) to center.
    translate([-LOGO_WIDTH/2 - SVG_MIN_X*s, -LOGO_HEIGHT/2 - SVG_MIN_Y*s, 0])
        linear_extrude(height = TOP_HEIGHT)
            scale([s, s])
                import("assets/saphobio_logo.svg");
}

// The raised green layer: sits on top of the base (Z=BASE_HEIGHT),
// centered on the base in XY.
module top_layer() {
    translate([0, 0, BASE_HEIGHT])
        saphobio_logo_3d();
}

// The black base: a flat rectangle, centered in XY, sitting on Z=0.
module base_layer() {
    translate([-BASE_WIDTH/2, -BASE_DEPTH/2, 0])
        cube([BASE_WIDTH, BASE_DEPTH, BASE_HEIGHT]);
}

module saphobio_sign() {
    if (PART == "base") {
        base_layer();
    } else if (PART == "top") {
        top_layer();
    } else {
        color("black")   base_layer();
        color("#d2ffc8") top_layer();
    }
}

saphobio_sign();
