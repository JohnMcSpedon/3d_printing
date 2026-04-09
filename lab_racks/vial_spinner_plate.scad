// Vial Spinner Plate
// SLAS footprint with 8x6 grid of vial cutouts

$fn = 50;

// SLAS Standard Footprint
SLAS_LENGTH = 127.76;  // mm (X direction)
SLAS_WIDTH = 85.48;    // mm (Y direction)

// Cutout dimensions
CUTOUT_OD = 11.9;      // mm diameter
CUTOUT_DEPTH = 21;     // mm

// Grid layout
GRID_COLS = 8;          // along X (length), columns 1-8
GRID_ROWS = 6;          // along Y (width), rows A-F

// Spacing (center-to-center)
X_SPACING = 15;         // mm
Y_SPACING = 13;         // mm

// Calculated margins (centering the grid in the footprint)
X_SPAN = (GRID_COLS - 1) * X_SPACING;  // 105mm
X_MARGIN = (SLAS_LENGTH - X_SPAN) / 2; // ~11.38mm

Y_SPAN = (GRID_ROWS - 1) * Y_SPACING;  // 65mm
Y_MARGIN = (SLAS_WIDTH - Y_SPAN) / 2;  // ~10.24mm

// Rack height
FLOOR_THICKNESS = 6;    // mm
WALL_HEIGHT = 21;       // mm, above floor
RACK_HEIGHT = FLOOR_THICKNESS + WALL_HEIGHT;  // 26mm total

// Label parameters
LABEL_DEPTH = 0.5;      // mm, engraving depth into top surface
LABEL_SIZE = 3;          // mm, font size
LABEL_FONT = "Roboto:style=Bold";

// Bottom slot parameters (two rectangular cutouts on underside)
SLOT_HEIGHT = 3;        // mm, from bottom of floor upward
SLOT_Y = 20;            // mm, extent in Y axis
SLOT_OUTER_SPAN = 122.3;  // mm, outer edge to outer edge
SLOT_INNER_SPAN = 98;     // mm, inner edge to inner edge
SLOT_WIDTH = (SLOT_OUTER_SPAN - SLOT_INNER_SPAN) / 2;  // 12.15mm each
SLOT_X_OFFSET = (SLAS_LENGTH - SLOT_OUTER_SPAN) / 2;   // 2.73mm from plate edge

// Row labels (index 0 = bottom row = F, index 5 = top row = A)
ROW_LETTERS = ["F", "E", "D", "C", "B", "A"];

// Main rack body
module rack_body() {
    cube([SLAS_LENGTH, SLAS_WIDTH, RACK_HEIGHT]);
}

// Vial cutouts
module vial_cutouts() {
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

// Row labels A-F engraved on top surface, left margin
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

// Column labels 1-8 engraved on top surface, bottom margin
module column_labels() {
    for (col = [0 : GRID_COLS - 1]) {
        translate([
            X_MARGIN + col * X_SPACING,
            Y_MARGIN / 4,
            RACK_HEIGHT - LABEL_DEPTH
        ])
        linear_extrude(height = LABEL_DEPTH + 0.01)
        text(str(col + 1), size = LABEL_SIZE, font = LABEL_FONT,
             halign = "center", valign = "center");
    }
}

// Bottom slots — two rectangular cutouts on underside, centered in Y
module bottom_slots() {
    slot_y = (SLAS_WIDTH - SLOT_Y) / 2;

    // Left slot
    translate([SLOT_X_OFFSET, slot_y, -0.01])
    cube([SLOT_WIDTH, SLOT_Y, SLOT_HEIGHT + 0.01]);

    // Right slot
    translate([SLAS_LENGTH - SLOT_X_OFFSET - SLOT_WIDTH, slot_y, -0.01])
    cube([SLOT_WIDTH, SLOT_Y, SLOT_HEIGHT + 0.01]);
}

// Main assembly
module vial_spinner_plate() {
    difference() {
        rack_body();
        vial_cutouts();
        row_labels();
        column_labels();
        bottom_slots();
    }
}

// Render
vial_spinner_plate();
