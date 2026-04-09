// Tubing Port

tubing_od = 5/16 * 25.4;   // 5/16" = 7.9375mm
cyl_od = 1/2 * 25.4;       // 1/2" = 12.7mm
cyl_h = 20;

frustum_bot_side = 1 * 25.4;        // 1" = 25.4mm
frustum_top_side = 1/2 * 25.4;      // 1/2" = 12.7mm
frustum_h = 1/2 * 25.4;             // 1/2" = 12.7mm

// U-clip parameters
clip_arm_w = 1;                    // width of each arm (Y)
clip_thickness = 2.5;                  // height of arms (Z)
clip_gap = tubing_od;  // inner gap, at least 5/16" clearance
clip_length = 30;                    // total arm length (X)
clip_bridge = 5;                     // bridge width at closed end (X)
clip_y_total = clip_arm_w * 2 + clip_gap;

slot_top_z = cyl_h - 14.5;              // top of slot 14.5mm below frustum base
slot_tol = 0.3;

module u_clip() {
    // Arm 1
    translate([-clip_length/2, clip_gap/2, 0])
        cube([clip_length, clip_arm_w, clip_thickness]);
    // Arm 2
    translate([-clip_length/2, -clip_gap/2 - clip_arm_w, 0])
        cube([clip_length, clip_arm_w, clip_thickness]);
    // Bridge (closed end of U)
    translate([-clip_length/2, -clip_gap/2 - clip_arm_w, 0])
        cube([clip_bridge, clip_y_total, clip_thickness]);
}

// Main piece with slot
difference() {
    union() {
        // Cylinder
        cylinder(d=cyl_od, h=cyl_h, $fn=100);

        // Square pyramid frustum on top
        translate([0, 0, cyl_h])
            hull() {
                translate([0, 0, 0.005])
                    cube([frustum_bot_side, frustum_bot_side, 0.01], center=true);
                translate([0, 0, frustum_h - 0.005])
                    cube([frustum_top_side, frustum_top_side, 0.01], center=true);
            }
    }

    // 5/16" through hole for tubing
    translate([0, 0, -0.05])
        cylinder(d=tubing_od, h=cyl_h + frustum_h + 0.1, $fn=100);

    // Slot for U-clip
    translate([0, 0, slot_top_z - (clip_thickness + slot_tol)/2])
        cube([clip_length, clip_y_total + slot_tol, clip_thickness + slot_tol], center=true);
}

// U-clip for separate printing (shown offset to the side)
translate([40, 0, 0])
    u_clip();
