eps = 0.01;
$fn=100;

module half_snap_base() {
    color("red")
    difference() {
        square([16.5, 33], center=false);
            
        translate([16.5, 0, 0])
            polygon(points=[[0 + eps, 0 - eps], [-10, 0 - eps], [0 + eps, 27
            ]]);
            
       translate([0 - eps, 26.2, 0])
            square([13 + eps, 3.3], center=false);
    }
}

module snap_base() {
    // Create the initial shape and its mirrored copy
    linear_extrude(height=2.75)
        union() {
            // Original shape
            half_snap_base();

            // Mirrored shape
            mirror([1, 0, 0]) 
                half_snap_base();
        }
}

module button_pin() {
    color("cyan")
    translate([0, 6.875, 0])
    union() {
        cylinder(h=9.55, r=3.45);
        translate([0, 0, 6.5 + 1.525])
            button_top();
//        translate([0, 0, 6.5])
//            cylinder(h=3.05, r=5.55);
    }
}

module button_top() {
    minkowski() {
        linear_extrude(height=0.05)
            circle(4.05);
        sphere(1.5);
    };
}

module snap() {
    union() {
        snap_base();
        button_pin();
    }
}


snap();




