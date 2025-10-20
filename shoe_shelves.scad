BOARD_HEIGHT = 2.9;
BOARD_DEPTH = 136.5;
INCUT_WIDTH = 10;


DEPTH_BUFFER = 5;
HEIGHT_LOWER_BUFFER = 4;
HEIGHT_UPPER_BUFFER = 4;

TOP_WIDTH = 25;

TOTAL_HEIGHT = 170;
FOOT_DEPTH = 10;
LEG_WIDTH = 6;
FOOT_WIDTH = 35;
FOOT_HEIGHT = 3;
FOOT_TRIANGLE_SIDE = 5;

TOTAL_TOP_HEIGHT = BOARD_HEIGHT + HEIGHT_LOWER_BUFFER + HEIGHT_UPPER_BUFFER;
TOTAL_TOP_DEPTH = BOARD_DEPTH + 2*DEPTH_BUFFER;

LEG_HEIGHT = TOTAL_HEIGHT - BOARD_HEIGHT - HEIGHT_LOWER_BUFFER - HEIGHT_UPPER_BUFFER;

module top_section() {
    difference() {
        cube([TOP_WIDTH, TOTAL_TOP_DEPTH, TOTAL_TOP_HEIGHT]);
        translate([0, DEPTH_BUFFER, HEIGHT_LOWER_BUFFER]) {
            cube([INCUT_WIDTH, BOARD_DEPTH, BOARD_HEIGHT]);
        }
    }
}

module foot(depth_offset) {
    foot_width = FOOT_WIDTH - LEG_WIDTH;
    translate([TOP_WIDTH - LEG_WIDTH, depth_offset, -LEG_HEIGHT]) {
        union() {
            cube([LEG_WIDTH, FOOT_DEPTH, LEG_HEIGHT]);
            translate([-foot_width, 0, 0]) {
                cube([foot_width, FOOT_DEPTH, FOOT_HEIGHT]);
            }
            translate([0, FOOT_DEPTH, FOOT_HEIGHT]) {
                rotate([90, 0, 0]) {
                    linear_extrude(height=FOOT_DEPTH) {
                        polygon([[0, 0], [-foot_width, 0], [0,FOOT_TRIANGLE_SIDE]]);
                    }
                }
            }
            
            translate([0, FOOT_DEPTH, TOTAL_HEIGHT-TOTAL_TOP_HEIGHT]) {
                rotate([90, 0, 0]) {
                    linear_extrude(height=FOOT_DEPTH) {
                        polygon([[0, 0], [-(TOP_WIDTH - LEG_WIDTH), 0], [0,-10]]);
                    }
                }
            }
        }
    }
}

module screw_mount(depth_offset) {
    mount_depth = 20;
    translate([TOP_WIDTH - LEG_WIDTH, depth_offset, -mount_depth]) {
        union() {
            difference() {
                cube([LEG_WIDTH, FOOT_DEPTH, mount_depth]);
                translate([0, FOOT_DEPTH/2, 5]) rotate([0, 90, 0]) cylinder(h=20, r=2, center=false, $fn=100);
            }
            translate([0, FOOT_DEPTH, mount_depth]) {
                rotate([90, 0, 0]) {
                    linear_extrude(height=FOOT_DEPTH) {
                        polygon([[0, 0], [-(TOP_WIDTH - LEG_WIDTH), 0], [0,-10]]);
                    }
                }
            }
        }
    }
}

module connector_female() {
    connector_depth = 15;
    incut_depth = 10;
    color("pink") {
        translate([0, -connector_depth, 0]) {
            difference() {
                cube([TOP_WIDTH, connector_depth, TOTAL_TOP_HEIGHT]);
                linear_extrude(height=TOTAL_TOP_HEIGHT / 2) {
                    polygon([
                        [.3*TOP_WIDTH, 0],
                        [.2*TOP_WIDTH, incut_depth],
                        [(1-.2)*TOP_WIDTH, incut_depth],
                        [(1-.3)*TOP_WIDTH, 0]
                    ]);
                }
            }
        }
    }
}

module connector_male() {
    connector_depth = 15;
    incut_depth = 10;
    color("blue") {
        translate([0, TOTAL_TOP_DEPTH, 0]) {
            linear_extrude(height=TOTAL_TOP_HEIGHT / 2) {
                polygon([
                    [.3*TOP_WIDTH+.1, 0],
                    [.2*TOP_WIDTH+.1, incut_depth-.1],
                    [(1-.2)*TOP_WIDTH-.1, incut_depth-.1],
                    [(1-.3)*TOP_WIDTH-.1, 0]
                ]);
            }
        }
    }
}


module struts(shallow_foot, deep_foot, strut_width) {
    inner_depth = shallow_foot + FOOT_DEPTH;
    outer_depth = deep_foot;
    
    min_height = -LEG_HEIGHT;
    max_height = 0;
    
    first_strut_points = [
        // First diagonal (bottom-left to top-right)
        [min_height, inner_depth],
        [min_height+ strut_width, inner_depth],
        [max_height, outer_depth],
        [max_height-strut_width, outer_depth],
    ];
    
    second_strut_points = [
        [min_height, outer_depth],
        [min_height+ strut_width, outer_depth],
        [max_height, inner_depth],
        [max_height-strut_width, inner_depth],
    ];
    
    // Create the X shape by rotating and extruding
    translate([TOP_WIDTH - LEG_WIDTH, 0, -LEG_HEIGHT]) {
        rotate([0, 90, 0]) {
            linear_extrude(height = LEG_WIDTH) {
                // First diagonal
                polygon(first_strut_points);
                polygon(second_strut_points);
            }
        }
    }
}        
    


// make LEFT
//mirror([1, 0, 0]) {
//
//    // MALE RIGHT
////    top_section();
////    foot(TOTAL_TOP_DEPTH*2/3);
////    foot(0);
////    struts(0, TOTAL_TOP_DEPTH*2/3, 20);
////    connector_male();
//
//
//    // FEMALE RIGHT
//    top_section();
//    foot(TOTAL_TOP_DEPTH*1/3 -FOOT_DEPTH);
//    foot(TOTAL_TOP_DEPTH-FOOT_DEPTH);
//    struts(TOTAL_TOP_DEPTH*1/3 -FOOT_DEPTH, TOTAL_TOP_DEPTH-FOOT_DEPTH, 20);
//    connector_female();
//
//}


// make LEFT
mirror([1, 0, 0]) {

    // MALE RIGHT
    top_section();
    screw_mount(TOTAL_TOP_DEPTH*2/3);
    screw_mount(0);
    connector_male();


    // FEMALE RIGHT
//    top_section();
//    screw_mount(TOTAL_TOP_DEPTH*1/3 -FOOT_DEPTH);
//    screw_mount(TOTAL_TOP_DEPTH-FOOT_DEPTH);
//    connector_female();

}