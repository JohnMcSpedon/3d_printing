// Eppendorf Tube Rack
// Requested by Jonathan for qiavac 1223 run
// 4x12 grid of 1.5 mL Eppendorf tube cutouts

$fn = 50;

// Cutout dimensions
CUTOUT_OD = 11.1;       // mm diameter
CUTOUT_DEPTH = 25;      // mm

// Grid layout
GRID_COLS = 6;         // along X, columns 1-12
GRID_ROWS = 4;          // along Y, rows A-D

// Spacing (center-to-center)
X_SPACING = 18;         // mm, matches lysis rack for multichannel pipette use (every other tip)
Y_SPACING = 33;         // mm

// Margins (outer wall to first well center)
X_MARGIN = 10;          // mm
Y_MARGIN = 10;          // mm

// Calculated footprint
X_SPAN = (GRID_COLS - 1) * X_SPACING;           // 286mm
Y_SPAN = (GRID_ROWS - 1) * Y_SPACING;           // 48mm
RACK_LENGTH = X_SPAN + 2 * X_MARGIN;            // 306mm
RACK_WIDTH  = Y_SPAN + 2 * Y_MARGIN;            // 68mm

// Rack height
FLOOR_THICKNESS = 5;                            // mm
RACK_HEIGHT = FLOOR_THICKNESS + CUTOUT_DEPTH;   // 28mm

// Minimum wall left around each tube cutout when carving out the
// between-row gaps
WALL_THICKNESS = 2;     // mm

// Fillet radius at the bottom edges of the row-gap slots, where the
// slot floor meets the slot side walls (easier to wipe clean).
FILLET_RADIUS = 5;      // mm

// Dovetail joint to chain racks along X. Male tongue protrudes in -X
// from one rack and seats into the female pocket on the +X face of
// the next rack. One pair per inter-row gap. Sits at the bottom of
// the floor (z = 0 .. DOVETAIL_HEIGHT) so the male prints flat on
// the bed and the female pocket has no overhang to bridge.
DOVETAIL_LENGTH = 7.5;        // mm, projection in X
DOVETAIL_BASE_WIDTH = 8;    // mm, Y width at the rack face (narrow end)
DOVETAIL_TIP_WIDTH = 14;    // mm, Y width at the protruding tip (wide end)
DOVETAIL_HEIGHT = 2.5;      // mm, vertical extent in Z
DOVETAIL_TOLERANCE = 0.1;   // mm, female pocket grown by this in all directions

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
    x_length = RACK_LENGTH + 2;
    slot_height = CUTOUT_DEPTH + 0.01;
    for (gap = [0 : GRID_ROWS - 2]) {
        translate([
            -1,
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

// Dovetail solid: narrow end (BASE_WIDTH) at x=0, wide end
// (TIP_WIDTH) at x = -DOVETAIL_LENGTH, sitting on z=0, centered on
// y=0. Pass grow > 0 to enlarge in all 3 dims for the female pocket.
module dovetail(grow = 0) {
    translate([0, 0, -grow])
    linear_extrude(height = DOVETAIL_HEIGHT + 2 * grow)
    offset(r = grow)
    polygon(points = [
        [0,                -DOVETAIL_BASE_WIDTH / 2],
        [0,                 DOVETAIL_BASE_WIDTH / 2],
        [-DOVETAIL_LENGTH,  DOVETAIL_TIP_WIDTH  / 2],
        [-DOVETAIL_LENGTH, -DOVETAIL_TIP_WIDTH  / 2],
    ]);
}

// Male tongues on the -X face, one per inter-row gap.
module dovetail_males() {
    for (gap = [0 : GRID_ROWS - 2]) {
        translate([0, Y_MARGIN + (gap + 0.5) * Y_SPACING, 0])
            dovetail();
    }
}

// Female pockets on the +X face, one per inter-row gap. The pocket's
// narrow opening sits flush at x = RACK_LENGTH so a mating rack's
// tongue (with base at its own x=0) seats fully against this face.
module dovetail_females() {
    for (gap = [0 : GRID_ROWS - 2]) {
        translate([RACK_LENGTH, Y_MARGIN + (gap + 0.5) * Y_SPACING, 0])
            dovetail(grow = DOVETAIL_TOLERANCE);
    }
}

// Row labels A-D engraved on top surface, left margin
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

// Column labels 1-12 engraved on top surface, top margin (above row A)
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
            dovetail_males();
        }
        tube_cutouts();
        row_gap_slots();
        dovetail_females();
        row_labels();
        column_labels();
    }
}

// Render
eppendorf_tube_rack();
