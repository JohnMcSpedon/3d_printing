// Variables for breadboard dimensions
bb_width = 56;      // Width in mm
bb_length = 167;    // Length in mm (+1 mm for power supply overhang)
wall_thickness = 5; // Wall thickness in mm
wall_height = 36;   // Height of walls above XY plane in mm

// Create the basic box without any holes
module basic_breadboard_box() {
    // Solid base plate at the XY plane
    translate([-wall_thickness, -wall_thickness, -wall_thickness])
        cube([bb_width + 2*wall_thickness, 
              bb_length + 2*wall_thickness, 
              wall_thickness]);
    
    // Walls extending above the XY plane
    difference() {
        // Outer walls
        translate([-wall_thickness, -wall_thickness, 0])
            cube([bb_width + 2*wall_thickness, 
                  bb_length + 2*wall_thickness, 
                  wall_height]);
        
        // Inner cutout for breadboard
        translate([0, 0, 0])
            cube([bb_width, bb_length, wall_height + 1]);
    }
}

// Create a USB-C hole (elliptical)
module usb_c_hole() {
    // Move to the width-side wall at 17mm above XY plane
    translate([bb_width/2, -wall_thickness/2, 15])
        rotate([90, 0, 0])  // Rotate to face the width side
            scale([1, 3/7, 1])  // Scale to create ellipse (14x6mm)
                cylinder(h=wall_thickness*2, r=5, center=true, $fn=100);
}

module power_supply_hole() {
    ps_hole_height = 14;
    ps_hole_width = 45;
    translate([bb_width/2 + 2, wall_thickness/2 + bb_length, 9.3 + ps_hole_height/2])
        cube([45, wall_thickness+0.01, ps_hole_height], center=true);
}

module rtd_hole() {
    rtd_hole_height = 12.5;
    rtd_hole_width = 25;
    rtd_hole_y_offset = 99;
    rtd_hole_base_height = 11;
    
    translate([-wall_thickness / 2, rtd_hole_y_offset + rtd_hole_width / 2, rtd_hole_base_height + rtd_hole_height / 2])
    cube([wall_thickness + 0.01, rtd_hole_width, rtd_hole_height], center=true);
    
}


// Final box with holes
module final_breadboard_box() {
    difference() {
        basic_breadboard_box();
        usb_c_hole();
        power_supply_hole();
        rtd_hole();
    }
    
    
}

// Call the module to render the final box
final_breadboard_box();

// color("red") rtd_hole();