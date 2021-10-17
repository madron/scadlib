include <constants.scad>
use <common.scad>
use <box.scad>

/* [Bits] */
diameters = [3, 4, 5, 6, 7, 8, 9, 10];
min = 60;
max = 120;
/* [Modules] */
x = 2;
y = 3;
z = 20;
/* [Spacing] */
space = 4;
bit_y = 10;
bit_hole_z = 5;

/* [Hidden] */
$fn = 20;


function bit_offset(a=[], i=0, space=0) = (i==0) ? 0 : a[i] / 2 + a[i-1] / 2 + bit_offset(a, i-1, space=space) + space;

function bits_size_x(a=[], space=0) = bit_offset(a, len(a) - 1, space=space) + a[0] / 2  + a[len(a) - 1] / 2;


module drill_bits(diameters=[3, 4], min=60, max=80, space=1) {
    rotate(a=[270, 0, 0]) {
        for (i = [ 0 : len(diameters) - 1 ] ) {
            d = diameters[i];
            offset = bit_offset(diameters, i, space=space);
            l = min + (bit_offset(diameters, i, space=space) / bit_offset(diameters, len(diameters) - 1, space=space)) * (max - min);
            translate([offset, 0, 0]) {
                cylinder(h=l, d=diameters[i]);
            }
        }
    }
}



module base_box(diameters=[3, 4], x=1, y=3, z=20, fn=20) {
    x_size = x * module_size;
    y_size = y * module_size;
    bit_bottom_z = z - max(diameters) / 2 - grid_height;
    bit_x_l = (x_size - bits_size_x(a=diameters, space=space)) / 2;
    bit_x_r = x_size - bits_size_x(a=diameters, space=space);
    difference() {
        raw_box(x=x_size, y=y_size, z=z, bottom=bit_bottom_z, side=box_side, fillet=fillet);
    }
        translate([bit_x_l, bit_y, bit_bottom_z]) drill_bits(diameters=diameters, min=min, max=max, space=space);
    // translate([bit_x, bit_y, bit_bottom_z]) drill_bits(diameters=diameters, min=min, max=max, space=space);
    // cube_fillet(x=x * module_size, y=y * module_size, z=5, side_radius=fillet);
}


difference() {
    base_box(diameters=diameters, x=x, y=y, z=z, fn=$fn);
    translate([0, -1, -1]) cube([100, 4, 30]);
}
