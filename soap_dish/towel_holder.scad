//include <soap_dish_pyramid_frustrum.scad>

TOWEL_HANGER_WIDTH = 20;
SOAP_HEIGHT = 10;

GLASS_WIDTH = 5;
WALL_SIZE = 6;
EPS = 0.01;
OVERHANG_HEIGHT=40;
OVERHANG_BITE=7;
BACK_OVERHANG_HEIGHT = 40;

$fn=250;


module hook_frustrum_not_done() {
    // Define all points of the frustum
    points = [
        // Bottom face (base) vertices
        [x1, y1, 0],          // 0: Bottom-left
        [x2, y1, 0],          // 1: Bottom-right
        [x2, y2, 0],          // 2: Top-right
        [x1, y2, 0],          // 3: Top-left
        
        // Top face vertices
        [top_x1, top_y1, frustum_height],  // 4: Bottom-left
        [top_x2, top_y1, frustum_height],  // 5: Bottom-right
        [top_x2, top_y2, frustum_height],  // 6: Top-right
        [top_x1, top_y2, frustum_height]   // 7: Top-left
    ];
    
    // Define the faces of the frustum
    faces = [
        [0, 3, 2, 1],  // Bottom face
        [4, 5, 6, 7],  // Top face
        [0, 4, 7, 3],  // Left face
        [1, 5, 4, 0],  // Front face
        [2, 6, 5, 1],  // Right face
        [3, 7, 6, 2]   // Back face
    ];
    
    // Create the frustum
    polyhedron(points = points, faces = faces, convexity = 2);
}

module hook_pyramid(base_depth, base_width, base_height) {
    // Define all points of the frustum
    points = [
        // base vertices
        [0, base_depth, 0],          // 0: Bottom-left
        [base_width, base_depth, 0], // 1: Bottom-right
        [base_width, base_depth/2, base_height],          // 2: Top-right
        [0, base_depth/2, base_height],          // 3: Top-left
        
        // Top face vertex
        [base_width/2, 3*base_depth, 3*base_height],  // 4: apex

    ];
    
    // Define the faces of the frustum
    faces = [
        [0, 3, 2, 1],  // Bottom face
        [4, 2, 3],
        [4, 1, 2],
        [4, 0, 1],
        [4, 3, 0],
    ];
    
    // Create the frustum
    polyhedron(points = points, faces = faces, convexity = 2);
}

module hanger() {

    // wall above back of soap dish
    translate([0, -WALL_SIZE, 0]) {
        cube([TOWEL_HANGER_WIDTH, WALL_SIZE, SOAP_HEIGHT + OVERHANG_HEIGHT]);
    }

    // roof of overhang
    translate([0, -2*WALL_SIZE - GLASS_WIDTH - OVERHANG_BITE, SOAP_HEIGHT + OVERHANG_HEIGHT]) {
        cube([TOWEL_HANGER_WIDTH, GLASS_WIDTH + 2*WALL_SIZE + OVERHANG_BITE, WALL_SIZE]);
    };

    // wall on opposite side of glass
    translate([0, -2*WALL_SIZE - GLASS_WIDTH - OVERHANG_BITE, SOAP_HEIGHT + OVERHANG_HEIGHT - BACK_OVERHANG_HEIGHT]) {
        cube([TOWEL_HANGER_WIDTH, WALL_SIZE, BACK_OVERHANG_HEIGHT]);
    };

    // section against glass
    translate([0, -WALL_SIZE - GLASS_WIDTH - OVERHANG_BITE, SOAP_HEIGHT + OVERHANG_HEIGHT - BACK_OVERHANG_HEIGHT]) {
        cube([TOWEL_HANGER_WIDTH, OVERHANG_BITE, 2*WALL_SIZE]);
    }
}


radius = 0.6;

union() {
    hanger();
    cube([TOWEL_HANGER_WIDTH, 5, 12]);
    translate([radius, 0, radius]){
        minkowski() {
            hook_pyramid(
                base_depth = 5,
                base_width = TOWEL_HANGER_WIDTH - 2*radius,
                base_height = 12 - 2*radius
            );
            sphere(radius);
        }
    }
}

    
