// Sterility Tube Holder for 71mm tubes
// Parametric design for 2x10 grid with wall cutouts

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

// Cutout parameters
CUTOUT_WIDTH = 14;     // mm, width of cutout in each wall
ARCH_HEIGHT = CUTOUT_WIDTH / 4;  // 3.5mm for strict 45-degree self-supporting parabolic arch

// Calculated dimensions
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

// Rounded arch profile for self-supporting cutouts (2D polygon)
// Creates a parabolic curve: y = ARCH_HEIGHT * (1 - x²/(half_width)²)
module rounded_arch_2d(segments = 20) {
    half_width = CUTOUT_WIDTH / 2;
    points = [
        for (i = [0 : segments])
            let(x = -half_width + i * CUTOUT_WIDTH / segments)
            [x, ARCH_HEIGHT * (1 - (x * x) / (half_width * half_width))]
    ];
    polygon(points);
}

// Single solid wall segment
module grid_wall(num_cells, thickness) {
    wall_length = (num_cells + 1) * WALL_THICKNESS + num_cells * CELL_SIZE;
    cube([wall_length, thickness, TOTAL_HEIGHT]);
}

// All walls forming the grid (solid version)
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

// Wall grid with cutouts
module wall_grid_with_cutouts() {
    difference() {
        wall_grid();

        // Cutouts in horizontal walls (walls running along X) with rounded arches
        for (row = [0 : GRID_ROWS]) {
            for (col = [0 : GRID_COLS - 1]) {
                // Center of cell in X
                cell_center_x = WALL_THICKNESS + col * (CELL_SIZE + WALL_THICKNESS) + CELL_SIZE / 2;
                // Y position of wall
                wall_y = row * (CELL_SIZE + WALL_THICKNESS);

                // Rectangular portion (reduced height to make room for arch and solid cap)
                translate([cell_center_x - CUTOUT_WIDTH/2, wall_y - 0.01, FLOOR_HEIGHT])
                cube([CUTOUT_WIDTH, WALL_THICKNESS + 0.02, WALL_HEIGHT - ARCH_HEIGHT - WALL_THICKNESS]);

                // Rounded arch at top (self-supporting parabolic curve, with WALL_THICKNESS cap above)
                translate([cell_center_x, wall_y + WALL_THICKNESS + 0.01, TOTAL_HEIGHT - ARCH_HEIGHT - WALL_THICKNESS])
                rotate([90, 0, 0])
                linear_extrude(height = WALL_THICKNESS + 0.02)
                rounded_arch_2d();
            }
        }

        // Cutouts in vertical walls (walls running along Y) with rounded arches
        for (col = [0 : GRID_COLS]) {
            for (row = [0 : GRID_ROWS - 1]) {
                // Center of cell in Y
                cell_center_y = WALL_THICKNESS + row * (CELL_SIZE + WALL_THICKNESS) + CELL_SIZE / 2;
                // X position of wall
                wall_x = col * (CELL_SIZE + WALL_THICKNESS);

                // Rectangular portion (reduced height to make room for arch and solid cap)
                translate([wall_x - 0.01, cell_center_y - CUTOUT_WIDTH/2, FLOOR_HEIGHT])
                cube([WALL_THICKNESS + 0.02, CUTOUT_WIDTH, WALL_HEIGHT - ARCH_HEIGHT - WALL_THICKNESS]);

                // Rounded arch at top (self-supporting parabolic curve, with WALL_THICKNESS cap above)
                translate([wall_x - 0.01, cell_center_y, TOTAL_HEIGHT - ARCH_HEIGHT - WALL_THICKNESS])
                rotate([90, 0, 90])
                linear_extrude(height = WALL_THICKNESS + 0.02)
                rounded_arch_2d();
            }
        }
    }
}

// Main assembly
module sterility_tube_holder() {
    floor_plate();
    wall_grid_with_cutouts();
}

// Render
sterility_tube_holder();
