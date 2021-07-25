// Utils from https://openhome.cc/eGossip/OpenSCAD/SectorArc.html
module sector(radius, angles, fn = 24) {
    r = radius / cos(180 / fn);
    step = -360 / fn;

    points = concat([[0, 0]],
        [for(a = [angles[0] : step : angles[1] - 360]) 
            [r * cos(a), r * sin(a)]
        ],
        [[r * cos(angles[1]), r * sin(angles[1])]]
    );

    difference() {
        circle(radius, $fn = fn);
        polygon(points);
    }
}

module arc(radius, angles, width = 1, fn = 24) {
    difference() {
        sector(radius + width, angles, fn);
        sector(radius, angles, fn);
    }
} 

// Creates a cylinder where the ends can be offset from the center line.
module offset_cylinder(h, r1, r2, o1 = 0, o2 = 0, s=0) {
    slices = s <= 0 ? round(h) : s;    
    thickness = h / slices;
    radius = (r2 - r1) / slices;
    offset = (o2 - o1) / slices;
    
    union() {
        for(i = [1 : slices + 1])
        {
            translate([0, o1 + (offset * i), thickness * (i - 1)])
                cylinder(h=thickness, r1=r1 + (radius * i), r2=r1 + (radius * (i+1)));
        }
    }
}