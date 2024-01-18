$fn = 180;
outer_radius = 20.65 / 2;
inner_radius = 12.95 / 2;
inner_height = 4.5;
outer_height = 4;
num_gaps = 8;
gap_degrees = 12;
tooth_size = 0.5;
tooth_base_height = 2.5;
tooth_face_height = 1;
inner_ring_depth = 1.25;
outer_ring_depth = 1.25;
total_depth = 4;
bottom_shelf_outer_height=1;
eps = 0.1;

module cylindrical_shell(h, outer_r, inner_r) {
    difference() {
        cylinder(h, r=outer_r);
        cylinder(h, r=inner_r);
    }
}

module cross_section() {
    polygon(points=[[0,0],
    [0, tooth_base_height],
    [-tooth_size, tooth_base_height],
    [-tooth_size, tooth_base_height + tooth_face_height],
    [0, inner_height],
    [inner_ring_depth, inner_height],
    [inner_ring_depth, bottom_shelf_outer_height],
    [total_depth - outer_ring_depth, bottom_shelf_outer_height],
    [total_depth - outer_ring_depth, outer_height],
    [total_depth, outer_height],
    [total_depth, 0],
    ]);
}

module single_gap() {
    translate([0, 0, bottom_shelf_outer_height])
    rotate_extrude(angle = gap_degrees) {
        square([outer_radius - outer_ring_depth, outer_height], center = false);
    }
}

module all_gaps() {
    union() {
        for (i = [0 : num_gaps - 1]) {
            rotate(360 / num_gaps * i)
            single_gap();
        }
    }
}


difference() {
    rotate_extrude() {
        translate([inner_radius, 0, 0])
        cross_section();
    };
    all_gaps();
}
