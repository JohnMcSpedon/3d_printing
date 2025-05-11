include <soap_dish_pyramid_frustrum.scad>

module flat_back_frustrum(base_width, base_depth, height, base_degrees) {
    // Calculate the upper overhang based on the angle
    upper_overhang = height / tan(90-base_degrees);
    
    polyhedron(
        points=[
            [0, 0, 0],               // Bottom front left
            [base_width, 0, 0],      // Bottom front right
            [base_width, base_depth, 0], // Bottom back right
            [0, base_depth, 0],      // Bottom back left
            
            // Front and sides have overhang, back is vertical
            [0 - upper_overhang, 0, height],  // Top front left
            [base_width + upper_overhang, 0, height], // Top front right
            [base_width + upper_overhang, base_depth + upper_overhang, height], // Top back right (vertical back)
            [0 - upper_overhang, base_depth + upper_overhang, height],  // Top back left (vertical back)
        ],
        faces = [
            [0, 1, 2, 3],     // Bottom face (counterclockwise)
            [7, 6, 5, 4],     // Top face (clockwise from bottom view)
            [0, 4, 5, 1],     // Front face (sloped)
            [1, 5, 6, 2],     // Right face (sloped)
            [2, 6, 7, 3],     // Back face (vertical)
            [3, 7, 4, 0],     // Left face (sloped)
        ]
    );
}

SOAP_WIDTH = 110 * 0.9; // to account for dropping into outer shell
SOAP_DEPTH = 65 * 0.9;
SOAP_HEIGHT = 25;

EPS = 0.01;
OVERHANG_HEIGHT=40;
OVERHANG_BITE=10;
BACK_OVERHANG_HEIGHT = 40;

$fn = 200;


//difference() {
//flat_back_frustrum(SOAP_WIDTH, SOAP_DEPTH, SOAP_HEIGHT, 50);
//color("blue") translate([WALL_SIZE, WALL_SIZE, WALL_SIZE]) {
//    flat_back_frustrum(SOAP_WIDTH - 2*WALL_SIZE, SOAP_DEPTH - 2*WALL_SIZE, SOAP_HEIGHT, 50);
//};
//}


module sine_wave_surface(base_width, base_depth, height, b, resolution = 40) {
    // base_width: width of rectangular region in x-axis
    // base_depth: depth of rectangular region in y-axis  
    // height: maximum height (for scaling amplitude)
    // a: amplitude factor
    // b: period of the sine wave
    // resolution: controls surface smoothness
    
    dx = base_width / resolution;
    dy = base_depth / resolution;
    
    // Create a grid of cubes with heights determined by sine wave
    for (i = [0:resolution-1]) {
        for (j = [0:resolution-1]) {
            x = i * dx;
            y = j * dy;
            
            // Calculate height using sine wave formula
            // sin(x) * sin(y) creates a 3D wave pattern
            wave_height = height * sin(360 * x / b) * sin(360 * y / b);
            
            // Ensure height is positive (z>=0)
            actual_height = max(0.01, wave_height);
            
            // Create a small cube at each grid point
            translate([x, y, 0])
                cube([dx, dy, actual_height]);
        }
    }
}

module holes_at_sine_wave_minima(width, depth, b) {
    // width: width of rectangular region in x-axis (SOAP_WIDTH)
    // depth: depth of rectangular region in y-axis (SOAP_DEPTH)
    // height: maximum height (for scaling amplitude)
    // b: period of the sine wave (25 in your case)
    
    // For a sine wave with period b:
    // - Minima occur at 3/4 * b + n*b, where n is an integer
    // - For sin(360° * x / b), minima are at x = (3/4 + n) * b
    
    // First minimum position (at 3/4 of the period)
    first_min_x = 0.25*b;
    first_min_y = 0.75*b;
    
    // Calculate how many minima can fit within the width and depth
    num_x_minima = floor((width - first_min_x) / b) + 1;
    num_y_minima = floor((depth - first_min_y) / b) + 1;
    
    // Loop through all possible minima positions
    for (i = [0:num_x_minima]) {
        for (j = [0:num_y_minima]) {
            // Calculate x and y coordinates
            x = first_min_x + i * b;
            y = first_min_y + j * b;
            
            // Only consider points within the boundaries
            if (x <= width && y <= depth) {                
                // Mark the minimum point (e.g., with a sphere)
                translate([x, y, -11])
                    cylinder(12, 2.5, 5, center=true);
                }
                echo (x, y);
        }
    }
}

difference() {
    union() {
        sine_wave_surface(SOAP_WIDTH, SOAP_DEPTH, 7, 25, 200);
        create_pyramid_frustum(0, 0, SOAP_WIDTH, SOAP_DEPTH, -150, -10);

//        translate([0,0,-10]){
//            cube([SOAP_WIDTH, SOAP_DEPTH, 10]);
//        }
    }
//    // row 1
    translate([18.75, 6.25, -5.5]){
        cylinder(12, 2.5, 5, center=true);
    }
    translate([43.75, 6.25, -5.5]){
        cylinder(12, 2.5, 5, center=true);
    }
    translate([68.75, 6.25, -5.5]){
        cylinder(12, 2.5, 5, center=true);
    }
    translate([93.75, 6.25, -5.5]){
        cylinder(12, 2.5, 5, center=true);
    }
    // row 2
    translate([6.25, 18.75, -5.5]){
        cylinder(12, 2.5, 5, center=true);
    }
    translate([31.25, 18.75, -5.5]){
        cylinder(12, 2.5, 5, center=true);
    }
    translate([56.25, 18.75, -5.5]){
        cylinder(12, 2.5, 5, center=true);
    }
    translate([81.25, 18.75, -5.5]){
        cylinder(12, 2.5, 5, center=true);
    }
//    // row 3
    translate([18.75, 31.25, -5.5]){
        cylinder(12, 2.5, 5, center=true);
    }
    translate([43.75, 31.25, -5.5]){
        cylinder(12, 2.5, 5, center=true);
    }
    translate([68.75, 31.25, -5.5]){
        cylinder(12, 2.5, 5, center=true);
    }
    translate([93.75, 31.25, -5.5]){
        cylinder(12, 2.5, 5, center=true);
    }
//    // row 4
    translate([6.25, 43.75, -5.5]){
        cylinder(12, 2.5, 5, center=true);
    }
    translate([31.25, 43.75, -5.5]){
        cylinder(12, 2.5, 5, center=true);
    }
    translate([56.25, 43.75, -5.5]){
        cylinder(12, 2.5, 5, center=true);
    }
    translate([81.25, 43.75, -5.5]){
        cylinder(12, 2.5, 5, center=true);
    }
//    // row 5
    translate([18.75, 56.25, -5.5]){
        cylinder(12, 2.5, 5, center=true);
    }
    translate([43.75, 56.25, -5.5]){
        cylinder(12, 2.5, 5, center=true);
    }
    translate([68.75, 56.25, -5.5]){
        cylinder(12, 2.5, 5, center=true);
    }
    translate([93.75, 56.25, -5.5]){
        cylinder(12, 2.5, 5, center=true);
    }
//    translate([0, 0, EPS]) {
//    holes_at_sine_wave_minima(SOAP_WIDTH, SOAP_DEPTH, 25);
//    }
}
