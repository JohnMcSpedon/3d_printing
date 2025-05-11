WIDTH = 52;
HEIGHT = 120;
FILET = 5.5;
THICKNESS = 8.5;

SLOT_HEIGHT=9;
SLOT_WIDTH=13;

module roundedCube() {
    translate([FILET, FILET, 0])
    // Create a rounded rectangle of overall dimensions WIDTH x HEIGHT
    minkowski() {
        // The inner rectangle is reduced by 2*fillet in each dimension.
        square([WIDTH - 2*FILET, HEIGHT - 2*FILET]);
        // The circle adds the rounded corners.
        circle(r = FILET);
    }
}



difference() {
    //cube([WIDTH, HEIGHT, 9.5]);
    
    linear_extrude(height = THICKNESS)
        roundedCube();
    
    for(x = [10, WIDTH - 10]) {
        for(y = [8.5, HEIGHT - 8.5]) {
            translate([x, y, -1]) {
                cylinder(h = 12, r=6.5/2, center=True);
            }
        }
    }
    
    translate([(WIDTH- SLOT_WIDTH)/2, 20.0, -0.1]) {
        cube([SLOT_WIDTH, SLOT_HEIGHT, THICKNESS + 1]);
    }
}