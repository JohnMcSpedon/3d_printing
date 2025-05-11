REMOTE_HEIGHT = 4;
REMOTE_WIDTH = 86.3;
REMOTE_WING_WIDTH = 10.6;
UNDERHANG_HEIGHT = 6;
WALL_THICKNESS = 5;
ROOF_HEIGHT = 5;

SCREW_MOUNT_WIDTH = 16;

PLYON_HEIGHT = 10;

REMOTE_DEPTH = 39;

module holder_face() {
polygon(points=
    [
        [0, 0],
        [0, REMOTE_HEIGHT],
        [REMOTE_WIDTH, REMOTE_HEIGHT],
        [REMOTE_WIDTH, 0],
        [REMOTE_WIDTH - REMOTE_WING_WIDTH, 0],
        [REMOTE_WIDTH - REMOTE_WING_WIDTH, -UNDERHANG_HEIGHT],
        [REMOTE_WIDTH + WALL_THICKNESS, -UNDERHANG_HEIGHT],
        [REMOTE_WIDTH + WALL_THICKNESS, REMOTE_HEIGHT],
        [REMOTE_WIDTH + WALL_THICKNESS + SCREW_MOUNT_WIDTH, REMOTE_HEIGHT],
        [REMOTE_WIDTH + WALL_THICKNESS + SCREW_MOUNT_WIDTH, REMOTE_HEIGHT + ROOF_HEIGHT], // 9
        [-WALL_THICKNESS - SCREW_MOUNT_WIDTH, REMOTE_HEIGHT + ROOF_HEIGHT], // 10 
        [- WALL_THICKNESS - SCREW_MOUNT_WIDTH, REMOTE_HEIGHT],
        [- WALL_THICKNESS, REMOTE_HEIGHT],
        [-WALL_THICKNESS, -UNDERHANG_HEIGHT],
        [REMOTE_WING_WIDTH, -UNDERHANG_HEIGHT],
        [REMOTE_WING_WIDTH, 0],
    ]);
}


module without_screw_holes() {
    linear_extrude(REMOTE_DEPTH) holder_face();

    for(x = [-WALL_THICKNESS - SCREW_MOUNT_WIDTH/2, REMOTE_WIDTH + WALL_THICKNESS + SCREW_MOUNT_WIDTH/2]) {
        for(z = [10, REMOTE_DEPTH - 10]) {
            translate([x, REMOTE_HEIGHT + ROOF_HEIGHT + PLYON_HEIGHT/2, z]) {
                rotate([90, 0, 0])
                //cylinder(h=(REMOTE_HEIGHT + ROOF_HEIGHT + PYLON_HEIGHT), r=10, center=true);
                cylinder(h=PLYON_HEIGHT, r=5, center=true);
            }
        }
    }
}

difference() {
    without_screw_holes();
    for(x = [-WALL_THICKNESS - SCREW_MOUNT_WIDTH/2, REMOTE_WIDTH + WALL_THICKNESS + SCREW_MOUNT_WIDTH/2]) {
        for(z = [10, REMOTE_DEPTH - 10]) {
            translate([x, -20, z]) {
                rotate([90, 0, 0])
                cylinder(h=100, r=2.2, center=true);

            }
        }
    }
}


// formerly linear extrude used default arg +  for(z = [20, REMOTE_WIDTH - 20]) {
