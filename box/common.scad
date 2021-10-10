use <Round-Anything/polyround.scad>


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
