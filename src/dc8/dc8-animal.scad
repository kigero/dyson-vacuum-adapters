use <../utils/utils.scad>

// Quality Variables
$fa = 1;
$fs = 0.4;

// Measurements
outer_body_outer_diameter_meas = 51.6;
outer_body_shell_thickness_meas = 2;
outer_body_length_meas = 26.7;
inner_body_outer_diameter_meas = 35;
inner_body_shell_thickness_meas = 2;
inner_body_length_meas = 63;
inner_body_offset_from_top_meas = 4;
button_box_width_meas = 22;
button_box_height_in_inner_body_meas = 7.4;
fin_width_meas = 1.6;
fin_height_meas = 2;
elec_shell_thickness_meas = 1.6;
elec_length_meas = 15.8;
elec_edge_height_meas = 4;
button_box_offset_meas = 3.5;
button_tab_diameter_meas = 14;
button_tab_center_meas = 20;
button_tab_height_meas = 2.5;
spring_width_meas = 5;

// Vars
elec_width_degrees_half = 38;
outer_body_outer_radius = outer_body_outer_diameter_meas / 2;
outer_body_shell_thickness = outer_body_shell_thickness_meas;
outer_body_length = outer_body_length_meas;
inner_body_outer_radius = inner_body_outer_diameter_meas / 2;
inner_body_shell_thickness = inner_body_shell_thickness_meas + 2;
inner_body_length = inner_body_length_meas;
inner_body_offset_from_top = inner_body_offset_from_top_meas;
button_box_width = button_box_width_meas;
fin_width = fin_width_meas;
fin_height = fin_height_meas;
elec_shell_thickness = elec_shell_thickness_meas + 0.05;
elec_length = elec_length_meas;
elec_edge_height = elec_edge_height_meas;
outer_body_inner_radius = outer_body_outer_radius - outer_body_shell_thickness;
inner_body_inner_radius = inner_body_outer_radius - inner_body_shell_thickness;
button_box_height = button_box_height_in_inner_body_meas + inner_body_offset_from_top_meas;
button_box_height_in_inner_body = button_box_height_in_inner_body_meas;
button_box_offset = button_box_offset_meas;
button_tab_radius = button_tab_diameter_meas / 2;
button_tab_center = button_tab_center_meas;
button_tab_height = button_tab_height_meas;
end_plate_thickness = 1;
spring_shell_thickness = 2;
spring_height = 2;
spring2_offset = 30;
spring_radius = spring_width_meas / 2;

module outer_body() {
    rotate([90, 0, 0]) {
        difference() {
            cylinder(h=outer_body_length, r=outer_body_outer_radius, center=true);
            cylinder(h=outer_body_length + 1, r=outer_body_inner_radius, center=true);
        }
    }
}

module inner_body() {
    rotate([90, 0, 0]) {
        difference() {
            cylinder(h=inner_body_length, r=inner_body_outer_radius, center=true);
            cylinder(h=inner_body_length + 1, r=inner_body_inner_radius, center=true);
        }
    }
    translate([-inner_body_outer_radius - (fin_width / 2), 0, 0])
        cube([fin_width, inner_body_length, fin_height], center=true);
    translate([inner_body_outer_radius + (fin_width / 2), 0, 0])
        cube([fin_width, inner_body_length, fin_height], center=true);
}

module electrical_connector() {
    outer_body_end = elec_length/2;
    translate([0, outer_body_end, 0])
        rotate([90, 0, 0]) 
        linear_extrude(elec_length, center=true) arc(outer_body_inner_radius - elec_shell_thickness, [270 - elec_width_degrees_half+.5, 270 + elec_width_degrees_half], elec_shell_thickness + 0.2);
    
    translate([(outer_body_inner_radius * cos(270 - elec_width_degrees_half)) + (elec_shell_thickness / 2), outer_body_end, (outer_body_inner_radius * sin(270 - elec_width_degrees_half) + (elec_edge_height / 2))])
        cube([elec_shell_thickness, elec_length, elec_edge_height], center=true);
    translate([(outer_body_inner_radius * cos(270 + elec_width_degrees_half)) - (elec_shell_thickness / 2), outer_body_end, (outer_body_inner_radius * sin(270 - elec_width_degrees_half) + (elec_edge_height / 2))])
        cube([elec_shell_thickness, elec_length, elec_edge_height], center=true);
}

