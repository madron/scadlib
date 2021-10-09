include <Round-Anything/polyround.scad>
use <grid.scad>

x = 1;
y = 1;

/* [Hidden] */
module_size = 50;
module_height = 40;

bottom = 2;
side = 2;
fillet = 6;
tolerance = 0.1;

$fn=20;


module box(x=1, y=1) {
    difference() {
        raw_box(x=x * module_size, y=y * module_size, z=module_height, bottom=bottom, side=side, fillet=fillet);
        grid(x=x, y=y);
    }
}



module raw_box(x, y, z, bottom=1, side=1, fillet=0) {
    external_x = x - tolerance * 2;
    external_y = y - tolerance * 2;
    external_z = z;
    internal_x =  external_x - side * 2;
    internal_y =  external_y - side * 2;
    internal_z =  external_z;
    translate([tolerance, 0, 0])
        difference() {
            cube_fillet(external_x, external_y, external_z, side_radius=fillet + side);
            translate([side, side, bottom])
                cube_fillet(internal_x, internal_y, internal_z, side_radius=fillet, bottom_radius=fillet);

        };
}

module cube_fillet(x, y, z, side_radius=0, bottom_radius=0, top_radius=0, center=false, fn=30) {
    if (center) {
        radii_points = [
            [-x / 2, -y / 2, side_radius],
            [ x / 2, -y / 2, side_radius],
            [ x / 2,  y / 2, side_radius],
            [-x / 2,  y / 2, side_radius],
        ];
        polyRoundExtrude(radii_points, z, r1=top_radius, r2=bottom_radius, fn=fn);
    } else {
        radii_points = [
            [0, 0, side_radius],
            [0, y, side_radius],
            [x, y, side_radius],
            [x, 0, side_radius],
        ];
        polyRoundExtrude(radii_points, z, r1=top_radius, r2=bottom_radius, fn=fn);
    };
}

box(x=x, y=y);
