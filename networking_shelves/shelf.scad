include <dimensions.scad>
include <crosshatch.scad>

SHELF_WIDTH = 8.5 * INCHES_TO_MM;
INCUT_DEPTH = 150.85;


module shelf_2d() {
   polygon(points=[[0,0], [SHELF_WIDTH,0], [SHELF_WIDTH, SHELF_DEPTH], [0, SHELF_DEPTH]]);
   

}

module overhang(overhang_depth) {
    lower_incut_offset = (SHELF_DEPTH - INCUT_DEPTH) / 2;
    incut_width = 6.15;

    polygon([[0, lower_incut_offset], [-incut_width, lower_incut_offset], [-incut_width, SHELF_DEPTH - lower_incut_offset], [0, SHELF_DEPTH - lower_incut_offset]]);
    
    overhang_width = 6;
    overhang_offset = (SHELF_DEPTH - overhang_depth) / 2;
    translate([-incut_width, 0, 0]) {
        polygon([
            [0, overhang_offset],
            [-overhang_width, overhang_offset],
            [-overhang_width, SHELF_DEPTH - overhang_offset],
            [0, SHELF_DEPTH - overhang_offset]
        ]);
    }
}

module overhang_lower() {
    overhang(overhang_depth=155.5);
}

module overhang_upper() {
    overhang(overhang_depth=SHELF_DEPTH);
}

module lower_shelf_2d() {
    union() {
        shelf_2d();
        overhang_lower();
        translate([SHELF_WIDTH, 0, 0]) {
            mirror([1, 0, 0]) {
                overhang_lower();
            }
        }
    }
}

module upper_shelf_2d() {
    union() {
        shelf_2d();
        overhang_upper();
        translate([SHELF_WIDTH, 0, 0]) {
            mirror([1, 0, 0]) {
                overhang_upper();
            }
        }
    }
}
    

module shelf_3d() {
    difference() {
    linear_extrude(height=SHELF_THICKNESS) upper_shelf_2d();
    translate([INCHES_TO_MM/2, INCHES_TO_MM/2, -5]) {
        cross_hatch_grid(
            width=SHELF_WIDTH - INCHES_TO_MM,
            height=SHELF_DEPTH-INCHES_TO_MM,
            depth=50,
            cell_size=INCHES_TO_MM*.91,
            line_thickness=INCHES_TO_MM/1.93,
            angle=45);
        }
   }
}

shelf_3d();
//overhang_upper();