include <constants.scad>
use <common.scad>
use <grid.scad>
use <groove.scad>

x = 2;
y = 2;
z = 10;

/* [Hidden] */
side = 1;

$fn=20;


module box(x=1, y=1, z=40, fn=20) {
    difference() {
        union() {
            raw_box(x=x * module_size, y=y * module_size, z=z, bottom=box_bottom, side=side, fillet=fillet);
            groove(x=x, y=y, fn=fn);
        }
        grid_bottom_mold(x=x, y=y, fn=fn);
        grid_top_mold(x=x, y=y, z=z, fn=20);
    }
}


module raw_box(x, y, z, bottom=1, side=1, fillet=0) {
    external_x = x - side_tolerance * 2;
    external_y = y - side_tolerance * 2;
    external_z = z;
    internal_x =  external_x - side * 2;
    internal_y =  external_y - side * 2;
    internal_z =  external_z;
    translate([side_tolerance, 0, 0])
        difference() {
            cube_fillet(external_x, external_y, external_z, side_radius=fillet + side);
            translate([side, side, bottom])
                cube_fillet(internal_x, internal_y, internal_z, side_radius=fillet, bottom_radius=fillet);

        };
}


box(x=x, y=y, z=z, fn=$fn);
