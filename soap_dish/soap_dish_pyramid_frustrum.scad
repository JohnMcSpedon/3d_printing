// Function to create a pyramid from two base corners and a height
// Parameters:
// - x1, y1: Coordinates of the first corner of the base
// - x2, y2: Coordinates of the second corner of the base
// - height: Height of the pyramid
module create_pyramid(x1, y1, x2, y2, height) {
    // Calculate the center of the base
    center_x = (x1 + x2) / 2;
    center_y = (y1 + y2) / 2;
    
    // Define the four corners of the base (assuming a rectangle)
    base_points = [
        [x1, y1, 0],  // Bottom-left
        [x2, y1, 0],  // Bottom-right
        [x2, y2, 0],  // Top-right
        [x1, y2, 0]   // Top-left
    ];
    
    // Define the apex point (centered above the base)
    apex = [center_x, center_y, height];
    
    // Create the faces of the pyramid using polyhedron
    polyhedron(
        points = concat(base_points, [apex]),
        faces = [
            [0, 3, 2, 1],  // Base (rectangle)
            [0, 1, 4],      // Side face 1
            [1, 2, 4],      // Side face 2
            [2, 3, 4],      // Side face 3
            [3, 0, 4]       // Side face 4
        ]
    );
}

// Function to create a pyramid frustum from two base corners and heights
// Parameters:
// - x1, y1: Coordinates of the first corner of the base
// - x2, y2: Coordinates of the second corner of the base
// - pyramid_height: Total height of the complete pyramid
// - frustum_height: Height where the pyramid is cut to create the frustum
module create_pyramid_frustum(x1, y1, x2, y2, pyramid_height, frustum_height) {
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
    
    // Calculate top face corners
    top_x1 = center_x - (top_width / 2);
    top_y1 = center_y - (top_depth / 2);
    top_x2 = center_x + (top_width / 2);
    top_y2 = center_y + (top_depth / 2);
    
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

// Example usage:
//create_pyramid_frustum(-10, -10, 10, 10, -20, -15);

// Example usage:
//create_pyramid(-50, -40, 10, 10, -15);