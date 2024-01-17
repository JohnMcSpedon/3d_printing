eps = 0.01;
$fn=100;

base_sphere_radius = .9;
button_top_sphere_radius = 1.2;


module half_snap_base() {
    color("red")
    difference() {
        square([16.5, 33], center=false);
            
        translate([16.5, 0, 0])
            polygon(points=[[0 + eps, 0 - eps], [-10, 0 - eps], [0 + eps, 25]]);
            
       translate([0 - eps, 26, 0])
            square([13 + eps + base_sphere_radius, 3.3 + base_sphere_radius], center=false);
    }
}

module snap_base() {
    // Create the initial shape and its mirrored copy
    translate([0, 0, base_sphere_radius])
    minkowski() {
        linear_extrude(height=2.75 - 2 * base_sphere_radius)
            union() {
                // Original shape
                half_snap_base();

                // Mirrored shape
                mirror([1, 0, 0])
                    half_snap_base();
            }
        sphere(base_sphere_radius);
    }
}

module button_pin() {
    color("cyan")
    translate([0, 6.875, 0])
    union() {
        cylinder(h=9.55, r=6.9/2);
        translate([0, 0, 6.5])
            button_top();
    }
}

module button_top() {
    translate([0, 0, button_top_sphere_radius])
    minkowski() {
        linear_extrude(height=3.05 - 2 * button_top_sphere_radius)
            circle(11.1 / 2 - button_top_sphere_radius);
        sphere(button_top_sphere_radius);
    };
}

module snap() {
    union() {
        snap_base();
        button_pin();
    }
}

snap();
