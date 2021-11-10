include <constants.scad>
use <custom_box.scad>

x = 2;
y = 2;
z = 40;
part_1 = false;
part_2 = false;

/* [Hidden] */
$fn=10;


module box(x=1, y=1, z=40) {
    custom_box(x=x * module_size, y=y * module_size, z=z);
}


module box_part_1(x=1, y=1, z=40) {
    custom_box_part_1(x=x * module_size, y=y * module_size, z=z);
}


module box_part_2(x=1, y=1, z=40) {
    custom_box_part_2(x=x * module_size, y=y * module_size, z=z);
}


if (part_1) {
    box_part_1(x=x, y=y, z=z);
}
else if (part_2) {
    box_part_2(x=x, y=y, z=z);
}
else {
    box(x=x, y=y, z=z);
}
