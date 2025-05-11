include <dimensions.scad>

SHELF_1_HEIGHT = 3 * INCHES_TO_MM;
SHELF_2_HEIGHT = 2.5 * INCHES_TO_MM;
SHELF_3_HEIGHT = 2.5 * INCHES_TO_MM;
WALL_WIDTH = 15;
WALL_THICKNESS = 6;

// Create a 2D shape with cutouts using difference() in 2D
module side_panel_2d() {
    total_height = SHELF_1_HEIGHT + SHELF_2_HEIGHT + SHELF_3_HEIGHT;
    
    wall_inner_left = WALL_WIDTH;
    wall_inner_right = SHELF_DEPTH - WALL_WIDTH;
    
    cutout_0_bottom = 0;
    cutout_0_top = cutout_0_bottom + 2*INCHES_TO_MM;
    
    cutout_1_bottom = SHELF_1_HEIGHT - SHELF_THICKNESS;
    cutout_1_top = cutout_1_bottom + 1.75 * INCHES_TO_MM;
    
    cutout_2_bottom = SHELF_1_HEIGHT + SHELF_2_HEIGHT - SHELF_THICKNESS;
    cutout_2_top = cutout_2_bottom + 1.75 * INCHES_TO_MM;
    
    cutout_3_bottom = SHELF_1_HEIGHT + SHELF_2_HEIGHT + SHELF_3_HEIGHT - SHELF_THICKNESS;
    cutout_3_top = total_height;


    difference() {
        // Outer shape - could be a polygon or other 2D shape
        polygon(points=[[0,0], [SHELF_DEPTH,0], [SHELF_DEPTH, total_height], [0, total_height]]);
        polygon(points=[[30, cutout_0_bottom], [SHELF_DEPTH - 30, cutout_0_bottom], [SHELF_DEPTH - 35, cutout_0_top], [35, cutout_0_top]]);
        polygon(points=[[wall_inner_left + 2, cutout_1_bottom], [wall_inner_right - 2, cutout_1_bottom], [wall_inner_right, cutout_1_top], [wall_inner_left, cutout_1_top]]);
        polygon(points=[[wall_inner_left + 2, cutout_2_bottom], [wall_inner_right - 2, cutout_2_bottom], [wall_inner_right, cutout_2_top], [wall_inner_left, cutout_2_top]]);
        polygon(points=[[wall_inner_left + 2, cutout_3_bottom], [wall_inner_right - 2, cutout_3_bottom], [wall_inner_right - 2, cutout_3_top], [wall_inner_left + 2, cutout_3_top]]);
    }
}

// Then extrude the 2D shape to get your 3D object
module side_panel_3d() {
    linear_extrude(height=WALL_THICKNESS) side_panel_2d();
}

// Display the 3D side panel
side_panel_3d();

// color("red") translate([WALL_WIDTH + 3, SHELF_1_HEIGHT - SHELF_THICKNESS, -10]) cube([SHELF_DEPTH - 2*WALL_WIDTH - 2*3, SHELF_THICKNESS, 20]);
// color("blue") translate([WALL_WIDTH + 3, SHELF_1_HEIGHT + SHELF_2_HEIGHT - SHELF_THICKNESS, -10]) cube([SHELF_DEPTH - 2*WALL_WIDTH - 2*3, SHELF_THICKNESS, 20]); 
// color("green") translate([WALL_WIDTH + 3, SHELF_1_HEIGHT + SHELF_2_HEIGHT + SHELF_3_HEIGHT - SHELF_THICKNESS, -10]) cube([SHELF_DEPTH - 2*WALL_WIDTH - 2*3, SHELF_THICKNESS, 20]); 