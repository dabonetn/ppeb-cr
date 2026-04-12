// Defaults for curved surfaces
$fa=0.25; // default minimum facet angle is now 0.25
$fs=0.25; // default minimum facet size is now 0.25 mm

part=3; // 1=bottom, 2=top, 3=all (for display only)

screw=3.0; // Metric 3mm x 30mm screw
head=5.8;  // Space for the head of the screw
thread=0.2; // Subtracted for screw thread in top part

boff=4; // Bottom foot offset

// Do not edit:
smaller=30;
dd=3;  // Rounded corners diameter
sp=20; // Spaced from working area
extra=6.4; // +6.4 = actual 99/4A height
hi=17+1.5; // Adjust to actual TI console height

module board2(hh,di,s) {
    difference () {
        union() {
            translate([0-s/2,0-s/2,0]) cube([115.697+s,49.657+s,1.61]);
            translate([4,1,-9-16.2]) cube([115.697-6,49.657-1,11+16.2+hi-10]);
            translate([4,1,-9-16.2]) cube([115.697-8-smaller,49.657-1,11+16.2+hi-1.4]);
            translate([113,9,-9-16.2]) cube([35.697-23,47.657-15,15+hi]);
            translate([125,1,-9-16.2]) cube([35.697-6-smaller,49.657-1,15+hi]);
            hull() {
                translate([4+115.696-9-smaller,8,1.6]) cube([2,49.657-15,hi-1]);
                translate([4+115.696+33-smaller,8,1.6]) cube([2,49.657-15,hi-12.15]);
            }
            hull() {
                translate([4+104.696+3-smaller,1,1.6]) cube([2,49.657-1,hi-1]);
                translate([4+104.696+33-smaller,1,1.6]) cube([2,49.657-1,hi-9]);
            }
            translate([30.49,0,-7]) cube([68.5,57,17]);
            translate([30.49,-5,-2]) cube([68.5,62,6]);
            hull() {
                translate([39.5,57,10]) rotate([90,0,0]) cylinder(10,d=18);
                translate([39.5+35-18,57,10]) rotate([90,0,0]) cylinder(10,d=18);
                translate([39.5,57,10]) rotate([90,0,0]) cylinder(10,d=18);
                translate([39.5+35-18,57,10]) rotate([90,0,0]) cylinder(10,d=18);
            }
            difference() {
                translate([39.5+35-9.7,47,9.9]) cube([8,10,9]);
                translate([39.5+32.6,57.1,18.75]) rotate([90,0,0]) cylinder(10.2,d=18);
            }
        }
        translate ([0,26.797,-0.2]) cylinder(5,d=8.128-di);
    }
}

module screwhole(e) {
    translate ([11,10.7-50-sp,0])
    translate ([0,26.797,-0.2]) {
        cylinder(28.41,d=screw);
        translate([0,0,28.4]) cylinder(9.61,d=screw-e);
        translate([0,0,38]) cylinder(1,d1=screw-e,d2=0);
        translate([0,0,-0.1]) cylinder(4,d=head);
        translate([0,0,3.8]) cylinder(2,d1=head,d2=screw);
    }
}

module usbhole() {
    hull() {
        translate([127-7,   4.57+10,extra-5]) cube([1,14+16,33]);
        translate([127-7+47-smaller,4.57+20,18+extra]) hull() {
            translate([0,0,0]) sphere(d=dd);
            translate([0,0,7]) sphere(d=dd);
            translate([0,10,7]) sphere(d=dd);
            translate([0,10,0]) sphere(d=dd);
        }
    }
}

module bottom() {
    difference() {
        union () {
            hull() {
                translate([    dd/2+boff,      dd/2+boff, 0]) cylinder(10,d1=dd,d2=dd);
                translate([    dd/2,      dd/2,10]) cylinder(11.6+extra,d=dd);

                translate([    dd/2+boff,60.95-dd/2-boff, 0]) cylinder(10,d1=dd,d2=dd);
                translate([    dd/2,60.95-dd/2,10]) cylinder(11.6+extra,d=dd);

                translate([127-dd/2+40-smaller-boff,      dd/2+boff, 0]) cylinder(10,d1=dd,d2=dd);
                translate([127-dd/2+40-smaller,      dd/2,10]) cylinder(11.6+extra,d=dd);

                translate([127-dd/2+40-smaller-boff,60.95-dd/2-boff, 0]) cylinder(10,d1=dd,d2=dd);
                translate([127-dd/2+40-smaller,60.95-dd/2,10]) cylinder(11.6+extra,d=dd);
            }
        }
        usbhole();
    }
}

module top() {
    difference() {
        hull() {
            translate([    dd/2,      dd/2,21.6+extra]) cylinder(12+extra,d=dd);
            translate([    dd/2,60.95-dd/2,21.6+extra]) cylinder(12+extra,d=dd);

            translate([    dd/2,      dd/2,22+hi+extra]) sphere(d=dd);
            translate([    dd/2,60.95-dd/2,22+hi+extra]) sphere(d=dd);

            translate([119-dd/2-smaller,      dd/2,22+hi+extra]) sphere(d=dd);
            translate([119-dd/2-smaller,60.95-dd/2,22+hi+extra]) sphere(d=dd);

            translate([127-dd/2+40-smaller,      dd/2,12-1.6+hi+extra]) sphere(d=dd);
            translate([127-dd/2+40-smaller,60.95-dd/2,12-1.6+hi+extra]) sphere(d=dd);
            translate([127-dd/2+40-smaller,      dd/2,21.6+extra]) cylinder(extra,d=dd);
            translate([127-dd/2+40-smaller,60.95-dd/2,21.6+extra]) cylinder(extra,d=dd);
        }
        usbhole();
        translate([120-smaller,0+5,46.6]) rotate([0,14,0]) cube([10,60.95-10,3]);
    }
}

difference () {
    union() {
        translate ([4.5,-43.86-sp,0])
        {
            if (part == 1 || part == 3)
                bottom();
            if (part == 2 || part == 3)
                color("lightblue") top();
        }
    }
    translate ([11,10.7-50-sp,20+extra]) board2(1,0.5,0.4);
    screwhole(thread);
    translate ([120,20,0]) screwhole(thread);
    translate ([120,-22,0]) screwhole(thread);
}
