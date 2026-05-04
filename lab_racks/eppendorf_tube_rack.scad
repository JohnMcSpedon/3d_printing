// Eppendorf Tube Rack
// Requested by Jonathan for qiavac 1223 run
// Grid of 1.5 mL Eppendorf tube cutouts (size set by GRID_COLS x GRID_ROWS)

$fn = 50;

// Cutout dimensions
CUTOUT_OD = 11.1;       // mm diameter
CUTOUT_DEPTH = 25;      // mm

// Grid layout
GRID_COLS = 6;          // along X, numbered 1..GRID_COLS
GRID_ROWS = 4;          // along Y, lettered from ROW_LETTERS

// Spacing (center-to-center)
X_SPACING = 18;         // mm, matches lysis rack for multichannel pipette use (every other tip)
Y_SPACING = 33;         // mm

// Margins (outer wall to first well center)
X_MARGIN = 10;          // mm
Y_MARGIN = 10;          // mm

// Minimum wall left around each tube cutout when carving out the
// between-row gaps
WALL_THICKNESS = 2;     // mm

// Fillet radius at the bottom edges of the row-gap slots, where the
// slot floor meets the slot side walls (easier to wipe clean).
FILLET_RADIUS = 5;      // mm

// Sliding rail dovetail at midheight on the X faces. Trapezoid
// cross-section in X-Z, extruded along Y for the full rack width, so
// two racks can be slid together along Y.
DOVETAIL_LENGTH = 7.5;      // mm, projection in X (length of tongue / depth of pocket)
DOVETAIL_BASE_WIDTH = 8;    // mm, narrow end (at the rack face)
DOVETAIL_TIP_WIDTH = 14;    // mm, wide end (at the protruding tip / pocket interior)
DOVETAIL_TOLERANCE = 1;   // mm, female pocket grown by this in all directions
DOVETAIL_REG_LEN = 4;       // mm, asymmetric registration plug/notch length at one Y end

// Rack height
FLOOR_THICKNESS = 5;                            // mm
RACK_HEIGHT = FLOOR_THICKNESS + CUTOUT_DEPTH;

// Calculated footprint. The +X side gets extra material so the sliding
// rail's female pocket (cut DOVETAIL_LENGTH into the +X face) stays
// clear of the rightmost wells with a WALL_THICKNESS safety wall.
X_SPAN = (GRID_COLS - 1) * X_SPACING;
Y_SPAN = (GRID_ROWS - 1) * Y_SPACING;
X_MARGIN_PLUS = max(X_MARGIN,
                    CUTOUT_OD / 2 + WALL_THICKNESS + DOVETAIL_LENGTH);
RACK_LENGTH = X_SPAN + X_MARGIN + X_MARGIN_PLUS;
RACK_WIDTH  = Y_SPAN + 2 * Y_MARGIN;

// Label parameters
LABEL_DEPTH = 0.5;       // mm, engraving depth into top surface
LABEL_SIZE = 3;          // mm, font size
LABEL_FONT = "Roboto:style=Bold";

// Row letters: index 0 is at min Y; A sits at max Y (96-well plate convention)
ROW_LETTERS = ["D", "C", "B", "A"];

// Main rack body
module rack_body() {
    cube([RACK_LENGTH, RACK_WIDTH, RACK_HEIGHT]);
}

// Tube cutouts
module tube_cutouts() {
    for (col = [0 : GRID_COLS - 1]) {
        for (row = [0 : GRID_ROWS - 1]) {
            translate([
                X_MARGIN + col * X_SPACING,
                Y_MARGIN + row * Y_SPACING,
                FLOOR_THICKNESS
            ])
            cylinder(d = CUTOUT_OD, h = CUTOUT_DEPTH + 0.01);
        }
    }
}

