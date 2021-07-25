include <../dc14/dc14-animal.scad>;
include <../dc8/dc8-animal.scad>;
include <../utils/utils.scad>;

// Vars
plate_thickness = 10;
support_thickness = 35;

module adapter() {
    difference() {
        rotate([90, 0, 0])
            cylinder(h = plate_thickness, r = outer_body_outer_radius);
        
        translate([0, .05, 0])
            rotate([90, 0, 0])
            offset_cylinder(h=plate_thickness, r1=inner_body_inner_radius, r2=inner_radius, o1=inner_body_offset_from_top, s=10);
    }
    
    translate([0, -plate_thickness, 0])
        difference() {
            rotate([90, 0, 0])
                cylinder(h = support_thickness, r1 = outer_body_outer_radius, r2 = outer_radius - .5);
            
            translate([0, 0.5, 0])
                rotate([90, 0, 0])
                cylinder(h=support_thickness + 1, r=outer_radius);
        }
}

adapter();

translate([0, (outer_body_length / 2), 0])
    dc8_assembly();
    
translate([0, -plate_thickness - (connector_length / 2), 0])
    dc14_assembly();