//! Project description in Markdown format before the first include.
$pp1_colour = "grey";           // Override any global defaults here if required, see NopSCADlib/global_defs.scad.
include <NopSCADlib/lib.scad>   // Includes all the vitamins and utilities in NopSCADlib but not the printed parts.


//! Assembly instructions in Markdown format in front of each module that makes an assembly.
module main_assembly()
assembly("main") {
    $show_threads=true;
    screw(M3_cap_screw, 10);
}

if($preview)
    main_assembly();
