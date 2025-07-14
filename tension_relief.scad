num_teeth = 20;
tooth_depth = 1;  // How deep the teeth cut into the circle
tooth_width_angle = 30; // Angular width of each tooth in degrees

// Main dimensions
width = 22;    // X dimension
depth = 9;   // Y dimension  
height = 28;   // Z dimension
hole_diameter = 15;


difference() {
    // Main cube
    cube([width, depth, height], center=true);
    
    // Cylinder hole with gear teeth
    rotate([90, 0, 0]) {
        // Main cylinder hole
        cylinder(h=depth + 1, d=hole_diameter, center=true, $fn=50);
        
        // Add teeth cutting into the cylinder
        for(i = [0:num_teeth-1]) {
            rotate([0, 0, i * 360/num_teeth])
                translate([hole_diameter/2 - tooth_depth/2, 0, 0])
                    cube([tooth_depth, tooth_width_angle * hole_diameter * 3.14159 / 360, depth + 1], center=true);
        }
    }
    
    // Horizontal slot - 2mm tall cube through the center
    // This creates a slot through the entire width and depth
    cube([width + 1, depth + 1, 10], center=true);
}