// Through-slots in the gaps between rows to reduce wasted material.
// Each slot goes all the way through in X (open on both end faces) and
// from the floor to the top, leaving a WALL_THICKNESS ring of material
// around every cutout. The two long bottom edges (slot floor meeting
// the side walls) are filleted with FILLET_RADIUS.
module row_gap_slots() {
    slot_y = Y_SPACING - CUTOUT_OD - 2 * WALL_THICKNESS;
    R = FILLET_RADIUS;
    // Extend in -X past the rail tip so the protruding rail is also
    // cut at the slot Y positions (otherwise it would print as a
    // floating chunk with no rack body beneath it).
    x_start  = -DOVETAIL_LENGTH - 1;
    x_length = RACK_LENGTH + DOVETAIL_LENGTH + 2;
    slot_height = CUTOUT_DEPTH + 0.01;
    for (gap = [0 : GRID_ROWS - 2]) {
        translate([
            x_start,
            Y_MARGIN + (gap + 0.5) * Y_SPACING - slot_y / 2,
            FLOOR_THICKNESS
        ])
        hull() {
            // Two horizontal cylinders (axis along X) at the bottom
            // corners — these define the fillet radius.
            translate([0, R, R])
                rotate([0, 90, 0])
                cylinder(r = R, h = x_length);
            translate([0, slot_y - R, R])
                rotate([0, 90, 0])
                cylinder(r = R, h = x_length);
            // Sharp top: thin slab spanning full slot width.
            translate([0, 0, slot_height - 0.01])
                cube([x_length, slot_y, 0.01]);
        }
    }
}

// Sliding rail dovetail. Trapezoid cross-section in the X-Z plane
// (centered on z = RACK_HEIGHT/2), extruded along Y for the full rack
// width. Narrow base at x=0 (rack face), wide tip at x=-DOVETAIL_LENGTH.
// Lets two racks be slid together along Y.
module dovetail_rail(grow = 0) {
    rail_y = RACK_WIDTH + 2 * grow;
    translate([0, RACK_WIDTH + grow, 0])
        rotate([90, 0, 0])
            linear_extrude(height = rail_y)
                offset(r = grow)
                polygon(points = [
                    [0,                 RACK_HEIGHT / 2 - DOVETAIL_BASE_WIDTH / 2],
                    [0,                 RACK_HEIGHT / 2 + DOVETAIL_BASE_WIDTH / 2],
                    [-DOVETAIL_LENGTH,  RACK_HEIGHT / 2 + DOVETAIL_TIP_WIDTH  / 2],
                    [-DOVETAIL_LENGTH,  RACK_HEIGHT / 2 - DOVETAIL_TIP_WIDTH  / 2],
                ]);
}

// Male rail on the -X face. Notched at the +Y end to register against
// the mating rack's pocket plug at its -Y end.
module dovetail_rail_male() {
    difference() {
        dovetail_rail();
        translate([-DOVETAIL_LENGTH-1, -1, -1])
            cube([DOVETAIL_LENGTH+1, DOVETAIL_REG_LEN+1, RACK_HEIGHT+2]);
    }
}

// Female pocket on the +X face. Plugged at the -Y end so rack body
// material remains there, blocking the mating rail past its notch.
module dovetail_rail_female() {
    difference() {
        translate([RACK_LENGTH, 0, 0])
            dovetail_rail(grow = DOVETAIL_TOLERANCE);
        translate([RACK_LENGTH - DOVETAIL_LENGTH - 1,
                   -DOVETAIL_TOLERANCE - 1,
                   -1])
            cube([DOVETAIL_LENGTH + 2,
                  DOVETAIL_REG_LEN + DOVETAIL_TOLERANCE + 1,
                  RACK_HEIGHT + 2]);
    }
}

// Row labels engraved on top surface, left margin
module row_labels() {
    for (row = [0 : GRID_ROWS - 1]) {
        translate([
            X_MARGIN / 3,
            Y_MARGIN + row * Y_SPACING,
            RACK_HEIGHT - LABEL_DEPTH
        ])
        linear_extrude(height = LABEL_DEPTH + 0.01)
        text(ROW_LETTERS[row], size = LABEL_SIZE, font = LABEL_FONT,
             halign = "center", valign = "center");
    }
}

// Column labels engraved on top surface, top margin (above row A)
module column_labels() {
    for (col = [0 : GRID_COLS - 1]) {
        translate([
            X_MARGIN + col * X_SPACING,
            RACK_WIDTH - Y_MARGIN / 4,
            RACK_HEIGHT - LABEL_DEPTH
        ])
        linear_extrude(height = LABEL_DEPTH + 0.01)
        text(str(col + 1), size = LABEL_SIZE, font = LABEL_FONT,
             halign = "center", valign = "center");
    }
}

// Main assembly
module eppendorf_tube_rack() {
    difference() {
        union() {
            rack_body();
            dovetail_rail_male();
        }
        tube_cutouts();
        row_gap_slots();
        dovetail_rail_female();
        row_labels();
        column_labels();
    }
}

// Render
eppendorf_tube_rack();


//color("pink") translate([RACK_LENGTH, DOVETAIL_REG_LEN, 0]) eppendorf_tube_rack();

