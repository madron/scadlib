use <Round-Anything/polyround.scad>
include <constants.scad>
use <custom_box.scad>

/* [Bits] */
diameters = [3, 4, 5, 6, 7, 8, 9, 10];
min = 60;
max = 120;
/* [Modules] */
x = 2;
y = 3;
z = 20;
/* [Spacing] */
storage_x = 100;
space = 5;
bit_y = 15;
label_y = 6;
bit_diameter_tolerance = 0.1;

/* [Hidden] */
$fn = 10;
label_depth = 1;


function bit_offset(a=[], i=0, space=0) = (i==0) ? 0 : a[i] / 2 + a[i-1] / 2 + bit_offset(a, i-1, space=space) + space;

function bit_length(a=[], i=0, space=0) = min + (bit_offset(a, i, space=space) / bit_offset(a, len(a) - 1, space=space)) * (max - min);

function bits_size_x(a=[], space=0) = bit_offset(a, len(a) - 1, space=space) + a[0] / 2  + a[len(a) - 1] / 2;



module raw_drill_bit(d=3, l=60) {
    d = d + bit_diameter_tolerance;
    radii_points = [
        [-d / 2, 0, 0],
        [-d / 2, l, d/2],
        [ d / 2, l, d/2],
        [ d / 2, 0, 0],
    ];
    translate([0, 0, -d]) polyRoundExtrude(radii_points, d + 1, r1=0, r2=d/2.1, fn=$fn);
}
// drill_bit(d=4, l=60);


module drill_bit(d=3, l=60) {
    raw_drill_bit(d=d, l=l);
    translate([0, 0, -d*2/3])
        rotate([15, 0, 0]) raw_drill_bit(d=d, l=l);
}
// drill_bit(d=4, l=60);


module drill_bits(diameters=[3, 4], min=60, max=80, space=1) {
    x_offset = (diameters[0] + bit_diameter_tolerance) / 2;
    translate([x_offset, 0, 0])
        for (i = [ 0 : len(diameters) - 1 ] ) {
            d = diameters[i];
            offset = bit_offset(diameters, i, space=space);
            l = bit_length(diameters, i, space);
            translate([offset, 0, 0]) drill_bit(d=d, l=l);
        }
}
// drill_bits(diameters=diameters, min=min, max=max, space=space);


module labels(diameters=[3, 4], space=1) {
    x_offset = (diameters[0] + bit_diameter_tolerance) / 2;
    translate([x_offset, 0, -label_depth])
        for (i = [ 0 : len(diameters) - 1 ] ) {
            d = diameters[i];
            offset = bit_offset(diameters, i, space=space);
            linear_extrude(label_depth + 0.1)
                translate([offset, 0, 0])
                    text(str(d), size=8, halign="center", valign="bottom");

        }
}
// labels(diameters=diameters, space=space);


module storage_shape(diameters=[3, 4], x=1, y=3) {
}
// labels(diameters=diameters, space=space);

module storage_space(diameters=[3, 4], x=1, y=3, z=20) {
    x_size = x * module_size;
    y_size = y * module_size;
    x_offset = (diameters[0] + bit_diameter_tolerance) / 2;
    // bit_x = bits_size_x(a=diameters, space=space);
    // bit_x_l = (x_size - bit_x) / 2;
    bit_x = bits_size_x(a=diameters, space=space);
    bit_x_l = (x_size - bit_x) / 2;

    left_x = box_side;
    left_y_top = y_size - box_side - side_tolerance * 2;
    left_y_bottom = bit_y + min;
    // right_x = bits_size_x(a=diameters, space=space);
    right_x = storage_x;
    // right_y_top = y_size - box_side - side_tolerance * 2;
    // right_y_bottom = bit_y + max;

    radii_points = [
        // [bit_x_l,   left_y_bottom,   fillet],
        [left_x,    left_y_bottom,   fillet],
        [left_x,    left_y_top,      fillet],
        [right_x,   left_y_top,     fillet],
    ];
    translate([0, 0, box_bottom])
        polyRoundExtrude(radii_points, z, r1=0, r2=fillet, fn=$fn);
}
// storage_space(diameters=diameters, x=x, y=y, z=z);


module base_box(diameters=[3, 4], x=1, y=3, z=20) {
    x_size = x * module_size;
    y_size = y * module_size;
    bit_bottom_z = z - groove_height;
    bit_x = bits_size_x(a=diameters, space=space);
    bit_x_l = (x_size - bit_x) / 2;
    difference() {
        raw_box_external(x=x_size, y=y_size, z=z);
        top_mold(x=x_size, y=y_size, z=z);
        translate([bit_x_l, bit_y, bit_bottom_z]) drill_bits(diameters=diameters, min=min, max=max, space=space);
        translate([bit_x_l, label_y, bit_bottom_z]) labels(diameters=diameters, space=space);
        storage_space(diameters=diameters, x=x, y=y, z=z);
    }
}
difference() {
    base_box(diameters=diameters, x=x, y=y, z=z);
    // translate([0, -1, -1]) cube([100, 20, 30]);
}
