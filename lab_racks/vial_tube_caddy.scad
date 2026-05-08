// Vial Tube Caddy — 2x5 grid
// Columns 1-5: pharmacy vials (cupholder profile: 17mm bottom, 23mm top)
// Column 6 (sterility tubes) removed.

$fn = 60;

// Grid
GRID_COLS = 5;
GRID_ROWS = 2;
CELL_SIZE = 24;
WALL_THICKNESS = 4;

// Heights
WALL_HEIGHT = 20;
FLOOR_HEIGHT = 4;

// Sterility tube hole (column 6) — disabled
// STERILITY_HOLE_D = 17;

// Pharmacy vial hole (columns 1-5) — two-tier cupholder
VIAL_BOTTOM_D = 17;
VIAL_BOTTOM_H = 8;
VIAL_TOP_D = 23;
VIAL_TOP_H = 12;

// Calculated dimensions
TOTAL_WIDTH = (GRID_COLS + 1) * WALL_THICKNESS + GRID_COLS * CELL_SIZE;
TOTAL_DEPTH = (GRID_ROWS + 1) * WALL_THICKNESS + GRID_ROWS * CELL_SIZE;
TOTAL_HEIGHT = FLOOR_HEIGHT + WALL_HEIGHT;

module pharmacy_vial_hole() {
    // Bottom narrow tier
    cylinder(d = VIAL_BOTTOM_D, h = VIAL_BOTTOM_H);
    // Top wide tier
    translate([0, 0, VIAL_BOTTOM_H])
        cylinder(d = VIAL_TOP_D, h = VIAL_TOP_H + 0.01);
}

// module sterility_tube_hole() {
//     cylinder(d = STERILITY_HOLE_D, h = WALL_HEIGHT + 0.01);
// }

module vial_tube_caddy() {
    difference() {
        // Solid body
        translate([0, 0, -FLOOR_HEIGHT])
            cube([TOTAL_WIDTH, TOTAL_DEPTH, TOTAL_HEIGHT]);

        // Holes
        for (col = [0 : GRID_COLS - 1]) {
            for (row = [0 : GRID_ROWS - 1]) {
                x = WALL_THICKNESS + col * (CELL_SIZE + WALL_THICKNESS) + CELL_SIZE / 2;
                y = WALL_THICKNESS + row * (CELL_SIZE + WALL_THICKNESS) + CELL_SIZE / 2;

                translate([x, y, 0]) {
                    pharmacy_vial_hole();
                    // if (col < 5)
                    //     pharmacy_vial_hole();
                    // else
                    //     sterility_tube_hole();
                }
            }
        }
    }
}

vial_tube_caddy();
