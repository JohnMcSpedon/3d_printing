// Eppendorf Tube Rack
// Requested by Jonathan for qiavac 1223 run
// 4x12 grid of 1.5 mL Eppendorf tube cutouts

$fn = 50;

// Cutout dimensions
CUTOUT_OD = 11.1;       // mm diameter
CUTOUT_DEPTH = 25;      // mm

// Grid layout
GRID_COLS = 12;         // along X, columns 1-12
GRID_ROWS = 4;          // along Y, rows A-D

// Spacing (center-to-center)
X_SPACING = 16;         // mm
Y_SPACING = 26;         // mm

// Margins (outer wall to first well center)
X_MARGIN = 10;          // mm
Y_MARGIN = 10;          // mm

// Calculated footprint
X_SPAN = (GRID_COLS - 1) * X_SPACING;           // 286mm
Y_SPAN = (GRID_ROWS - 1) * Y_SPACING;           // 48mm
RACK_LENGTH = X_SPAN + 2 * X_MARGIN;            // 306mm
RACK_WIDTH  = Y_SPAN + 2 * Y_MARGIN;            // 68mm

// Rack height
FLOOR_THICKNESS = 3;                            // mm
RACK_HEIGHT = FLOOR_THICKNESS + CUTOUT_DEPTH;   // 28mm

// Minimum wall left around each tube cutout when carving out the
// between-row gaps
WALL_THICKNESS = 2;     // mm

// Label parameters
LABEL_DEPTH = 0.5;       // mm, engraving depth into top surface
LABEL_SIZE = 3;          // mm, font size
LABEL_FONT = "Roboto:style=Bold";

// Row letters: index 0 is at min Y; A sits at max Y (96-well plate convention)
ROW_LETTERS = ["D", "C", "B", "A"];

// Main rack body
module rack_body() {
    cube([RACK_LENGTH, RACK_WIDTH, RACK_HEIGHT]);
}

// Tube cutouts
module tube_cutouts() {
    for (col = [0 : GRID_COLS - 1]) {
        for (row = [0 : GRID_ROWS - 1]) {
            translate([
                X_MARGIN + col * X_SPACING,
                Y_MARGIN + row * Y_SPACING,
                FLOOR_THICKNESS
            ])
            cylinder(d = CUTOUT_OD, h = CUTOUT_DEPTH + 0.01);
        }
    }
}

// Through-slots in the gaps between rows to reduce wasted material.
// Each slot goes all the way through in X (open on both end faces) and
// from the floor to the top, leaving a WALL_THICKNESS ring of material
// around every cutout.
module row_gap_slots() {
    slot_y = Y_SPACING - CUTOUT_OD - 2 * WALL_THICKNESS;
    for (gap = [0 : GRID_ROWS - 2]) {
        translate([
            -1,
            Y_MARGIN + (gap + 0.5) * Y_SPACING - slot_y / 2,
            FLOOR_THICKNESS
        ])
        cube([RACK_LENGTH + 2, slot_y, CUTOUT_DEPTH + 0.01]);
    }
}

// Row labels A-D engraved on top surface, left margin
module row_labels() {
    for (row = [0 : GRID_ROWS - 1]) {
        translate([
            X_MARGIN / 3,
            Y_MARGIN + row * Y_SPACING,
            RACK_HEIGHT - LABEL_DEPTH
        ])
        linear_extrude(height = LABEL_DEPTH + 0.01)
        text(ROW_LETTERS[row], size = LABEL_SIZE, font = LABEL_FONT,
             halign = "center", valign = "center");
    }
}

// Column labels 1-12 engraved on top surface, top margin (above row A)
module column_labels() {
    for (col = [0 : GRID_COLS - 1]) {
        translate([
            X_MARGIN + col * X_SPACING,
            RACK_WIDTH - Y_MARGIN / 4,
            RACK_HEIGHT - LABEL_DEPTH
        ])
        linear_extrude(height = LABEL_DEPTH + 0.01)
        text(str(col + 1), size = LABEL_SIZE, font = LABEL_FONT,
             halign = "center", valign = "center");
    }
}

// Main assembly
module eppendorf_tube_rack() {
    difference() {
        rack_body();
        tube_cutouts();
        row_gap_slots();
        row_labels();
        column_labels();
    }
}

// Render
eppendorf_tube_rack();
