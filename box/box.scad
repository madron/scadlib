include <Round-Anything/polyround.scad>

$fn=20;

x = 30;
y = 40;
z = 10;
bottom = 0.8;
side = 0.8;
fillet = 2;


module box(x, y, z, bottom=1, side=1, fillet=0) {
    internal_x = x - side * 2;
    internal_y = y - side * 2;
    internal_z = z;
    difference() {
        cube_fillet(x, y, z, side_radius=fillet + side);
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

box(x=x, y=y, z=z, bottom=bottom, side=side, fillet=fillet);
