use <../common/fillet.scad>

/* [Handle] */
x = 100;
y = 35;
/* [Panel] */
panel_x = 180;
panel_y = 160;
panel_z = 11;
panel_y_offset = 25;
/* [Marker] */
marker = true;
/* [Clamp] */
clamp_slot = true;
clamp_x = 12;
clamp_y = 80;
clamp_z = 8;
clamp_offset = 25;

/* [Hidden] */
$fn=50;


module handle(x=x, y=y) {
    offset_x = panel_x / 2;
    offset_y = y / 2 + panel_y_offset;
    difference() {
        cube_fillet(panel_x, panel_y, panel_z, side_radius=5);
        translate([offset_x, offset_y, -0.01]) cube_fillet(x, y, panel_z + 0.02, side_radius=y/2, center=true);
        if (marker) {
            marker_offset = panel_z/2 + 2;
            translate([offset_x, offset_y - y / 2 - panel_y_offset, 0]) marker();
            translate([offset_x, offset_y - y / 2 - marker_offset, 0]) marker();
            translate([offset_x, offset_y + y / 2 + marker_offset, 0]) marker();
            translate([offset_x - x / 2 - marker_offset, offset_y, 0]) marker();
            translate([offset_x + x / 2 + marker_offset, offset_y, 0]) marker();
        }
        if (clamp_slot) {
            translate([offset_x - x / 2 - clamp_offset, 0, 0]) clamp_slot();
            translate([offset_x + x / 2 + clamp_offset, 0, 0]) clamp_slot();
            // translate([offset_x, offset_y - y / 2 - clamp_offset, 0]) clamp_slot();
        }
    }
}
handle();


module marker() {
    z_offset = 5;
    translate([0, 0, -z_offset + 0.01]) cylinder(h=panel_z + z_offset, r1=0, r2=panel_z/2, $fn=4);
}

module clamp_slot() {
    translate([-clamp_x / 2, -10, panel_z - clamp_z]) cube_fillet(clamp_x, clamp_y + 10, clamp_z + 0.01, side_radius=2);
}
// clamp_slot();

// module line_x(l=panel_x){
//     square(size=[l, 0.01], center=true);
// }

// module line_y(l=panel_y){
//     square(size=[0.01, l], center=true);
// }

// module marker() {
//     offset_x = panel_x / 2;
//     offset_handle_y = y / 2 + panel_y_offset;
//     // Horizontal lines
//     translate([offset_x, offset_handle_y]) {
//         // Center
//         line_x();
//         // Boundaries
//         translate([0, -y / 2]) line_x();
//         translate([0, y / 2]) line_x();
//         // Markers
//         for (i = [ 0 : len(markers) - 1 ] ) {
//             marker = markers[i];
//             translate([0, -y / 2 - marker]) {
//                 // line_x();
//                 translate([-panel_x / 2 + full_marker_x / 2, 0]) line_x(full_marker_x);
//                 translate([ panel_x / 2 - full_marker_x / 2, 0]) line_x(full_marker_x);
//             }
//             translate([0, -y / 2 - marker + 5]) {
//                 translate([-panel_x / 2 + half_marker_x / 2, 0]) line_x(half_marker_x);
//                 translate([ panel_x / 2 - half_marker_x / 2, 0]) line_x(half_marker_x);
//             }
//         }

//     }
//     // Vertical lines
//     offset_panel_y = panel_y / 2;
//     translate([offset_x, offset_panel_y]) {
//         // Center
//         line_y();
//         // Boundaries
//         translate([-x / 2, 0]) line_y();
//         translate([x / 2, 0]) line_y();
//     }
//         // square(size=[0.1, y], center=true);
// }


// if (print_panel) {
//     handle();
// }
// if (print_marker) {
//     marker();
// }
