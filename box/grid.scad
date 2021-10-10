include <constants.scad>

x = 1;
y = 1;

module grid_shape() {
    polygon(
        [
            [-2,  0],
            [ 0, -2],
            [ 2,  0],
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

module grid_trim(x=1, y=1) {
    size = 10;
    translate([0, 0, -1]) {
        difference() {
            translate([-size, -size, 0]) {
                cube([x * module_size + size * 2, y * module_size + size * 2, size]);
            }
            translate([0, 0, -1]) {
                cube([x * module_size, y * module_size, size + 2]);
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

module grid(x=1, y=1) {
    difference() {
        raw_grid(x=x, y=y);
        grid_trim(x=x, y=y);
    }
}

grid(x=x, y=y);
