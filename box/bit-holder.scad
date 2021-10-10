include <constants.scad>
use <box.scad>

/* [Bits] */
diameters = [3, 4, 5, 6, 8];
min = 60;
max = 120;
/* [Modules] */
x = 1;
y = 3;
/* [Spacing] */
space = 2;

/* [Hidden] */
$fn = 20;


function bit_offset(a=[], i=0, space=0) = (i==0) ? 0 : a[i] / 2 + a[i-1] / 2 + bit_offset(a, i-1, space=space) + space;


module drill_bits(diameters=[3, 4], min=60, max=80) {
    echo(module_size);
    rotate(a=[270, 0, 0])
        for (i = [ 0 : len(diameters) - 1 ] ) {
            d = diameters[i];
            offset = bit_offset(diameters, i, space=space);
            l = min + (bit_offset(diameters, i, space=space) / bit_offset(diameters, len(diameters) - 1, space=space)) * (max - min);
            translate([offset, 0, 0]) {
                cylinder(h=l, d=diameters[i]);
            }
        }
}


drill_bits(diameters=diameters, min=min, max=max);

cube_fillet(x=x * module_size, y=y * module_size, z=15, side_radius=fillet);
