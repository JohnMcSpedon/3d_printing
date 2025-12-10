// Cuvette Rack for Biology Tubes
// Parametric design for 4x10 grid with crosshatched walls

$fn = 50;

// Grid dimensions
GRID_COLS = 4;
GRID_ROWS = 10;
CELL_SIZE = 13;  // mm, space per tube

// Floor parameters
FLOOR_HEIGHT = 7;  // mm
DIVETTE_OD = 7;    // mm, outer diameter of tube indent
DIVETTE_DEPTH = 3; // mm, depth of tube indent

// Wall parameters
WALL_HEIGHT = 40;      // mm, height above floor
WALL_THICKNESS = 4;    // mm
WINDOW_BORDER = 2;     // mm, solid border around each window opening
MID_BAND_WIDTH = 4;    // mm, horizontal support band thickness

// Calculated dimensions
// (n+1) walls + n tube slots in each direction
TOTAL_WIDTH = (GRID_COLS + 1) * WALL_THICKNESS + GRID_COLS * CELL_SIZE;   // X direction
TOTAL_DEPTH = (GRID_ROWS + 1) * WALL_THICKNESS + GRID_ROWS * CELL_SIZE;   // Y direction
TOTAL_HEIGHT = FLOOR_HEIGHT + WALL_HEIGHT;

// Floor plate with divettes for each tube
module floor_plate() {
    difference() {
        // Solid floor
        cube([TOTAL_WIDTH, TOTAL_DEPTH, FLOOR_HEIGHT]);

        // Cut divettes for each tube position
        for (col = [0 : GRID_COLS - 1]) {
            for (row = [0 : GRID_ROWS - 1]) {
                translate([
                    WALL_THICKNESS + col * (CELL_SIZE + WALL_THICKNESS) + CELL_SIZE / 2,
                    WALL_THICKNESS + row * (CELL_SIZE + WALL_THICKNESS) + CELL_SIZE / 2,
                    FLOOR_HEIGHT - DIVETTE_DEPTH
                ])
                cylinder(d = DIVETTE_OD, h = DIVETTE_DEPTH + 0.01);
            }
        }
    }
}

// Single wall segment with window openings aligned to tube grid
// Wall runs along X axis, height in Z, thickness in Y
// num_cells: number of tube cells this wall spans
module grid_wall(num_cells, thickness) {
    cell_pitch = CELL_SIZE + WALL_THICKNESS;
    wall_length = (num_cells + 1) * WALL_THICKNESS + num_cells * CELL_SIZE;

    // Window dimensions: one per cell, with border around each
    // Split into upper and lower windows by mid band
    window_width = CELL_SIZE - 2 * WINDOW_BORDER;
    usable_height = WALL_HEIGHT - 2 * WINDOW_BORDER - MID_BAND_WIDTH;
    window_height = usable_height / 2;

    // Mid band position (centered in wall height above floor)
    mid_band_z = FLOOR_HEIGHT + WINDOW_BORDER + window_height;

    difference() {
        // Solid wall
        cube([wall_length, thickness, TOTAL_HEIGHT]);

        // Cut out windows - one per cell, above the floor
        for (i = [0 : num_cells - 1]) {
            // Lower window
            translate([
                WALL_THICKNESS + i * cell_pitch + WINDOW_BORDER,
                -0.01,
                FLOOR_HEIGHT + WINDOW_BORDER
            ])
            cube([window_width, thickness + 0.02, window_height]);

            // Upper window
            translate([
                WALL_THICKNESS + i * cell_pitch + WINDOW_BORDER,
                -0.01,
                mid_band_z + MID_BAND_WIDTH
            ])
            cube([window_width, thickness + 0.02, window_height]);
        }
    }
}

// All walls forming the grid
module wall_grid() {
    // Walls running in X direction (GRID_ROWS + 1 walls)
    for (row = [0 : GRID_ROWS]) {
        translate([0, row * (CELL_SIZE + WALL_THICKNESS), 0])
        grid_wall(GRID_COLS, WALL_THICKNESS);
    }

    // Walls running in Y direction (GRID_COLS + 1 walls)
    for (col = [0 : GRID_COLS]) {
        translate([col * (CELL_SIZE + WALL_THICKNESS) + WALL_THICKNESS, 0, 0])
        rotate([0, 0, 90])
        grid_wall(GRID_ROWS, WALL_THICKNESS);
    }
}

// Main assembly
module cuvette_rack() {
    floor_plate();
    wall_grid();
}

// Render
cuvette_rack();
