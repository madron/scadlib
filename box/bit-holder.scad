use <Round-Anything/polyround.scad>
include <constants.scad>
use <custom_box.scad>

/* [Bits] */
diameters = [3, 4, 5, 6, 7, 8, 9, 10];
min = 65;
max = 150;
/* [Modules] */
x = 2;
y = 3;
z = 20;
/* [Spacing] */
storage_x = 63;
space = 5;
bit_y = 15;
label_y = 5;
bit_diameter_tolerance = 0.5;
bit_fillet = 0;

/* [Hidden] */
$fn = 10;
label_depth = 1;
bit_groove_angle = 15;


function bit_offset(a=[], i=0, space=0) = (i==0) ? 0 : a[i] / 2 + a[i-1] / 2 + bit_offset(a, i-1, space=space) + space;

function bit_length(a=[], i=0, space=0) = min + (bit_offset(a, i, space=space) / bit_offset(a, len(a) - 1, space=space)) * (max - min);

function bits_size_x(a=[], space=0) = bit_offset(a, len(a) - 1, space=space) + a[0] / 2  + a[len(a) - 1] / 2;



module raw_drill_bit(d=3, l=60, r1=0) {
    diameter = d + bit_diameter_tolerance;
    l = l + d/2;
    radii_points = [
        [-diameter / 2, 0, 0],
        [-diameter / 2, l, diameter/2],
        [ diameter / 2, l, diameter/2],
        [ diameter / 2, 0, 0],
    ];
    translate([0, 0, -d]) polyRoundExtrude(radii_points, d, r1=r1, r2=d/2.1, fn=$fn);
}
// raw_drill_bit(d=4, l=60, r1=-1);


module drill_bit(d=3, l=60) {
    raw_drill_bit(d=d, l=l, r1=-bit_fillet);
    translate([0, 0, -d*2/3])
        rotate([bit_groove_angle, 0, 0]) raw_drill_bit(d=d, l=l);
}
// drill_bit(d=4, l=60);


module drill_bits(diameters=[3, 4], x=1, y=3, min=60, max=80, space=1) {
    max_length = y * module_size - bit_y - box_side * 2 - max(diameters) / 2 ;
    x_offset = (diameters[0] + bit_diameter_tolerance) / 2;
    translate([x_offset, 0, 0])
        for (i = [ 0 : len(diameters) - 1 ] ) {
            d = diameters[i];
            offset = bit_offset(diameters, i, space=space);
            l = min(bit_length(diameters, i, space), max_length);
            echo(d, l);
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


module storage_space(diameters=[3, 4], x=1, y=3, z=20) {
    x_size = x * module_size;
    y_size = y * module_size;
    left_x = box_side;
    left_y_top = y_size - box_side;
    left_y_bottom = bit_y + min;
    right_x = storage_x;
    radii_points = [
        [left_x,    left_y_bottom,   fillet],
        [left_x,    left_y_top,      fillet],
        [right_x,   left_y_top,     fillet],
    ];
    translate([0, 0, box_bottom])
        polyRoundExtrude(radii_points, z, r1=0, r2=fillet, fn=$fn);
}
// storage_space(diameters=diameters, x=x, y=y, z=z);


function finger_space_top_points() = [
    [box_side,                      0,          0],
    [box_side,                      min / 5,    0],
    [x * module_size - box_side,    max / 5,    0],
    [x * module_size - box_side,    0,          0],
];


module finger_space_side_mold() {
    radii_points = [
        [box_side,                      0,      0],
        [box_side,                      max,    0],
        [x * module_size - box_side,    max,    0],
        [x * module_size - box_side,    0,      0],
    ];
    difference() {
        translate([-50, -50, -40]) cube([200, 200, 80]);
        translate([0, 0, -50]) polyRoundExtrude(radii_points, 100, r1=0, r2=0, fn=$fn);
    }
}
// finger_space_side_mold();


module finger_space_raw(diameters=[3, 4], x=3, y=3, z=20) {
    x_size = x * module_size;
    y_offset = min / 5;
    x_angle = bit_groove_angle;
    y_angle = atan2(max(diameters) - min(diameters), x_size);
    translate([0, y_offset, 0]) rotate([x_angle, y_angle, 0]) translate([0, -y_offset, 0]) scale([1, 2, 1]) polyRoundExtrude(finger_space_top_points(), z, r1=0, r2=0, fn=$fn);
}
// finger_space_raw(diameters=diameters, x=x, y=y, z=z);


module finger_space(diameters=[3, 4], x=3, y=3, z=20) {
    bit_top_z = z - groove_height;
    translate([0, bit_y, bit_top_z])
        difference() {
            finger_space_raw(diameters=diameters, x=x, y=y, z=z);
            finger_space_side_mold();
        }
}
// finger_space(diameters=diameters, x=x, y=y, z=z);


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
        finger_space(diameters=diameters, x=x, y=y, z=z);
    }
}
difference() {
    base_box(diameters=diameters, x=x, y=y, z=z);
    // translate([0, -1, -1]) cube([100, 20, 30]);
}
