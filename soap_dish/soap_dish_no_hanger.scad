//include <soap_holder.scad>



SOAP_WIDTH = 110;
SOAP_DEPTH = 65;
SOAP_HEIGHT = 25;

GLASS_WIDTH = 5;
WALL_SIZE = 6;
EPS = 0.01;
OVERHANG_HEIGHT=40;
OVERHANG_BITE=10;
BACK_OVERHANG_HEIGHT = 40;

// soap
//color("white") cube([SOAP_WIDTH, SOAP_DEPTH, SOAP_HEIGHT]);


// color("blue")  cube([SOAP_WIDTH, SOAP_DEPTH, SOAP_HEIGHT+EPS]);

UPPER_OVERHANG = SOAP_HEIGHT * tan(360 * PI / 2);

module flat_back_frustrum(wall_size) {

    polyhedron(
        points=[
            [-wall_size, -wall_size, -wall_size],
            [SOAP_WIDTH + wall_size, -wall_size, -wall_size],
            [SOAP_WIDTH + wall_size, SOAP_DEPTH + wall_size, -wall_size],
            [-wall_size, SOAP_DEPTH + wall_size, -wall_size],
            [- wall_size, -wall_size, SOAP_HEIGHT + wall_size],
            [SOAP_WIDTH + wall_size, -wall_size, SOAP_HEIGHT + wall_size],
            [SOAP_WIDTH + wall_size, SOAP_DEPTH + wall_size, SOAP_HEIGHT + wall_size],
            [0 - wall_size, SOAP_DEPTH + wall_size, SOAP_HEIGHT+wall_size ],
        ],
        faces = [
            [0, 1, 2, 3],     // Bottom face (counterclockwise)
            [7, 6, 5, 4],     // Top face (clockwise from bottom view)
            [0, 4, 5, 1],     // Front face
            [1, 5, 6, 2],     // Right face
            [2, 6, 7, 3],     // Back face
            [3, 7, 4, 0],     // Left face
        ]
    );
}


module bottom_dish_frustrum() {
difference() {
    flat_back_frustrum(WALL_SIZE);
    flat_back_frustrum(2);
    }
};



// flat_back_frustrum(3);

// bottom_dish_frustrum();



//hanger();
//difference(){
//bottom_dish_frustrum();
//color("white") cube([SOAP_WIDTH, SOAP_DEPTH, SOAP_HEIGHT]);
//}