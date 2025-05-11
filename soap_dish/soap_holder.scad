include <soap_dish_pyramid_frustrum.scad>

SOAP_WIDTH = 110;
SOAP_DEPTH = 65;
SOAP_HEIGHT = 25;

GLASS_WIDTH = 5;
WALL_SIZE = 6;
EPS = 0.01;
OVERHANG_HEIGHT=40;
OVERHANG_BITE=10;
BACK_OVERHANG_HEIGHT = 40;

// soap dish
//color("white") cube([SOAP_WIDTH, SOAP_DEPTH, SOAP_HEIGHT]);


// bottom soap dish
module basic_dish() {
difference() {
    translate([-WALL_SIZE, -WALL_SIZE, -WALL_SIZE]) {
        cube([SOAP_WIDTH+2*WALL_SIZE, SOAP_DEPTH+2*
        WALL_SIZE, SOAP_HEIGHT+WALL_SIZE]);
    };
//    translate([0, 0, SOAP_HEIGHT + EPS]) {
//        create_pyramid_frustum(0, 0, SOAP_WIDTH, SOAP_DEPTH, -150, -SOAP_HEIGHT - 2*EPS - WALL_SIZE);
//    };
    translate([0, 0, SOAP_HEIGHT + EPS]) {
        create_pyramid(0, 0, SOAP_WIDTH, SOAP_DEPTH, -150);
    };
//    cube([SOAP_WIDTH, SOAP_DEPTH, SOAP_HEIGHT+EPS]);
};
}

module hanger() {

    // wall above back of soap dish
    translate([-WALL_SIZE, -WALL_SIZE, 0])
    cube([SOAP_WIDTH + 2*WALL_SIZE, WALL_SIZE, SOAP_HEIGHT + OVERHANG_HEIGHT]);

    // roof of overhang
    translate([-WALL_SIZE, -2*WALL_SIZE - GLASS_WIDTH - OVERHANG_BITE, SOAP_HEIGHT + OVERHANG_HEIGHT]) {
        cube([SOAP_WIDTH + 2*WALL_SIZE, GLASS_WIDTH + 2*WALL_SIZE + OVERHANG_BITE, WALL_SIZE]);
    };

    // wall on opposite side of glass
    translate([-WALL_SIZE, -2*WALL_SIZE - GLASS_WIDTH - OVERHANG_BITE, SOAP_HEIGHT + OVERHANG_HEIGHT - BACK_OVERHANG_HEIGHT]) {
        cube([SOAP_WIDTH + 2*WALL_SIZE, WALL_SIZE, BACK_OVERHANG_HEIGHT]);
    };

    // section against glass
    translate([-WALL_SIZE, -WALL_SIZE - GLASS_WIDTH - OVERHANG_BITE, SOAP_HEIGHT + OVERHANG_HEIGHT - BACK_OVERHANG_HEIGHT]) {
        cube([SOAP_WIDTH + 2*WALL_SIZE, OVERHANG_BITE, 2*WALL_SIZE]);
    }
}

union() {
    basic_dish();
    hanger();
}

//  color("blue")  translate([0, 0, SOAP_HEIGHT + EPS]) {
//        create_pyramid(0, 0, SOAP_WIDTH, SOAP_DEPTH, -150);
//    };

//translate([0, 0, SOAP_HEIGHT+EPS]) {
//        create_pyramid_frustum(0, 0, SOAP_WIDTH, SOAP_DEPTH, -150, -SOAP_HEIGHT - 2*EPS - WALL_SIZE);
//}