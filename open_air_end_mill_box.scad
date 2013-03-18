
use <MCAD/shapes.scad>;
$fn = 40;

// These parameters drive the actual box's size.
//
thickness = 3;
// bit_max_h = 82;
bit_max_h = 95;
bit_min_h = 50;
// bit_max_h = 20; // test height
// bit_min_h = 15; // test height
bit_hole_l = 14;
// lbl_text = "Scanners end mills";
 lbl_text = "S";
bit_rows = 3;
bits_per_row = 7;

inter_bit_spacing = 10;
inter_row_spacing = 5;

top_overlap = 7;

bottom_h = bit_min_h + thickness;
top_h = bit_max_h - bit_min_h + thickness + top_overlap;

box_w = (thickness * 2) + (bit_rows * (bit_hole_l + inter_row_spacing));
box_l = (thickness * 2) + (bits_per_row * (bit_hole_l + inter_bit_spacing));


// rotate([90,0,0]) {
//     ellipsoid(10, 50, center = true);
// }


//////////////////////////////////////////////////////////////////////////////
//
module end_mill_hole() {
    roundedBox(bit_hole_l, bit_hole_l, bit_max_h, 1);
}

//////////////////////////////////////////////////////////////////////////////
//
module box_bottom() {
    difference() {
        // roundedBox(box_l, box_w, bit_min_h + thickness, 10);
        // translate([0,0,((top_h - bottom_h)/2) + (bottom_h - top_overlap)]) {
        //     rotate([0,180,0]) {
        //         box_top(fudge = -0.2);
        //     }
        // }

        translate([-((box_l/2) - bit_hole_l-1),
                -((box_w/2) - bit_hole_l+1),
                ((bit_max_h/2) - (bottom_h/2)) +  thickness]) {
            union() {
                for( i = [0:bit_rows-1] ) {
                    for( j = [0:bits_per_row-1] ) {
                        translate([ j * (bit_hole_l + inter_bit_spacing),
                                i * (bit_hole_l + inter_row_spacing), 0]) {
                            rotate([90,0,0]) {
                                ellipsoid(bit_hole_l+12, bit_max_h+50, center = true);
                            }
                            // end_mill_hole();
                        }
                    }
                }
            }
        }

        // Holes for our end mills. We keep our end mills in the packaging we
        // get them in because that has nice writing on it.
        //
        translate([-((box_l/2) - bit_hole_l-1),
                -((box_w/2) - bit_hole_l+1),
                ((bit_max_h/2) - (bottom_h/2)) +  thickness]) {
            for( i = [0:bit_rows-1] ) {
                for( j = [0:bits_per_row-1] ) {
                    translate([ j * (bit_hole_l + inter_bit_spacing),
                            i * (bit_hole_l + inter_row_spacing), 0]) {
                        end_mill_hole();
                    }
                }
            }
        }
    }
}

//////////////////////////////////////////////////////////////////////////////
//
module bottom() {
    intersection() {
        translate([0, 0, bottom_h/2]) {
            box_bottom();
        }
        translate([0,0, bottom_h/2]) {
            cube([box_l, box_w, bottom_h], center = true);
        }
    }
}

bottom();