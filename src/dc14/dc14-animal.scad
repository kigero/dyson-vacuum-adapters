use <../utils/utils.scad>

// Quality Variables
$fa = 1;
$fs = 0.4;

// Measurements
shell_thickness_meas = 3;
inner_diameter_meas = 37.2;
slot_width_meas = 5.3;
slot_depth_meas = 1.3;
tab_height_meas = 3;
tab_width_meas = 10;
tab_length_meas = 8;

// Vars
connector_length = 50;  
slot_length = 40;
shell_thickness = shell_thickness_meas - 1; 
inner_diameter = inner_diameter_meas + 1.5;
tab_height = tab_height_meas + shell_thickness;
tab_length = tab_length_meas;
tab_width = tab_width_meas + 2;
slot_width = slot_width_meas + 0.2;
slot_depth = slot_depth_meas + 0.2;
outer_diameter = inner_diameter + (2 * shell_thickness);
inner_radius = inner_diameter / 2;
outer_radius = outer_diameter / 2;
slot_width_degrees_half = 10;

// Main body            
module main_body() {
    rotate([90, 0, 0]) {
        difference() {
            difference() {
                cylinder(h=connector_length, r=outer_radius, center=true);
                cylinder(h=connector_length + 1, r=inner_radius, center=true);
            }
        
            translate([0, 0, (connector_length/2) - (slot_length/2)]) {
                linear_extrude(slot_length + 0.1, center=true) arc(inner_radius, [30 - slot_width_degrees_half, 30 + slot_width_degrees_half], slot_depth);
                linear_extrude(slot_length + 0.1, center=true) arc(inner_radius, [150 - slot_width_degrees_half, 150 + slot_width_degrees_half], slot_depth);
                linear_extrude(slot_length + 0.1, center=true) arc(inner_radius, [270 - slot_width_degrees_half, 270 + slot_width_degrees_half], slot_depth);
            }
        }
    }
}
 
// Assembly
module tab_slice() {
    rotate([atan(tab_height/tab_length), 0, 0])
        translate([-0.05, 0, 0])
        union(){
            cube([tab_width + 0.1, tab_length*2, tab_height]);
            cube([tab_width + 0.1, -tab_length*2, tab_height]);
        }
}

module dc14_assembly() {
    tab_origin = [-(tab_width/2), -connector_length / 2, inner_radius];

    // Slice the tab angle from the body.
    difference() {
        main_body();  
        translate(tab_origin)
            tab_slice();
    }

    // Slice the tab angle from the tab.
    difference() {
        translate(tab_origin) 
            cube([tab_width, tab_length, tab_height]);
        translate(tab_origin) 
            tab_slice();
    }
}

//old_connector();