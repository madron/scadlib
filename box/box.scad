include <constants.scad>
use <Round-Anything/polyround.scad>
use <grid.scad>
use <groove.scad>

x = 2;
y = 2;
z = 40;

/* [Hidden] */
$fn=10;


module side_shape(z=40) {
    offset = box_side * sqrt(2);
    radii_points = [
            [  fillet                   , 0                         , 0],
            [  grid_height              , 0                         , 0],
            [  0                        , grid_height               , 0],
            [  grid_height - box_side   , z -offset + box_side      , grid_height], // grid_height
            [  0                        , z + grid_height - offset  , grid_height / 5],
            [  0                        , z + grid_height           , grid_height / 10],
            [  grid_height              , z                         , grid_height / 2],
            [  box_side                 , box_bottom                , fillet], // fillet
            [  fillet                   , box_bottom                , 0],
    ];
    tolerance_points = [
        [-side_tolerance, - 1],
        [-side_tolerance, z + grid_height + 1],
        [ side_tolerance, z + grid_height + 1],
        [ side_tolerance, - 1],
    ];
    difference() {
        polygon(polyRound(radii_points, fn=$fn));
        polygon(points=tolerance_points);
    }
}
// side_shape(z=z);


module box_side_bar(l=2, z=40) {
    offset = fillet - 0.01;
    linear_extrude(l * module_size - offset * 2) side_shape(z=z);
}


module box_sides(x=2, y=2, z=40) {
    base_x = x * module_size;
    base_y = y * module_size;
    offset = fillet - 0.01;
    translate([0                , base_x - offset   , 0]) rotate(a=[90, 0, 0  ]) box_side_bar(l=y, z=z);
    translate([fillet           , 0                 , 0]) rotate(a=[90, 0, 90 ]) box_side_bar(l=x, z=z);
    translate([base_y           , offset            , 0]) rotate(a=[90, 0, 180]) box_side_bar(l=y, z=z);
    translate([base_y - offset  , base_x            , 0]) rotate(a=[90, 0, 270]) box_side_bar(l=x, z=z);
}
// box_sides(x=x, y=y, z=z);


module box_corner(z=40) {
    rotate_extrude(angle=90, convexity=10, $fn=$fn*2) {
        translate([fillet, 0, 0]) {
            rotate(a=[0, 180, 0]) {
                side_shape(z=z);
            }
        }
    }
}


module box_corners(x=2, y=2, z=40) {
    x = x * module_size;
    y = y * module_size;
    offset = fillet;
    translate([ offset     ,  offset    , 0]) rotate(a=[0, 0, 180]) box_corner(z=z);
    translate([ offset     , -offset + y, 0]) rotate(a=[0, 0, 90 ]) box_corner(z=z);
    translate([-offset + x , -offset + y, 0]) rotate(a=[0, 0, 0  ]) box_corner(z=z);
    translate([-offset + x ,  offset    , 0]) rotate(a=[0, 0, 270]) box_corner(z=z);
}
// box_corners(x=x, y=y, z=z);


module raw_box(x=2, y=2, z=40) {
    base_x = x * module_size;
    base_y = y * module_size;
    box_sides(x=x, y=y, z=z);
    box_corners(x=x, y=y, z=z);
    offset = fillet - 0.01;
    translate([offset, offset, 0]) cube([base_x - offset * 2, base_y - offset * 2, box_bottom]);
}
// raw_box(x=x, y=y, z=z);


module raw_box_bottom_mold(x=2, y=2, z=40) {
    base_x = x * module_size;
    base_y = y * module_size;
    h2 = grid_height + box_bottom * sqrt(2);
    h1 = grid_height;
    offset2 = grid_height - box_side;
    offset1 = grid_height;
    difference() {
        difference() {
            translate([-1, -1, 0]) cube([base_x + 2, base_y + 2, h2 + 1]);
            union() {
                translate([offset2, offset2, h1 -1]) cube([base_x - offset2 * 2, base_y - offset2 * 2, h2 + 3]);
                translate([offset1, offset1,    -1]) cube([base_x - offset1 * 2, base_y - offset1 * 2, h1 + 4]);
            }
        }
        raw_box(x=x, y=y, z=z);
    }
}
// raw_box_bottom_mold(x=x, y=y, z=z);


module box(x=1, y=1, z=40) {
    difference() {
        union() {
            raw_box(x=x, y=y, z=z);
            groove(x=x, y=y);
        }
        grid(x=x, y=y);
        raw_box_bottom_mold(x=x, y=y, z=z);
    }
}
// difference() {
//     box(x=x, y=y, z=z);
//     translate([60,0,-10]) cube([120, 120, 70]);
// }

box(x=x, y=y, z=z);
