// Salt Grinder Lid
// Constants
$fn=1000;
INCH_TO_MM = 25.4;
GRINDER_OD = 2.5 * INCH_TO_MM;  // 2.5 inches converted to mm
GRINDER_WALL_WIDTH = 3;  // mm
GRINDER_ID = GRINDER_OD - 2 * GRINDER_WALL_WIDTH;  // Inner diameter
LID_TOP_HEIGHT = 3;  // mm
LID_INCUT_HEIGHT = 4;  // mm

// Create the lid
union() {
    // Bottom part: Full diameter cylinder for the top of the lid
    cylinder(d = GRINDER_OD, h = LID_TOP_HEIGHT, $fn = 100);

    // Top part: Inner diameter cylinder (incut) that fits inside the grinder
    translate([0, 0, LID_TOP_HEIGHT]) {
        cylinder(d = GRINDER_ID, h = LID_INCUT_HEIGHT, $fn = 100);
    }
}