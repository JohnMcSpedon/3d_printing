// Requires threads.scad (Download from: https://dkprojects.net/openscad-threads/)
use <threads.scad>

// --- Global Resolution ---
$fn = 64;

// --- Thread Parameters (1/2" BSPP) ---
bspp_major_dia = 20.955;
bspp_pitch = 1.814;      // 14 threads per inch (25.4 / 14)
thread_length = 15;      // Depth of the female threads

// --- Nut Parameters ---
nut_outer_dia = 30;      // 30mm hex nut for easy wrench tightening
// The nut is 3mm taller than the threads to create a flat shelf for the sealing washer
nut_height = thread_length + 3;

// --- Hose Barb Parameters (For 1/2" / 12.7mm ID Tubing) ---
barb_length = 25;
barb_max_dia = 13.5;     // Oversized for a tight vacuum stretch-fit
barb_min_dia = 11.5;
num_barbs = 4;

// --- Internal Airway ---
inner_bore = 9;          // 9mm hole leaves thick, strong, airtight walls

module bspp_to_barb() {
    difference() {
        // --- 1. THE SOLID BODY ---
        union() {
            // Hex base
            cylinder(h = nut_height, d = nut_outer_dia, $fn = 6);

            // Stacked conical sections to create the hose barb
            translate([0, 0, nut_height]) {
                for (i = [0 : num_barbs - 1]) {
                    translate([0, 0, i * (barb_length / num_barbs)])
                        cylinder(
                            h = barb_length / num_barbs,
                            d1 = barb_max_dia,
                            d2 = barb_min_dia
                        );
                }
            }
        }

        // --- 2. THE HOLLOW SUBTRACTIONS ---
        // The BSPP Female Thread (Internal)
        translate([0, 0, -0.1])
            metric_thread(
                diameter = bspp_major_dia,
                pitch = bspp_pitch,
                length = thread_length + 0.1,
                internal = true
            );

        // The central airway bore (cuts through the entire length)
        translate([0, 0, -1])
            cylinder(h = nut_height + barb_length + 2, d = inner_bore);
    }
}

// Render the part
bspp_to_barb();
