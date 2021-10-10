use <Round-Anything/polyround.scad>
include <constants.scad>

x = 2;
y = 2;

/* [Hidden] */
top_r = 2;
bottom_r = 2;

$fn=20;


module groove_shape(fn=20) {
    height = grid_height;
    thickness = box_bottom;
    offset = thickness * sqrt(2) - thickness;
    extension = height * 3;
    top_size = height;
    top_side = top_size / 2;
    top_height = thickness + offset;
    radii_points = [
            [  height                           , 0                                         , 0],
            [  extension                        , 0                                         , 0],
            [  extension                        , -thickness                                , 0],
            [  height + offset + top_side       , -thickness                                , bottom_r],
            [  top_side                         , -height - top_height                      , top_r],
            [ -top_side                         , -height - top_height                      , top_r],
            [ -height - offset - top_side       , -thickness                                , bottom_r],
            [ -extension                        , -thickness                                , 0],
            [ -extension                        , 0                                         , 0],
            [ -height                           , 0                                         , 0],
            [ 0                                 , -height                                   , 0], // End (center of groove)
    ];
    polygon(polyRound(radii_points, fn=fn));
}


module groove_bar_vertical(height=1, fn=20) {
    linear_extrude(height=height) {
        groove_shape(fn=fn);
    }
}


module groove_bar_x(lenght=1, fn=20) {
    rotate(a=[270, 0, 270]) {
        translate([0, 0, side_tolerance]) {
            groove_bar_vertical(height=lenght * module_size - 2 * side_tolerance, fn=fn);
        }
    }
}


module groove_bar_y(lenght=1, fn=20) {
    rotate(a=[270, 0, 0]) {
        translate([0, 0, side_tolerance]) {
            groove_bar_vertical(height=lenght * module_size - 2 * side_tolerance, fn=fn);
        }
    }
}


module groove(x=1, y=1, fn=20) {
    if (x > 1) {
        for (i = [1:x-1]) {
            translate([i * module_size, 0, 0]) {
                groove_bar_y(y, fn=fn);
            }
        }
    }
    if (y > 1) {
        for (i = [1:y-1]) {
            translate([0, i * module_size, 0]) {
                groove_bar_x(x, fn=fn);
            }
        }
    }
}

// use <grid.scad>
// color([1,0,0]) grid_shape();
// groove_bar_vertical();

groove(x=x, y=y);
