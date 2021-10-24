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
    translate([0                , base_y - offset   , 0]) rotate(a=[90, 0, 0  ]) box_side_bar(l=y, z=z);
    translate([offset           , 0                 , 0]) rotate(a=[90, 0, 90 ]) box_side_bar(l=x, z=z);
    translate([base_x           , offset            , 0]) rotate(a=[90, 0, 180]) box_side_bar(l=y, z=z);
    translate([base_x - offset  , base_y            , 0]) rotate(a=[90, 0, 270]) box_side_bar(l=x, z=z);
}
// box_sides(x=x, y=y, z=z);


module box_sides_mold(x=2, y=2, z=40) {
    base_x = x * module_size;
    base_y = y * module_size;
    offset = fillet - 0.01;
    internal_offset = max(fillet, grid_height);
    external_offset = 5;
    vertical_offset = -1;
    cube_h = z + vertical_offset + 2;
    difference() {
        difference() {
            translate([-external_offset, -external_offset , 0.5]) cube([base_x + external_offset * 2, base_x + external_offset * 2, z + vertical_offset + 0.5]);
            translate([internal_offset, internal_offset, -1]) cube([base_x - internal_offset * 2, base_x - internal_offset * 2, z + vertical_offset + 3]);
        }
        for(slide_x = [0: box_side / 2 : internal_offset]) {
            translate([slide_x, 0, 0])
                translate([0                , base_y - offset   , 0]) rotate(a=[90, 0, 0  ]) box_side_bar(l=y, z=z);
            translate([-slide_x, 0, 0])
                translate([base_x           , offset            , 0]) rotate(a=[90, 0, 180]) box_side_bar(l=y, z=z);
        }
        for(slide_y = [0: box_side / 2 : internal_offset]) {
            translate([0, slide_y, 0])
                translate([offset           , 0                 , 0]) rotate(a=[90, 0, 90 ]) box_side_bar(l=x, z=z);
            translate([0, -slide_y, 0])
                translate([base_x - offset  , base_y            , 0]) rotate(a=[90, 0, 270]) box_side_bar(l=x, z=z);
        }
        translate([0     , 0     , cube_h / 2]) cube([module_size, module_size, cube_h], center = true);
        translate([base_x, 0     , cube_h / 2]) cube([module_size, module_size, cube_h], center = true);
        translate([0     , base_y, cube_h / 2]) cube([module_size, module_size, cube_h], center = true);
        translate([base_x, base_y, cube_h / 2]) cube([module_size, module_size, cube_h], center = true);
    }
}
// box_sides_mold(x=x, y=y, z=z);


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


module box(x=1, y=1, z=40) {
    difference() {
        union() {
            raw_box(x=x, y=y, z=z);
            groove(x=x, y=y);
        }
        box_sides_mold(x=x, y=y, z=z);
        bottom_mold(x=x, y=y);
    }
}
// difference() {
//     box(x=x, y=y, z=z);
//     translate([50,0,-10]) cube([120, 120, 70]);
// }

// Check if boxes are stackable
// intersection() {
//     translate([0  , 0  , 0]) box(x=x, y=y, z=z);
//     translate([100, 0  , 0]) box(x=x, y=y, z=z);
//     translate([100, 100, 0]) box(x=x, y=y, z=z);
//     translate([0  , 100, 0]) box(x=x, y=y, z=z);
//     translate([50 , 50 , 40]) box(x=x, y=y, z=z);
// }


box(x=x, y=y, z=z);
