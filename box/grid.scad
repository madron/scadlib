include <constants.scad>
use <common.scad>

x = 4;
y = 4;


module grid_shape() {
    polygon(
        [
            [-grid_height,  0],
            [ 0, -grid_height],
            [ grid_height,  0],
        ]
    );
}


module edge_shape() {
    polygon(
        [
            [-grid_height,  0],
            [ 0, -grid_height],
            [ fillet, -grid_height],
            [ fillet,  0],
        ]
    );
}


module grid_bar_x(lenght=1) {
    rotate(a=[270, 0, 270]) {
        linear_extrude(lenght * module_size) grid_shape();
    }
}


module grid_bar_y(lenght=1) {
    rotate(a=[270, 0, 0]) {
        linear_extrude(lenght * module_size) grid_shape();
    }
}


module grid_trim(x=1, y=1, z=grid_height) {
    x = x * module_size;
    y = y * module_size;
    size = grid_height + 1;
    translate([0, 0, 0]) {
        difference() {
            translate([-size, -size, 0]) {
                cube([x + size * 2, y + size * 2, z]);
            }
            translate([0, 0, -1]) {
                cube([x, y, z + 2]);
            }
        }
    }
}


module raw_grid(x=1, y=1) {
    grid_bar_y(y);
    for (i = [1:x]) {
        translate([i * module_size, 0, 0]) {
            grid_bar_y(y);
        }
    }
    grid_bar_x(x);
    for (i = [1:y]) {
        translate([0, i * module_size, 0]) {
            grid_bar_x(x);
        }
    }
}


module grid_corner(fn=20) {
    rotate_extrude(angle=90, convexity=10, $fn=fn*2) {
        translate([fillet, 0, 0]) {
            rotate(a=[180, 0, 0]) {
                edge_shape();
            }
        }
    }
}


module grid_corners(x=2, y=2, fn=20) {
    x = x * module_size;
    y = y * module_size;
    offset = fillet;
    translate([ offset     ,  offset    , 0]) rotate(a=[0, 0, 180]) grid_corner(fn=fn);
    translate([ offset     , -offset + y, 0]) rotate(a=[0, 0, 90 ]) grid_corner(fn=fn);
    translate([-offset + x , -offset + y, 0]) rotate(a=[0, 0, 0  ]) grid_corner(fn=fn);
    translate([-offset + x ,  offset    , 0]) rotate(a=[0, 0, 270]) grid_corner(fn=fn);
}


module grid_bottom_mold(x=1, y=1, fn=20) {
    union() {
        translate([0, 0, -1]) grid_trim(x=x, y=y, z=grid_height + 1);
        grid_corners(x=x, y=y, fn=fn);
        grid(x=x, y=y, fn=fn);
        translate([0, 0, -1]) cube([x * module_size, y * module_size, 1]);
    }
}


module grid_bottom_mold_edge(x=1, y=1, fn=20) {
    x_size = x * module_size;
    y_size = y * module_size;
    union() {
        translate([0, 0, -1]) grid_trim(x=x, y=y, z=grid_height + 1);
        grid_corners(x=x, y=y, fn=fn);
        grid_bar_x(x);
        translate([0, y_size, 0]) grid_bar_x(x);
        grid_bar_y(y);
        translate([x_size, 0, 0]) grid_bar_y(y);
        translate([0, 0, -1]) cube([x * module_size, y * module_size, 1]);
    }
}


module grid_top_mold(x=1, y=1, z=0, fn=20) {
    x_size = x * module_size;
    y_size = y * module_size;
    offset = grid_height + 1;
    translate([0, 0, z - grid_height / 3 * 2])
        difference() {
            union() {
                translate([-offset, -offset, grid_height]) cube([x_size + offset * 2, y_size + offset * 2, offset]);
                cube_fillet(x=x_size, y=y_size, z=grid_height, side_radius=fillet);
            }
            grid_bottom_mold_edge(x=x, y=y, fn=fn);
        }
}


module grid(x=1, y=1, fn=20) {
    difference() {
        raw_grid(x=x, y=y);
        translate([0, 0, -1]) grid_trim(x=x, y=y, z=grid_height + 2);
    }
}



// grid_top_mold(x=x, y=y);

grid(x=x, y=y);
