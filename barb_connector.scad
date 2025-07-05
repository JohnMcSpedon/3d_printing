// Unit conversion constant
INCHES_TO_MM = 25.4;

// One-sided barb connector module
module barb_connector_one_quarter(
    barb_count = 1,           // Number of barb ridges
    barb_max_dia = 0.185,     // Maximum barb diameter in inches
    barb_min_dia = 0.155,     // Minimum (valley) diameter in inches
    barb_length = 0.2,        // Total length of barbed section in inches
    lead_taper_length = 0.1,  // Length of lead-in taper in inches
    base_dia = 0.25,          // Base diameter in inches (at z=0)
    base_length = 0.1,        // Base section length in inches
    $fn = 50                  // Resolution
) {
    // Convert to mm
    barb_max_r = barb_max_dia * INCHES_TO_MM / 2;
    barb_min_r = barb_min_dia * INCHES_TO_MM / 2;
    barb_len = barb_length * INCHES_TO_MM;
    lead_len = lead_taper_length * INCHES_TO_MM;
    base_r = base_dia * INCHES_TO_MM / 2;
    base_len = base_length * INCHES_TO_MM;
    
    // Calculate barb spacing
    barb_spacing = barb_len / barb_count;
    
    // Total height of the fitting
    total_height = base_len + barb_len + lead_len;
    
    union() {
        // Base section at origin
        cylinder(h = base_len, r = base_r, $fn = $fn);
        
        // Transition from base to first barb valley
        translate([0, 0, base_len])
            cylinder(h = 0.25 * INCHES_TO_MM, r1 = barb_min_r, r2 = barb_min_r, $fn = $fn);
        
        // Barbed section with reversed sawtooth profile
        translate([0, 0, base_len + 0.25 * INCHES_TO_MM]) {
            for (i = [0:barb_count-1]) {
                translate([0, 0, i * barb_spacing]) {
                    // Sharp rise (flat portion facing origin)
                    cylinder(h = barb_spacing * 0.3, r = barb_max_r, $fn = $fn);
                    
                    // Gradual taper down (conical portion facing away)
                    translate([0, 0, barb_spacing * 0.3])
                        cylinder(h = barb_spacing * 0.7, r1 = barb_max_r, r2 = barb_min_r, $fn = $fn);
                }
            }
        }
        
        // Lead-in taper at the tip
        translate([0, 0, base_len + 0.25 * INCHES_TO_MM + barb_len])
            cylinder(h = lead_len, r1 = barb_min_r, r2 = barb_min_r * 0.7, $fn = $fn);
    }
}



// You can also customize it:
// barb_connector(barb_count = 5, barb_max_dia = 0.19, base_dia = 0.3);


// Small metric barb connector module
module small_barb_connector($fn = 50) {
    // All dimensions in mm
    base_dia = 4;           // Base cylinder diameter
    base_height = 1;        // Base cylinder height
    stem_dia = 1.4;         // Stem diameter (same as barb min)
    stem_height = 2.3;      // Height from base to barb
    barb_min_dia = 1.4;     // Barb valley diameter
    barb_max_dia = 1.7;     // Barb peak diameter
    barb_height = 2;        // Barb height
    tip_dia = 1.2;          // Tip taper diameter
    tip_height = 1;         // Tip taper height
    
    union() {
        // Base cylinder
        cylinder(h = base_height, d = base_dia, $fn = $fn);
        
        // Stem section
        translate([0, 0, base_height])
            cylinder(h = stem_height, d = stem_dia, $fn = $fn);
        
        // Single barb with reversed sawtooth
        translate([0, 0, base_height + stem_height]) {
            // Sharp rise (flat portion facing origin)
            cylinder(h = barb_height * 0.3, d = barb_max_dia, $fn = $fn);
            
            // Gradual taper down (conical portion facing away)
            translate([0, 0, barb_height * 0.3])
                cylinder(h = barb_height * 0.7, d1 = barb_max_dia, d2 = barb_min_dia, $fn = $fn);
        }
        
        // Top taper
        translate([0, 0, base_height + stem_height + barb_height])
            cylinder(h = tip_height, d1 = barb_min_dia, d2 = tip_dia, $fn = $fn);
    }
}

difference() {
    union() {
        barb_connector_one_quarter();
        mirror([0, 0, 1]) small_barb_connector();
    };
    translate([0, 0, -50]) cylinder(h=1000, r=0.75/2, center=true, $fn=100);
}
