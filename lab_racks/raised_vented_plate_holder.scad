// Raised Vented Plate Holder
// SLAS-footprint holder for 96-well plates in shaking incubators
// Raises plate off sticky pad, provides airflow, prevents sliding

$fn = 50;

// SLAS Standard Microplate Footprint
SLAS_LENGTH = 127.76;  // mm (X direction)
SLAS_WIDTH = 85.48;     // mm (Y direction)

// Clearance
PLATE_CLEARANCE = 0.5;  // mm per side, between plate and lip

// Lip (raised perimeter rim above wall grid)
LIP_THICKNESS = 2;  // mm, wall thickness of lip
LIP_HEIGHT = 4;     // mm, height above wall tops

// Wall grid parameters
WALL_THICKNESS = 2;    // mm
GRID_COLS = 6;         // cells in X direction
GRID_ROWS = 4;         // cells in Y direction
SUPPORT_HEIGHT = 25;   // mm, wall height from build plate to wall tops

// Wall base (solid portion at build plate for adhesion)
BASE_HEIGHT = 2;  // mm

// Cutout parameters (self-supporting parabolic arches)
CUTOUT_WIDTH = 16;                // mm, width of arch cutout in each wall
ARCH_HEIGHT = CUTOUT_WIDTH / 4;   // 4mm, for 45-degree self-supporting overhang

// Cap between arch top and platform
CAP_HEIGHT = 2;  // mm

// Calculated dimensions
HOLDER_LENGTH = SLAS_LENGTH + 2 * PLATE_CLEARANCE + 2 * LIP_THICKNESS;  // ~132.76mm
HOLDER_WIDTH = SLAS_WIDTH + 2 * PLATE_CLEARANCE + 2 * LIP_THICKNESS;    // ~90.48mm

CELL_X = (HOLDER_LENGTH - (GRID_COLS + 1) * WALL_THICKNESS) / GRID_COLS;  // ~19.79mm
CELL_Y = (HOLDER_WIDTH - (GRID_ROWS + 1) * WALL_THICKNESS) / GRID_ROWS;   // ~20.12mm

// Cutout Z positions
CUTOUT_BOTTOM_Z = BASE_HEIGHT;                              // 2mm
ARCH_BOTTOM_Z = SUPPORT_HEIGHT - CAP_HEIGHT - ARCH_HEIGHT;  // 19mm
RECT_CUTOUT_HEIGHT = ARCH_BOTTOM_Z - CUTOUT_BOTTOM_Z;      // 17mm

// Parabolic arch profile for self-supporting cutouts (2D polygon)
// y = ARCH_HEIGHT * (1 - x^2 / half_width^2)
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
// num_cells: number of grid cells this wall spans
// cell_size: size of each cell along the wall's length
module grid_wall(num_cells, thickness, cell_size) {
    wall_length = (num_cells + 1) * WALL_THICKNESS + num_cells * cell_size;
    cube([wall_length, thickness, SUPPORT_HEIGHT]);
}

// All walls forming the support grid
module wall_grid() {
    // Walls running in X direction (GRID_ROWS + 1 walls)
    for (row = [0 : GRID_ROWS]) {
        translate([0, row * (CELL_Y + WALL_THICKNESS), 0])
        grid_wall(GRID_COLS, WALL_THICKNESS, CELL_X);
    }

    // Walls running in Y direction (GRID_COLS + 1 walls)
    for (col = [0 : GRID_COLS]) {
        translate([col * (CELL_X + WALL_THICKNESS) + WALL_THICKNESS, 0, 0])
        rotate([0, 0, 90])
        grid_wall(GRID_ROWS, WALL_THICKNESS, CELL_Y);
    }
}

// Wall grid with arch cutouts in all wall segments
module wall_grid_with_cutouts() {
    difference() {
        wall_grid();

        // Cutouts in X-running walls (horizontal walls)
        for (row = [0 : GRID_ROWS]) {
            for (col = [0 : GRID_COLS - 1]) {
                cell_center_x = WALL_THICKNESS + col * (CELL_X + WALL_THICKNESS) + CELL_X / 2;
                wall_y = row * (CELL_Y + WALL_THICKNESS);

                // Rectangular portion
                translate([cell_center_x - CUTOUT_WIDTH/2, wall_y - 0.01, CUTOUT_BOTTOM_Z])
                cube([CUTOUT_WIDTH, WALL_THICKNESS + 0.02, RECT_CUTOUT_HEIGHT]);

                // Parabolic arch at top
                translate([cell_center_x, wall_y + WALL_THICKNESS + 0.01, ARCH_BOTTOM_Z])
                rotate([90, 0, 0])
                linear_extrude(height = WALL_THICKNESS + 0.02)
                rounded_arch_2d();
            }
        }

        // Cutouts in Y-running walls (vertical walls)
        for (col = [0 : GRID_COLS]) {
            for (row = [0 : GRID_ROWS - 1]) {
                cell_center_y = WALL_THICKNESS + row * (CELL_Y + WALL_THICKNESS) + CELL_Y / 2;
                wall_x = col * (CELL_X + WALL_THICKNESS);

                // Rectangular portion
                translate([wall_x - 0.01, cell_center_y - CUTOUT_WIDTH/2, CUTOUT_BOTTOM_Z])
                cube([WALL_THICKNESS + 0.02, CUTOUT_WIDTH, RECT_CUTOUT_HEIGHT]);

                // Parabolic arch at top
                translate([wall_x - 0.01, cell_center_y, ARCH_BOTTOM_Z])
                rotate([90, 0, 90])
                linear_extrude(height = WALL_THICKNESS + 0.02)
                rounded_arch_2d();
            }
        }
    }
}

// Raised perimeter lip to prevent plate from sliding off
module lip() {
    translate([0, 0, SUPPORT_HEIGHT])
    difference() {
        cube([HOLDER_LENGTH, HOLDER_WIDTH, LIP_HEIGHT]);

        translate([LIP_THICKNESS, LIP_THICKNESS, -0.01])
        cube([
            SLAS_LENGTH + 2 * PLATE_CLEARANCE,
            SLAS_WIDTH + 2 * PLATE_CLEARANCE,
            LIP_HEIGHT + 0.02
        ]);
    }
}

// Main assembly
module raised_vented_plate_holder() {
    wall_grid_with_cutouts();
    lip();
}

// Render
raised_vented_plate_holder();
