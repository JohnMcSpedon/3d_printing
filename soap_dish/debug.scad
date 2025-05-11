// Modified pyramid frustum function with epsilon adjustments
// to help prevent rendering artifacts
module create_pyramid_frustum_fixed(x1, y1, x2, y2, pyramid_height, frustum_height) {
    // Use a small epsilon value to prevent coincident faces
    eps = 0.01;
    
    // Calculate the center of the base
    center_x = (x1 + x2) / 2;
    center_y = (y1 + y2) / 2;
    
    // Calculate scale factor for the top face
    scale_factor = 1 - (frustum_height / pyramid_height);
    
    // Calculate base dimensions
    base_width = abs(x2 - x1);
    base_depth = abs(y2 - y1);
    
    // Calculate top face dimensions
    top_width = base_width * scale_factor;
    top_depth = base_depth * scale_factor;
    
    // Calculate top face corners with slightly adjusted dimensions
    // to ensure the solid is manifold
    top_x1 = center_x - (top_width / 2) + (frustum_height < 0 ? -eps : eps);
    top_y1 = center_y - (top_depth / 2) + (frustum_height < 0 ? -eps : eps);
    top_x2 = center_x + (top_width / 2) - (frustum_height < 0 ? -eps : eps);
    top_y2 = center_y + (top_depth / 2) - (frustum_height < 0 ? -eps : eps);
    
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
        [0, 1, 2, 3],  // Bottom face
        [4, 5, 6, 7],  // Top face
        [0, 4, 7, 3],  // Left face
        [1, 5, 4, 0],  // Front face
        [2, 6, 5, 1],  // Right face
        [3, 7, 6, 2]   // Back face
    ];
    
    // Create the frustum
    polyhedron(points = points, faces = faces, convexity = 10);
}

// Alternative approach using more primitive operations
module create_pyramid_frustum_centered(x1, y1, x2, y2, pyramid_height, frustum_height) {
    // Calculate dimensions
    width = abs(x2 - x1);
    depth = abs(y2 - y1);
    
    // Calculate the center of the base
    center_x = (x1 + x2) / 2;
    center_y = (y1 + y2) / 2;
    
    // Calculate scale factor 
    scale_factor = 1 - (abs(frustum_height) / abs(pyramid_height));
    
    // Translate to center, extrude with scaling centered on the base center, then translate back
    translate([center_x, center_y, 0]) {
        if (frustum_height < 0) {
            // For negative height (pointing downward)
            translate([-width/2, -depth/2, 0]) {
                linear_extrude(
                    height = abs(frustum_height),
                    scale = scale_factor,
                    center = false,
                    convexity = 10
                ) {
                    square([width, depth]);
                }
            }
        } else {
            // For positive height (pointing upward)
            translate([-width/2, -depth/2, 0]) {
                linear_extrude(
                    height = frustum_height,
                    scale = scale_factor,
                    center = false,
                    convexity = 10
                ) {
                    square([width, depth]);
                }
            }
        }
    }
}

// Debugging function to visualize components
module debug_dish(mode = 0) {
    // Constants (replace with your actual values)
    SOAP_WIDTH = 100;
    SOAP_DEPTH = 60;
    SOAP_HEIGHT = 20;
    WALL_SIZE = 5;
    EPS = 0.01;
    
    if (mode == 0) {
        // Display the complete model
        difference() {
            translate([-WALL_SIZE, -WALL_SIZE, -WALL_SIZE]) {
                color("blue", 0.5)  // Semi-transparent blue
                cube([SOAP_WIDTH+2*WALL_SIZE, SOAP_DEPTH+2*WALL_SIZE, SOAP_HEIGHT+WALL_SIZE]);
            };
            translate([0, 0, SOAP_HEIGHT+EPS]) {
                color("red", 0.5)  // Semi-transparent red
                create_pyramid_frustum_centered(0, 0, SOAP_WIDTH, SOAP_DEPTH, -150, -SOAP_HEIGHT - 2*EPS - WALL_SIZE);
            };
        };
    } else if (mode == 1) {
        // Display only the outer cube
        translate([-WALL_SIZE, -WALL_SIZE, -WALL_SIZE]) {
            color("blue", 0.5)
            cube([SOAP_WIDTH+2*WALL_SIZE, SOAP_DEPTH+2*WALL_SIZE, SOAP_HEIGHT+WALL_SIZE]);
        };
    } else if (mode == 2) {
        // Display only the frustum
        translate([0, 0, SOAP_HEIGHT+EPS]) {
            color("red", 0.5)
            create_pyramid_frustum_centered(0, 0, SOAP_WIDTH, SOAP_DEPTH, -150, -SOAP_HEIGHT - 2*EPS - WALL_SIZE);
        };
    } else if (mode == 3) {
        // Display both but without performing the difference
        translate([-WALL_SIZE, -WALL_SIZE, -WALL_SIZE]) {
            color("blue", 0.2)  // Very transparent blue
            cube([SOAP_WIDTH+2*WALL_SIZE, SOAP_DEPTH+2*WALL_SIZE, SOAP_HEIGHT+WALL_SIZE]);
        };
        translate([0, 0, SOAP_HEIGHT+EPS]) {
            color("red", 0.5)
            create_pyramid_frustum_centered(0, 0, SOAP_WIDTH, SOAP_DEPTH, -150, -SOAP_HEIGHT - 2*EPS - WALL_SIZE);
        };
    }
}

// Use this to test different debugging modes
 debug_dish(0);  // Full model
// debug_dish(1);  // Just the cube
s debug_dish(2);  // Just the frustum
// debug_dish(3);  // Both objects without difference operation