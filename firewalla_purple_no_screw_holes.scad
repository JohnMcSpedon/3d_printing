module debug_cube(pos) {
    color("red")
        translate(pos)
            cube(2, center=true);  // 2mm cube, centered at the point
}

module subtract_screw(pos) {
    translate(pos) {
        // Through-hole cylinder (4.2mm diameter)
        cylinder(h=100, d=4.5, center=false);
        
        // Larger counterbore cylinder starting at z=2mm
        translate([0, 0, 2])
            cylinder(h=100, d=11.5, center=false);
    }
}

// Array of coordinates to mark
coordinates = [
    [-28, 16, 0],  // First point
    [-28, -44, 0],      // Second point (replace with your coordinates)
    [56, 16, 0],    // Third point (replace with your coordinates)
    [56, -44, 0]    // Fourth point (replace with your coordinates)
];

// Your main model
// import("/Users/john/personal_code/3d_printing/firewalla_mount_thingverse_8EBBp3SY5TA.stl");
//
// Draw debug cubes at all coordinates
// for (pos = coordinates) {
//    debug_cube(pos);
//     subtract_screw(pos);
// }

difference() {
    // Your main model
    import("/Users/john/personal_code/3d_printing/firewalla_mount_thingverse_8EBBp3SY5TA.stl");
    
    // Create all screw holes
    for (pos = coordinates) {
        subtract_screw(pos);
    }
}
