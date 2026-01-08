// Opentrons 10ml Reservoir Holder
// Two-level design with dual reservoir cutouts

// Base dimensions (sits on Opentrons deck)
base_width = 127.76;
base_depth = 85.48;
base_height = 8;
base_corner_radius = 3;

// Platform dimensions (sits on top of base)
platform_width = 127.76;
platform_depth = 110;
platform_height = 8;
platform_corner_radius = 3;

// Cutout dimensions
cutout_width = 52;
cutout_depth = 102;
cutout_height = 4;
cutout_corner_radius = 2;
cutout_inset = 8;  // distance from outside edge in width axis

module rounded_rect(width, depth, height, radius) {
    hull() {
        for (x = [radius, width - radius]) {
            for (y = [radius, depth - radius]) {
                translate([x, y, 0])
                    cylinder(h = height, r = radius, $fn = 32);
            }
        }
    }
}

// Base
rounded_rect(base_width, base_depth, base_height, base_corner_radius);

// Platform with cutouts
difference() {
    // Platform on top of base
    translate([0, 0, base_height])
        rounded_rect(platform_width, platform_depth, platform_height, platform_corner_radius);

    // Cutout 1 (left side)
    translate([
        cutout_inset,
        (platform_depth - cutout_depth) / 2,
        base_height + platform_height - cutout_height
    ])
        rounded_rect(cutout_width, cutout_depth, cutout_height + 1, cutout_corner_radius);

    // Cutout 2 (right side)
    translate([
        platform_width - cutout_inset - cutout_width,
        (platform_depth - cutout_depth) / 2,
        base_height + platform_height - cutout_height
    ])
        rounded_rect(cutout_width, cutout_depth, cutout_height + 1, cutout_corner_radius);
}
