// I needed a box to put my end mills in.  I wanted to keep them in the
// packaging they ship with since that packaging has fairly clear and easy to
// ready labelling so the holes are not your typical round ones.
//
// This also means that the mills are a bit loose in the box so I needed a
// cover that would have a decently tight fit so when I knocked it around in my
// car they would not scatter all over.
//
use <MCAD/shapes.scad>;

// The font came from: http://www.thingiverse.com/thing:22730
//
use <font_DesignerBlock_med.scad>;

padding = 0.01;

// These parameters drive the actual box's size.
//
thickness = 3;
// bit_max_h = 82;
bit_max_h = 95;
bit_min_h = 50;
// bit_max_h = 20; // test height
// bit_min_h = 15; // test height
bit_hole_l = 14;
lbl_text = "Scanners end mills";
// lbl_text = "S";
bit_rows = 3;
bits_per_row = 8;

inter_bit_spacing = 3;
inter_row_spacing = 3;

top_overlap = 7;

bottom_h = bit_min_h + thickness;
top_h = bit_max_h - bit_min_h + thickness + top_overlap;

end_mill_holes_w = ((bit_rows-1) * (bit_hole_l + inter_row_spacing));
end_mill_holes_l = ((bits_per_row-1) * (bit_hole_l + inter_bit_spacing));

box_w = (thickness * 2) + (bit_rows * (bit_hole_l + inter_row_spacing));
box_l = (thickness * 2) + (bits_per_row * (bit_hole_l + inter_bit_spacing));

//////////////////////////////////////////////////////////////////////////////
//
module end_mill_hole() {
    roundedBox(bit_hole_l, bit_hole_l, bit_max_h, 1);
}

//////////////////////////////////////////////////////////////////////////////
//
module box_bottom() {
    difference() {
        translate([0,0,bottom_h/2]) {
            roundedBox(box_l, box_w, bottom_h, 10);
        }

        // Holes for our end mills. We keep our end mills in the packaging we
        // get them in because that has nice writing on it.
        //
        translate([0,0,bit_max_h/2 + thickness]) {
            end_mill_holes();
        }

        // and the inner lip to interlock with the top
        //
        // translate([0,0,((top_h - bottom_h)/2) + (bottom_h - top_overlap)]) {
        translate([0,0,(top_h/2) + (bottom_h - top_overlap)]) {
            rotate([0,180,0]) {
                translate([0,0,-(top_h/2)]) {
                    box_top(fudge = -0.2);
                }
            }
        }
    }
}

//////////////////////////////////////////////////////////////////////////////
//
module box_top(fudge = 0) {
    difference() {
       translate([0,0,top_h/2]) {
        roundedBox(box_l + padding , box_w + padding, top_h, 10);
       }

       // The cutout for the lip that interlocks with the bottom
       //
       translate([0,0, (top_h/2) + (top_h - top_overlap - thickness - 2) ]) {
           roundedBox(box_l - thickness + fudge, box_w - thickness + fudge,
               top_h, 10);
       }
       // Holes for our end mills. We keep our end mills in the packaging we
       // get them in because that has nice writing on it.
       //
        translate([0,0, (bit_max_h / 2) + thickness]) {
            end_mill_holes();
        }
    }
}

//////////////////////////////////////////////////////////////////////////////
//
module top_and_bottom() {
   // translate([0, -((box_w / 2) + 2.5), bottom_h/2]) {
   translate([0, -((box_w / 2) + 2.5), 0]) {
        box_bottom();
   }

    // this is a kludge.. because we have the text -padding below the xy plane
    // we need to basically clip everything downbelow that plane to make sure
    // our slicer and printer do not think the print head is 0.01 mils in to
    // the print bed..
    //
    difference() {
        translate([0, (box_w / 2) + 2.5,0]) {
            box_top();
        }
        // translate([0,0,-padding]) {
        //     box_top_label( y_off = (box_w / 2) + 2.5);
        // }
        translate([0,box_w/2 + 2.5,-(5+padding)]) {
            box(box_l, box_w, 10);
        }
    }
}

//////////////////////////////////////////////////////////////////////////////
//
module box_top_label(size = 5.0, y_off = 0) {
    translate([0, y_off,1]) {
        rotate([180,0,0]) {
            label(lbl_text, size = size);
        }
    }
}

//////////////////////////////////////////////////////////////////////////////
//
module top() {
    // this is a kludge.. because we have the text -padding below the xy plane
    // we need to basically clip everything downbelow that plane to make sure
    // our slicer and printer do not think the print head is 0.01 mils in to
    // the print bed..
    //
    difference() {
        box_top();

        // subtract out where the label is printed.
        translate([0,0,-padding]) {
            box_top_label(y_off = 4);
        }

        // Clipping below the platform to make sure we are not
        // printing below the platform.
        //
        translate([0,0,-(5+padding)]) {
            box(box_l, box_w, 10);
        }
    }
}

//////////////////////////////////////////////////////////////////////////////
//
module bottom() {
   translate([0, 0, 0]) {
        box_bottom();
   }
}

//////////////////////////////////////////////////////////////////////////////
//
// the grid of end mill holes centered on 0,0,0
//
module end_mill_holes() {
    translate([-(end_mill_holes_l/2),-(end_mill_holes_w/2),0]) {
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

///////////////
///////////////
//
// To generate .stl files for dualstrusion first generate the
// 'top_and_bottom()' then comment that out and uncomment 'box_top_label()' and
// generate the label STL.
//
//top();
// box_top_label( y_off = 4);                 // bottom and top by themselves
bottom();
//

// end_mill_holes();
// box_bottom();
// box_top();

// If you are printing a smaller box you can print both the top and bottom at
// the same time.
//
// top_and_bottom();
// box_top_label( y_off = (box_w / 2) + 2.5); // top_and_bottom printed together
