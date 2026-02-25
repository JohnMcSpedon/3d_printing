// ============================================================
//  Vial & Test Tube Holder
//
//  Layout (top view) — 2 columns × 6 rows:
//
//    Back  [ T1 ][ T2 ]   ← row 6: test tubes (tall section)
//          [ V  ][ V  ]   ← row 5
//          [ V  ][ V  ]   ← row 4
//          [ V  ][ V  ]   ← row 3
//          [ V  ][ V  ]   ← row 2
//    Front [ V  ][ V  ]   ← row 1
//
//  Small vials : 16 mm dia ×  39 mm tall  (qty 10, rows 1–5)
//  Test tubes  : 16 mm dia × 127 mm tall  (qty  2, row  6)
//
//  Test-tube section is perpendicular to the vial block
//  (steps up at the back of the narrow 2-column layout).
// ============================================================

$fn = 60;

// ---- User parameters ----------------------------------------
vial_dia    = 16;     // small vial outer diameter (mm)
vial_h      = 39;     // small vial height (mm)
tube_dia    = 16;     // test tube outer diameter (mm)
tube_h      = 127;    // test tube height (mm)

clearance   = 0.5;    // added to diameter for easy insertion
wall        = 2.5;    // minimum wall thickness (mm)
base_t      = 3.0;    // floor / base plate thickness (mm)

// Pocket depths
vial_pocket = 22;     // ≈ 56 % of vial height  → vials sit firmly
tube_pocket = 50;     // ≈ 39 % of tube height  → tubes held securely

chamfer     = 1.2;    // opening chamfer (helps insertion)

// ---- Derived values -----------------------------------------
vial_r  = (vial_dia + clearance) / 2;   // 8.25 mm
tube_r  = (tube_dia + clearance) / 2;   // 8.25 mm

pitch   = vial_dia + 2 * wall;          // 21 mm centre-to-centre

// Grid counts
cols    = 2;    // columns (shared by both sections)
rows_v  = 5;    // rows of small vials
rows_t  = 1;    // rows of test tubes

// ---- Section geometry ----------------------------------------
//  Main section  (5 rows of small vials — shorter)
main_w  = pitch * cols  + wall * 2;    // 2×21 + 5 =  47 mm wide
main_d  = pitch * rows_v + wall * 2;   // 5×21 + 5 = 110 mm deep
main_h  = vial_pocket + base_t;        //       22 + 3 =  25 mm tall

//  Back section  (1 row of test tubes — taller, shares back wall)
back_d  = pitch * rows_t + wall * 2;   // 1×21 + 5 =  26 mm deep
back_h  = tube_pocket + base_t;        //       50 + 3 =  53 mm tall

// ---- Helper: chamfered pocket --------------------------------
module pocket(r, depth) {
    cylinder(h = depth + 0.01, r = r);
    translate([0, 0, depth - chamfer])
        cylinder(h = chamfer + 0.01, r1 = r, r2 = r + chamfer);
}

// ---- Assemble the holder -------------------------------------
color("SteelBlue", 0.85)
difference() {

    // ---- Solid body ------------------------------------------
    union() {
        // Main section (small vials)
        cube([main_w, main_d, main_h]);

        // Back section (test tubes) — shares the back wall of main
        translate([0, main_d - wall, 0])
            cube([main_w, back_d, back_h]);
    }

    // ---- Small-vial pockets  (2 cols × 5 rows) ---------------
    for (col = [0 : cols - 1])
        for (row = [0 : rows_v - 1])
            translate([
                wall + pitch/2 + col * pitch,   // x centre
                wall + pitch/2 + row * pitch,   // y centre
                base_t
            ])
            pocket(vial_r, vial_pocket);

    // ---- Test-tube pockets  (2 cols × 1 row) -----------------
    // Y centre sits inside the back section
    ty0 = main_d + pitch/2;    // 110 + 10.5 = 120.5 mm

    for (col = [0 : cols - 1])
        translate([
            wall + pitch/2 + col * pitch,
            ty0,
            base_t
        ])
        pocket(tube_r, tube_pocket);
}

// ---- Dimension annotations (echo to console) -----------------
echo("=== Vial Holder Dimensions ===");
echo(str("Overall width  : ", main_w,                  " mm"));
echo(str("Overall depth  : ", main_d + back_d - wall,  " mm"));
echo(str("Vial section H : ", main_h,                  " mm  (rows 1-5)"));
echo(str("Tube section H : ", back_h,                  " mm  (row 6)"));
echo(str("Hole pitch     : ", pitch,                   " mm"));
echo(str("Hole dia (each): ", vial_r*2,                " mm  (incl. clearance)"));
