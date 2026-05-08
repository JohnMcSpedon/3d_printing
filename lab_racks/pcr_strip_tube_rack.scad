// PCR Strip Tube Rack
// SLAS footprint with 8x12 grid of wells on 9mm SBS pitch for
// multichannel pipette compatibility. Sized for 0.2mL PCR strip tubes.

$fn = 50;

// SLAS Standard Footprint
SLAS_LENGTH = 127.76;  // mm (X direction)
SLAS_WIDTH = 85.48;    // mm (Y direction)

// Cutout dimensions
CUTOUT_RADIUS = 3.15;  // mm
CUTOUT_OD = CUTOUT_RADIUS * 2;  // 6.3mm

// Grid layout — 96 wells, SBS standard
GRID_COLS = 12;        // along X (length)
GRID_ROWS = 8;         // along Y (width)
WELL_SPACING = 9;      // mm, SBS pitch (matches multichannel pipettes)

// Calculate positions — center the grid in the SLAS footprint
X_SPAN = (GRID_COLS - 1) * WELL_SPACING;  // 11 * 9 = 99mm
X_MARGIN = (SLAS_LENGTH - X_SPAN) / 2;    // ~14.38mm
Y_SPAN = (GRID_ROWS - 1) * WELL_SPACING;  // 7 * 9 = 63mm
Y_MARGIN = (SLAS_WIDTH - Y_SPAN) / 2;     // ~11.24mm

// Rack height
RACK_HEIGHT = 18.5;      // mm
FLOOR_THICKNESS = 3;   // mm
CUTOUT_DEPTH = RACK_HEIGHT - FLOOR_THICKNESS;  // 15.5mm

// Label parameters — raised above the top surface
LABEL_HEIGHT = 1;      // mm above plate surface
LABEL_SIZE = 4;        // mm font size
LABEL_FONT = "Roboto:style=Bold";
ROW_LABEL_X = X_MARGIN / 2;              // left margin, A-H
COL_LABEL_Y = SLAS_WIDTH - Y_MARGIN / 2; // top margin, 1-12

// Orientation chamfers — both left corners are cut so a 180° rotation moves
// the cuts to the right side and is immediately visible.
CHAMFER_SIZE = 5;      // mm along each edge

// Main rack body
module rack_body() {
    cube([SLAS_LENGTH, SLAS_WIDTH, RACK_HEIGHT]);
}

// Cylindrical tube cutouts
module tube_cutouts() {
    for (col = [0 : GRID_COLS - 1]) {
        for (row = [0 : GRID_ROWS - 1]) {
            translate([
                X_MARGIN + col * WELL_SPACING,
                Y_MARGIN + row * WELL_SPACING,
                FLOOR_THICKNESS
            ])
            cylinder(d = CUTOUT_OD, h = CUTOUT_DEPTH + 0.01);
        }
    }
}

// Column number labels (1-12) along the top edge
module col_labels() {
    for (col = [0 : GRID_COLS - 1]) {
        translate([
            X_MARGIN + col * WELL_SPACING,
            COL_LABEL_Y,
            RACK_HEIGHT
        ])
        linear_extrude(height = LABEL_HEIGHT)
        text(str(col + 1), size = LABEL_SIZE, font = LABEL_FONT,
             halign = "center", valign = "center");
    }
}

// Row letter labels (A-H) along the left edge — A at max Y
module row_labels() {
    for (row = [0 : GRID_ROWS - 1]) {
        display_row = (GRID_ROWS - 1) - row;
        translate([
            ROW_LABEL_X,
            Y_MARGIN + row * WELL_SPACING,
            RACK_HEIGHT
        ])
        linear_extrude(height = LABEL_HEIGHT)
        text(chr(65 + display_row), size = LABEL_SIZE, font = LABEL_FONT,
             halign = "center", valign = "center");
    }
}

// Triangular chamfer cuts at top-left and bottom-left corners
module chamfer_cutouts() {
    overflow = 0.1;
    h = RACK_HEIGHT + 2 * overflow;

    // Bottom-left
    translate([0, 0, -overflow])
    linear_extrude(height = h)
    polygon([
        [-overflow, -overflow],
        [CHAMFER_SIZE, -overflow],
        [-overflow, CHAMFER_SIZE]
    ]);

    // Top-left
    translate([0, 0, -overflow])
    linear_extrude(height = h)
    polygon([
        [-overflow, SLAS_WIDTH + overflow],
        [-overflow, SLAS_WIDTH - CHAMFER_SIZE],
        [CHAMFER_SIZE, SLAS_WIDTH + overflow]
    ]);
}

// Main assembly
module pcr_strip_tube_rack() {
    difference() {
        rack_body();
        tube_cutouts();
        chamfer_cutouts();
    }
    col_labels();
    row_labels();
}

// Render
pcr_strip_tube_rack();
