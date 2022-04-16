/* [Top panel] */
top_panel_thickness = 18;

/* [Bottom panel] */
bottom_panel_thickness = 18;

/* [Side panels] */
left_panel_thickness = 18;
right_panel_thickness = 18;

/* [External dimensions] */
width = 1200;
deep = 600;
height = 700;


//! Parametric cabinet design.

/* [Hidden] */
$pp1_colour = "grey";           // Override any global defaults here if required, see NopSCADlib/global_defs.scad.
include <NopSCADlib/lib.scad>   // Includes all the vitamins and utilities in NopSCADlib but not the printed parts.


//! Assembly instructions in Markdown format in front of each module that makes an assembly.
module main_assembly() assembly("main") {
    top_panel_stl();
    bottom_panel_stl();
}

if($preview)
    main_assembly();


// Top Panel
module top_panel_stl() stl("top_panel") {
    // $show_threads=true;
    // screw(M3_cap_screw, 10);
    translate([0, 0, height - top_panel_thickness]) cube([width, deep, top_panel_thickness]);
}

// Bottom Panel
module bottom_panel_stl() stl("bottom_panel") {
    cube([width, deep, bottom_panel_thickness]);
}