module dc8_assembly() {
    // Assembly
    difference() {
        union() {
            outer_body();
            translate([0, (inner_body_length / 2) - (outer_body_length / 2) - 0.1, outer_body_outer_radius - inner_body_outer_radius - inner_body_offset_from_top]) {
                inner_body();
            }
        }
        
        // Cutout in outer body.
        translate([0, 0, outer_body_inner_radius - (button_box_height / 2)]) 
            cube([button_box_width + 0.1, outer_body_length + 1, button_box_height + 10], center=true);
            
        // Cutout in inner body.
        translate([0, ((inner_body_length - outer_body_length) / 2) + (outer_body_length/2) - button_box_offset, outer_body_inner_radius - (button_box_height / 2)]) 
            cube([button_box_width + 0.1, inner_body_length - outer_body_length, button_box_height], center=true);
    }

    // Cutout for button box.
    difference() {
        difference() {
            translate([0, (inner_body_length - outer_body_length - button_box_offset)/2, outer_body_inner_radius - (button_box_height / 2)]) 
                cube([button_box_width, inner_body_length - button_box_offset, button_box_height], center=true);
            translate([0, outer_body_length * 1.3, -0.9]) 
                rotate([90, 0, 0]) 
                linear_extrude(inner_body_length - outer_body_length + 0.1 + 6.3, center=true) arc(inner_body_outer_radius + 4.5, [50, 120], 100);
            rotate([90, 0, 0]) 
                linear_extrude(outer_body_length + 0.1, center=true) arc(outer_body_outer_radius, [64.5, 115.5], 100);
        }
        translate([0, (inner_body_length/2) - (outer_body_outer_radius/2) - button_box_offset - 0.5, outer_body_outer_radius - (button_box_height / 2)]) 
            cube([button_box_width - outer_body_shell_thickness, inner_body_length-2, button_box_height], center=true);
    }

    // translate([0, outer_body_length / 2, 0]) 
    //     electrical_connector();
        
    translate([0, 0, 0])
        rotate([90, 0, 0]) 
        linear_extrude(outer_body_length, center=true) arc(inner_body_outer_radius - inner_body_offset_from_top - 0.4, [270 - elec_width_degrees_half, 270 + elec_width_degrees_half], outer_body_inner_radius - inner_body_outer_radius + inner_body_offset_from_top + 1);

    // Button
    translate([0, button_box_offset / 2, 0]) 
        rotate([90, 0, 0]) 
        linear_extrude(outer_body_length + 0.1 - button_box_offset, center=true) arc(inner_body_inner_radius + (inner_body_shell_thickness/2) + 4.5, [68, 112], outer_body_shell_thickness * 3);
    translate([0, (inner_body_length/2) - (outer_body_length/2) + 0.1, -outer_body_shell_thickness - (inner_body_shell_thickness/2)]) 
        rotate([90, 0, 0]) 
        linear_extrude(inner_body_length - button_box_offset + 0.1 - button_box_offset, center=true) arc(inner_body_outer_radius + (inner_body_shell_thickness/2) + 4.5, [68, 112], outer_body_shell_thickness*.85);
    translate([0, (outer_body_length/2) + button_tab_center, inner_body_outer_radius + inner_body_shell_thickness + (button_tab_height / 2) - (inner_body_shell_thickness/2) - 1])
        rotate([-15, 0, 0]) 
        cylinder(h = button_tab_height, r1 = button_tab_radius, r2 = button_tab_radius);
    
    // Spring Holders
    spring_holder_y_pos = inner_body_inner_radius + (inner_body_shell_thickness/2) - 0.2;
    difference() {
        translate([0, 0, spring_holder_y_pos])
            cylinder(h=spring_height, r=spring_radius + spring_shell_thickness, center=true);
        translate([0, 0, spring_holder_y_pos])
            cylinder(h=spring_height + 0.1, r=spring_radius, center=true);
    }
    difference() {
        translate([0, spring2_offset, spring_holder_y_pos])
            cylinder(h=spring_height, r=spring_radius + spring_shell_thickness, center=true);
        translate([0, spring2_offset, spring_holder_y_pos])
            cylinder(h=spring_height + 0.1, r=spring_radius, center=true);
    }
        
    // Back panel
    difference() {
        translate([0, -outer_body_length/2 + end_plate_thickness, 0])
            rotate([90, 0, 0])
            linear_extrude(end_plate_thickness) circle(outer_body_outer_radius);
        difference() {
            translate([0, -outer_body_length/2 + end_plate_thickness, inner_body_offset_from_top])
                rotate([90, 0, 0])
                linear_extrude(end_plate_thickness + 0.5) circle(inner_body_inner_radius);
            translate([0, (inner_body_length/2) - (outer_body_outer_radius/2) - button_box_offset - 0.5, outer_body_outer_radius - (button_box_height / 2)]) 
                cube([button_box_width - outer_body_shell_thickness, inner_body_length, button_box_height], center=true);
        }
    }
}

// new_connector();