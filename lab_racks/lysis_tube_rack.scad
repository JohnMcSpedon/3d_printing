// Lysis Tube Rack
// SLAS footprint with 4x6 grid of tube holders

$fn = 50;

// SLAS Standard Footprint
SLAS_LENGTH = 127.76;  // mm (X direction)
SLAS_WIDTH = 85.48;    // mm (Y direction)

// Tube dimensions (for reference)
TUBE_OD = 10.1;        // mm, actual tube outer diameter
TUBE_HEIGHT = 30;      // mm, actual tube height

// Cutout dimensions
CUTOUT_OD = 10.3;      // mm
CUTOUT_DEPTH = 25;     // mm

// Grid layout
GRID_COLS = 6;         // along X (length), 18mm spacing
GRID_ROWS = 4;         // along Y (width), evenly spaced

// Spacing
X_SPACING = 18;        // mm, center-to-center for 6-tube axis

// Calculate X positions
X_SPAN = (GRID_COLS - 1) * X_SPACING;  // 5 * 18 = 90mm
X_MARGIN = (SLAS_LENGTH - X_SPAN) / 2; // ~18.88mm

// Calculate Y spacing to evenly distribute 4 tubes with equal margins
Y_MARGIN = X_MARGIN;   // Use same margin for visual consistency
Y_SPAN = SLAS_WIDTH - 2 * Y_MARGIN;
Y_SPACING = Y_SPAN / (GRID_ROWS - 1);  // ~15.91mm

// Rack height
FLOOR_THICKNESS = 3;   // mm
RACK_HEIGHT = CUTOUT_DEPTH + FLOOR_THICKNESS;  // 28mm total

// Main rack body
module rack_body() {
    cube([SLAS_LENGTH, SLAS_WIDTH, RACK_HEIGHT]);
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

// Main assembly
module lysis_tube_rack() {
    difference() {
        rack_body();
        tube_cutouts();
    }
}

// Render
lysis_tube_rack();
