include <constants.scad>
use <common.scad>

x = 5;
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
// grid_shape();


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
// edge_shape();


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


module grid_trim(x=1, y=1) {
    x = x * module_size;
    y = y * module_size;
    z = grid_height;
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
// grid_trim(x=x, y=y);


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
// raw_grid(x=x, y=y);


module bottom_mold(x=1, y=1) {
    size_x = x * module_size;
    size_y = y * module_size;
    size = grid_height + 1;
    union() {
        translate([-size, -size, -size]) {
            cube([size_x + size * 2, size_y + size * 2, size]);
        }
        raw_grid(x=x, y=y);
        grid_trim(x=x, y=y);
    }
}
// bottom_mold(x=x, y=y);



module grid(x=1, y=1) {
    difference() {
        raw_grid(x=x, y=y);
        translate([0, 0, -1]) grid_trim(x=x, y=y);
    }
}


grid(x=x, y=y);
