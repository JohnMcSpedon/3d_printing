INCH = 25.4;
EPS = 0.01;

difference() {
    cube([4*INCH, 5*INCH, 1*INCH]);
    
    union() {

        color("blue") translate([1*INCH, 1*INCH, 0]) {
            cube([3*INCH, 3*INCH, 1*INCH]);
        }

        color("red") 
        translate([1*INCH, 1/4*INCH, 1*INCH])
        rotate([0 ,90,0])
        linear_extrude(height = 3*INCH, center = false) {
            // Define the triangle in the YZ plane
            polygon(points = [
                [0, 0],    // First point (Y, Z) = (0, 0)
                [0, 3/4*INCH],    // Second point (Y, Z) = (0, 1)
                [INCH, 3/4*INCH]   // Third point (Y, Z) = (3/4, 1)
            ]);
        }

        color("red") 
        translate([1*INCH, 19/4*INCH, 1*INCH])
        rotate([0 ,90,0])
        linear_extrude(height = 3*INCH, center = false) {
            // Define the triangle in the YZ plane
            polygon(points = [
                [0, 0],    // First point (Y, Z) = (0, 0)
                [0, -3/4*INCH],    // Second point (Y, Z) = (0, 1)
                [INCH, -3/4*INCH]   // Third point (Y, Z) = (3/4, 1)
            ]);
        }
    }
}