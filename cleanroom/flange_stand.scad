// Flange Stand

base_d = 25;
base_h = 5;

shaft_d = 12.5;
shaft_h = 70;

hole_d = 4;
hole_depth = 15;

difference() {
    union() {
        // Base
        cylinder(d=base_d, h=base_h, $fn=100);

        // Shaft
        translate([0, 0, base_h])
            cylinder(d=shaft_d, h=shaft_h, $fn=100);
    }

    // Top hole
    translate([0, 0, base_h + shaft_h - hole_depth])
        cylinder(d=hole_d, h=hole_depth + 0.1, $fn=100);
}
