// Sterility Tube Holder for 71mm tubes
// Parametric design for 2x10 grid with solid walls

$fn = 50;

// Grid dimensions
GRID_COLS = 2;
GRID_ROWS = 10;
CELL_SIZE = 17.5;  // mm, square well size (17.5 x 17.5mm)

// Tube parameters
TUBE_OD = 16.2;    // mm, tube outer diameter (for reference)

// Floor parameters
FLOOR_HEIGHT = 7;  // mm
WELL_OD = 16.8;    // mm, cylindrical well diameter in floor
WELL_DEPTH = 3;    // mm, depth of well cutout

// Wall parameters
WALL_HEIGHT = 85;      // mm, height above floor
WALL_THICKNESS = 4;    // mm

// Calculated dimensions
// (n+1) walls + n tube slots in each direction
TOTAL_WIDTH = (GRID_COLS + 1) * WALL_THICKNESS + GRID_COLS * CELL_SIZE;   // X direction
TOTAL_DEPTH = (GRID_ROWS + 1) * WALL_THICKNESS + GRID_ROWS * CELL_SIZE;   // Y direction
TOTAL_HEIGHT = FLOOR_HEIGHT + WALL_HEIGHT;

// Floor plate with cylindrical wells for each tube
module floor_plate() {
    difference() {
        // Solid floor
        cube([TOTAL_WIDTH, TOTAL_DEPTH, FLOOR_HEIGHT]);

        // Cut cylindrical wells for each tube position (flat bottom tubes)
        for (col = [0 : GRID_COLS - 1]) {
            for (row = [0 : GRID_ROWS - 1]) {
                translate([
                    WALL_THICKNESS + col * (CELL_SIZE + WALL_THICKNESS) + CELL_SIZE / 2,
                    WALL_THICKNESS + row * (CELL_SIZE + WALL_THICKNESS) + CELL_SIZE / 2,
                    FLOOR_HEIGHT - WELL_DEPTH
                ])
                cylinder(d = WELL_OD, h = WELL_DEPTH + 0.01);
            }
        }
    }
}

// Single solid wall segment
// Wall runs along X axis, height in Z, thickness in Y
// num_cells: number of tube cells this wall spans
module grid_wall(num_cells, thickness) {
    wall_length = (num_cells + 1) * WALL_THICKNESS + num_cells * CELL_SIZE;
    cube([wall_length, thickness, TOTAL_HEIGHT]);
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
module sterility_tube_holder() {
    floor_plate();
    wall_grid();
}

// Render
sterility_tube_holder();
