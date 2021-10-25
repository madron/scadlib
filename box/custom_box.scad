use <Round-Anything/polyround.scad>
include <constants.scad>
use <common.scad>

x = 50;
y = 50;
z = 20;

/* [Hidden] */
label_depth = 0.2;
$fn=10;


module box_label(x=100, y=100, z=40) {
    translate([0, 0, -label_depth])
        linear_extrude(label_depth * 2)
            translate([x/2, y/2, 0])
                rotate([0, 180, 180])
                    if (x > 90) {
                        text(str(x, "x", y, "x", z), size=10, halign="center", valign="center");
                    } else {
                        text(str(x, "x", y, "x", z), size=6,  halign="center", valign="center");
                    };
}
// box_label(x=80, y=100, z=40);


module raw_box(x=100, y=100, z=40) {
    // External sizes
    eo = side_tolerance;
    ex = x - eo * 2;
    ey = y - eo * 2;
    ez = z;
    er = fillet + box_side / 2;
    // Internal sizes
    io = side_tolerance + box_side;
    ix = x - io * 2;
    iy = y - io * 2;
    iz = ez;
    ir = fillet;
    // Box
    difference() {
        translate([eo, eo, 0])          cube_fillet(ex, ey, ez, side_radius=er, bottom_radius=0, top_radius=0);
        translate([io, io, box_bottom]) cube_fillet(ix, iy, iz, side_radius=ir, bottom_radius=ir, top_radius=0);
    }
}
// raw_box(x=x, y=y, z=z);


module bottom_mold_shape() {
    offset = 5;
    radii_points = [
            [-offset, -offset, 0],
            [box_side + groove_chamfer + groove_tolerance, -offset, 0],
            [box_side + groove_chamfer + groove_tolerance, 0, 0],
            [box_side + groove_tolerance, groove_chamfer, 0],
            [box_side + groove_tolerance, box_side + groove_height, 1],
            [-offset, box_side + groove_height, 0],
    ];
    polygon(polyRound(radii_points, fn=$fn));
}
// bottom_mold_shape();


module bottom_mold_bar(l=1) {
    linear_extrude(height=l) {
        bottom_mold_shape();
    }
}
// bottom_mold_bar();


module bottom_mold_sides(x=80, y=50) {
    offset = fillet - 0.01;
    translate([0, y, 0]) rotate(a=[90, 0, 0  ]) bottom_mold_bar(l=y);
    translate([0, 0, 0]) rotate(a=[90, 0, 90 ]) bottom_mold_bar(l=x);
    translate([x, 0, 0]) rotate(a=[90, 0, 180]) bottom_mold_bar(l=y);
    translate([x, y, 0]) rotate(a=[90, 0, 270]) bottom_mold_bar(l=x);
}
// bottom_mold_sides(x=x, y=y);


module bottom_mold_corner() {
    rotate_extrude(angle=90, convexity=10, $fn=$fn*2) {
        translate([fillet, 0, 0]) {
            rotate(a=[0, 180, 0]) {
                bottom_mold_shape();
            }
        }
    }
}
// bottom_mold_corner();


module bottom_mold_corners(x=80, y=50) {
    offset = fillet;
    translate([ offset     ,  offset    , 0]) rotate(a=[0, 0, 180]) bottom_mold_corner();
    translate([ offset     , -offset + y, 0]) rotate(a=[0, 0, 90 ]) bottom_mold_corner();
    translate([-offset + x , -offset + y, 0]) rotate(a=[0, 0, 0  ]) bottom_mold_corner();
    translate([-offset + x ,  offset    , 0]) rotate(a=[0, 0, 270]) bottom_mold_corner();
}
// bottom_mold_corners(x=x, y=y);


module bottom_mold(x=100, y=100) {
    offset = 5;
    union() {
        bottom_mold_sides(x=x, y=y);
        bottom_mold_corners(x=x, y=y);
        translate([-offset, -offset, -offset]) cube([x + offset * 2, y + offset * 2, offset]);
    }
}
// bottom_mold(x=x, y=y);
// difference() {
//     bottom_mold(x=x, y=y);
//     translate([x/2, -6, -6]) cube([x, y + 12, z + 10]);
// }


module custom_box(x=100, y=100, z=40) {
    difference() {
        raw_box(x=x, y=y, z=z);
        bottom_mold(x=x, y=y);
        box_label(x=x, y=y, z=z);
    }
}
difference() {
    custom_box(x=x, y=y, z=z);
    translate([x/2, 0, -1]) cube([x, y, z + 2]);
}

// custom_box(x=x, y=y, z=z);
