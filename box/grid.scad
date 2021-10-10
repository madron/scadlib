include <constants.scad>

x = 1;
y = 1;


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


module grid_edge(fn=20) {
    rotate_extrude(angle=90, convexity=10, $fn=fn) {
        translate([fillet, 0, 0]) {
            rotate(a=[180, 0, 0]) {
                edge_shape();
            }
        }
    }
}


module grid_edges(x=2, y=2, fn=20) {
    translate([fillet                      , fillet                   , 0]) rotate(a=[0, 0, 180]) grid_edge(fn=fn);
    translate([fillet                      , -fillet + y * module_size, 0]) rotate(a=[0, 0, 90 ]) grid_edge(fn=fn);
    translate([-fillet + x * module_size   , -fillet + y * module_size, 0]) rotate(a=[0, 0, 0  ]) grid_edge(fn=fn);
    translate([-fillet + x * module_size   , fillet                   , 0]) rotate(a=[0, 0, 270]) grid_edge(fn=fn);
}


module grid(x=1, y=1, fn=20) {
    difference() {
        raw_grid(x=x, y=y);
        grid_trim(x=x, y=y);
    }
}


// grid_edges(x=x, y=y);

grid(x=x, y=y);
