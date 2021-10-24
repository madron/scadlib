include <constants.scad>
use <custom_box.scad>

x = 2;
y = 2;
z = 40;

/* [Hidden] */
$fn=10;


module box(x=1, y=1, z=40) {
    custom_box(x=x * module_size, y=y * module_size, z=z);
}
box(x=x, y=y, z=z);
