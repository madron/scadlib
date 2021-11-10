include <constants.scad>
use <common.scad>

x = 50;
y = 50;
z = 20;
part_1 = false;
part_2 = false;

/* [Hidden] */
label_depth = 0.2;
$fn=10;


module box_label(x=100, y=100, z=40) {
    translate([0, 0, -label_depth])
        linear_extrude(label_depth * 2)
            translate([x/2, y/2, 0])
                rotate([0, 180, 0])
                    if (x > 90) {
                        text(str(x, "x", y, "x", z), size=10, halign="center", valign="center");
                    } else {
                        text(str(x, "x", y, "x", z), size=6,  halign="center", valign="center");
                    };
}
// box_label(x=80, y=100, z=40);


module top_mold(x=100, y=100, z=40) {
    // Internal sizes
    io = box_side;
    ix = x - io * 2;
    iy = y - io * 2;
    iz = groove_height + 1;
    ir = fillet;
    // Box
    translate([0, 0, z - groove_height])
        translate([io, io, 0]) cube_fillet(ix, iy, iz, side_radius=ir, bottom_radius=0, top_radius=0);
}
// top_mold(x=x, y=y, z=z);


module bottom_mold(x=100, y=100) {
    // External sizes
    eo = 1;
    ex = x + eo * 2;
    ey = y + eo * 2;
    ez = groove_height + 1;
    // Internal sizes
    io = box_side + groove_tolerance;
    ix = x - io * 2;
    iy = y - io * 2;
    iz = ez;
    ir = fillet;
    // Box
    translate([0, 0, -box_bottom])
        difference() {
            translate([-eo, -eo, 0]) cube_fillet(ex, ey, ez, side_radius=0, bottom_radius=0, top_radius=0);
            translate([io, io, box_bottom]) cube_fillet(ix, iy, iz, side_radius=ir, bottom_radius=0, top_radius=0);
        }
}
// bottom_mold(x=x, y=y);


module raw_box_external(x=100, y=100, z=40) {
    // External sizes
    ex = x;
    ey = y;
    ez = z;
    er = fillet + box_side;
    difference() {
        cube_fillet(ex, ey, ez, side_radius=er, bottom_radius=0, top_radius=0);
        bottom_mold(x=x, y=y);
        box_label(x=x, y=y, z=z);
    }
}
// raw_box_external(x=x, y=y, z=z);


module raw_box_internal(x=100, y=100, z=40, bottom=box_bottom) {
    // Internal sizes
    ix = x - box_side * 2;
    iy = y - box_side * 2;
    iz = z;
    ir = fillet;
    translate([box_side, box_side, bottom]) cube_fillet(ix, iy, iz, side_radius=ir, bottom_radius=ir, top_radius=0);
}
// raw_box_internal(x=x, y=y, z=z);


module custom_box(x=100, y=100, z=40) {
    difference() {
        raw_box_external(x=x, y=y, z=z);
        raw_box_internal(x=x, y=y, z=z);
    }
}
// difference() {
//     custom_box(x=x, y=y, z=z);
//     translate([x/2, -5, -5]) cube([x, y+10, z+10]);
// }

custom_box(x=x, y=y, z=z);


module split_groove(x=100, y=100, z=40) {
    translate([x/2, 0, fillet])
        difference() {
            cylinder(d=box_side, h=z, $fn=4);
            translate([-box_side/2, 0, 0]) rotate([0, 45, 0]) cube([box_side, box_side, box_side], center=true);
        }
}
// split_groove(x=100, y=100, z=40);


module custom_box_part_1(x=100, y=100, z=40) {
    difference() {
        custom_box(x=x, y=y, z=z);
        translate([x/2, -5, -5]) cube([x+10, y+10, z+10]);
        translate([0, box_side/2, 0]) split_groove(x=x, y=y, z=z);
        translate([0, y - box_side/2, 0]) split_groove(x=x, y=y, z=z);
    }
}
// custom_box_part_1(x=100, y=100, z=40);


module custom_box_part_2(x=100, y=100, z=40) {
    difference() {
        custom_box(x=x, y=y, z=z);
        custom_box_part_1(x=x, y=y, z=z);
    }
}
// custom_box_part_2(x=100, y=100, z=40);


if (part_1) {
    custom_box_part_1(x=x, y=y, z=z);
}
else if (part_2) {
    custom_box_part_2(x=x, y=y, z=z);
}
else {
    custom_box(x=x, y=y, z=z);
}
