// Screw Boat
// Stackable open-top tray. The foot below the floor drops into the
// cavity of another boat below it, registering the stack laterally.

$fn = 60;

// Outer footprint (XY) and overall boat height (Z, excludes the foot
// that hangs below the floor).
BOAT_LENGTH    = 50;   // mm, X
BOAT_WIDTH     = 30;   // mm, Y
BOAT_HEIGHT    = 15;   // mm, Z
CORNER_RADIUS  = 6;    // mm, footprint corner rounding (parameter)

// Material thicknesses
FLOOR_THICKNESS = 3;   // mm
WALL_THICKNESS  = 2;   // mm

// Stacking foot below the floor
FOOT_HEIGHT     = 2.5;   // mm, Z extent below the floor
FOOT_CLEARANCE  = 0.3; // mm, gap between foot and the cavity it drops
                       // into, applied in both X and Y (half on each
                       // side after centering).

// Rounded-rectangle 2D footprint, centered on origin.
module rounded_rect(length, width, radius) {
    offset(r = radius)
    square([length - 2 * radius, width - 2 * radius], center = true);
}

// 2D outer footprint of the boat.
module outer_footprint() {
    rounded_rect(BOAT_LENGTH, BOAT_WIDTH, CORNER_RADIUS);
}

// 2D cavity footprint: outer inset by WALL_THICKNESS per side.
module cavity_footprint() {
    offset(r = -WALL_THICKNESS) outer_footprint();
}

// 2D foot footprint: inset an additional FOOT_CLEARANCE / 2 per side
// beyond the cavity, so the foot is FOOT_CLEARANCE smaller than the
// cavity in both X and Y.
module foot_footprint() {
    offset(r = -WALL_THICKNESS - FOOT_CLEARANCE / 2) outer_footprint();
}

// Solid outer block (rounded prism) before the cavity is removed.
module boat_shell() {
    linear_extrude(height = BOAT_HEIGHT)
    outer_footprint();
}

// Open-top cavity carved out above the floor.
module cavity_cutout() {
    translate([0, 0, FLOOR_THICKNESS])
    linear_extrude(height = BOAT_HEIGHT - FLOOR_THICKNESS + 0.01)
    cavity_footprint();
}

// Stacking foot below the floor.
module stacking_foot() {
    translate([0, 0, -FOOT_HEIGHT])
    linear_extrude(height = FOOT_HEIGHT + 0.01)
    foot_footprint();
}

module screw_boat() {
    union() {
        difference() {
            boat_shell();
            cavity_cutout();
        }
        stacking_foot();
    }
}

screw_boat();
