module cross_hatch_grid(width, height, depth, cell_size, line_thickness, angle=45) {
    // Calculate the diagonal length of the bounding rectangle
    // This ensures our rotated grid covers the entire rectangle
    diagonal = sqrt(pow(width, 2) + pow(height, 2));
    
    difference() {
        // Outer boundary cube
        translate([0, 0, -0.01])
            cube([width, height, depth + 0.02]);
        
        // Rotated grid
        translate([width/2, height/2, -0.5])
        rotate([0, 0, angle]) 
        translate([-diagonal/2, -diagonal/2, 0])
        {
            // Create the grid pattern by subtracting cells from a solid block
            difference() {
                // Solid block covering the entire area
                cube([diagonal, diagonal, depth + 1]);
                
                // Create a grid of cells to subtract
                for (x = [0 : cell_size + line_thickness : diagonal]) {
                    for (y = [0 : cell_size + line_thickness : diagonal]) {
                        translate([x, y, -0.5])
                            cube([cell_size, cell_size, depth + 2]);
                    }
                }
            }
        }
    }
}