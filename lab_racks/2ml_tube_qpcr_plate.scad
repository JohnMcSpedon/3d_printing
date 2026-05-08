// 2mL Tube qPCR Plate
// SLAS footprint: 3 rows x 8 cols of tube holders. Each well has a
// rectangular cap-securing slot offset in +Y from the cylindrical cutout,
// with a 6mm solid gap in Y between them.

$fn = 50;

// SLAS Standard Footprint
SLAS_LENGTH = 127.76;  // mm (X)
SLAS_WIDTH = 85.48;    // mm (Y)

// Tube dimensions (for reference)
TUBE_OD = 10.1;
TUBE_HEIGHT = 30;

// Cylindrical cutout (unchanged from lysis_tube_rack)
CUTOUT_OD = 11;        // mm
CUTOUT_DEPTH = 25;     // mm

// Cap-securing slot, offset in +Y from each cylinder
CAP_SLOT_Y_GAP = 6;    // mm of solid material between cylinder edge and slot edge in Y
SLOT_WIDTH_X = 14;     // mm
SLOT_DEPTH_Y = 8;      // mm

// Grid layout
GRID_COLS = 8;
GRID_ROWS = 3;

// X layout: 15mm spacing fits 8 cols inside SLAS length.
// Walls between cylinders: 4mm. Walls between slots: 1mm (thin but printable;
// the slot walls are reinforced by the thicker cylinder walls below them).
X_SPACING = 15;
X_SPAN = (GRID_COLS - 1) * X_SPACING;
X_MARGIN = (SLAS_LENGTH - X_SPAN) / 2;  // ~11.38mm

// Y layout: each row spans cylinder + gap + slot = 25mm. Three rows plus
// edge margins must fit within 85.48mm; remaining slack is split between
// the two inter-row walls.
Y_ROW_SPAN = CUTOUT_OD + CAP_SLOT_Y_GAP + SLOT_DEPTH_Y;  // 25mm
Y_EDGE_MARGIN = 3;     // wall thickness at the rack's Y edges
Y_BETWEEN_ROW_GAP = (SLAS_WIDTH - GRID_ROWS * Y_ROW_SPAN - 2 * Y_EDGE_MARGIN) / (GRID_ROWS - 1);
                       // ~2.24mm wall between consecutive rows

Y_MARGIN = Y_EDGE_MARGIN + CUTOUT_OD / 2;  // bottom rack edge to row 0 well center
Y_SPACING = Y_ROW_SPAN + Y_BETWEEN_ROW_GAP;

// Rack height (unchanged from original)
FLOOR_THICKNESS = 3;
RACK_HEIGHT = FLOOR_THICKNESS + CUTOUT_DEPTH;  // 28mm

// Label parameters — raised on the 6mm solid strip between each cylinder and slot
LABEL_HEIGHT = 1;      // mm raised above top surface
LABEL_SIZE = 3;
LABEL_FONT = "Roboto:style=Bold";
LABEL_Y_OFFSET = CUTOUT_OD / 2 + CAP_SLOT_Y_GAP / 2;  // +8.5mm above well center

// Main rack body
module rack_body() {
    cube([SLAS_LENGTH, SLAS_WIDTH, RACK_HEIGHT]);
}

// Cylindrical tube cutouts
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

// Cap-securing rectangular slots, offset in +Y from each cylinder
module cap_slot_cutouts() {
    slot_y_offset = CUTOUT_OD / 2 + CAP_SLOT_Y_GAP + SLOT_DEPTH_Y / 2;  // 15.5mm
    for (col = [0 : GRID_COLS - 1]) {
        for (row = [0 : GRID_ROWS - 1]) {
            translate([
                X_MARGIN + col * X_SPACING - SLOT_WIDTH_X / 2,
                Y_MARGIN + row * Y_SPACING + slot_y_offset - SLOT_DEPTH_Y / 2,
                FLOOR_THICKNESS
            ])
            cube([SLOT_WIDTH_X, SLOT_DEPTH_Y, CUTOUT_DEPTH + 0.01]);
        }
    }
}

// Well labels — A1 at the (min X, max Y) corner, lettered by row, numbered by column.
// Raised on the 6mm solid strip between each cylinder and its slot.
module well_labels() {
    row_letters = ["A", "B", "C"];
    for (col = [0 : GRID_COLS - 1]) {
        for (row = [0 : GRID_ROWS - 1]) {
            display_row = (GRID_ROWS - 1) - row;
            label_str = str(row_letters[display_row], col + 1);

            translate([
                X_MARGIN + col * X_SPACING,
                Y_MARGIN + row * Y_SPACING + LABEL_Y_OFFSET,
                RACK_HEIGHT
            ])
            linear_extrude(height = LABEL_HEIGHT)
            text(label_str, size = LABEL_SIZE, font = LABEL_FONT,
                 halign = "center", valign = "center");
        }
    }
}

// Main assembly
module qpcr_tube_plate() {
    union() {
        difference() {
            rack_body();
            tube_cutouts();
            cap_slot_cutouts();
        }
        well_labels();
    }
}

// Render
qpcr_tube_plate();
