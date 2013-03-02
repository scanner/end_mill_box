// I needed a box to put my end mills in.  I wanted to keep them in the
// packaging they ship with since that packaging has fairly clear and easy to
// ready labelling so the holes are not your typical round ones.
//
// This also means that the mills are a bit loose in the box so I needed a
// cover that would have a decently tight fit so when I knocked it around in my
// car they would not scatter all over.
//
use <MCAD/shapes.scad>;
use <font_DesignerBlock_med.scad>;

padding = 0.05;

// These parameters drive the actual box's size.
//
thickness = 2;
bit_max_h = 82;
bit_min_h = 46;
bit_hole_l = 11.5;

bit_rows = 3;
bits_per_row = 8;

inter_bit_spacing = 10;
inter_row_spacing = 5;

cover_overlap = 15;
cover_lip_w = 1.5;

bottom_h = bit_min_h;

//////////////////////////////////////////////////////////////////////////////
//
// so we can easily access the width and length of the boxes outside of the
// modules that generate the box so that we can use these to place them
// centered in the print bed.
//
function box_w() = (thickness * 2) + (bit_rows * (bit_hole_l + inter_row_spacing);
function bow_l() = (thickness * 2) + (bits_per_row * (bit_hole_l + inter_bit_spacing);

//////////////////////////////////////////////////////////////////////////////
//
module box_bottom() {
    roundedBox(box_l(), bit_min_h + thickness, box_w(), 10);
}

//////////////////////////////////////////////////////////////////////////////
//
module box_top() {
    difference() {
        roundedBox(box_l(), bit_max_h - bit_min_h + thickness, box_w(), 10);
        translate([0,0,thickness]) {
            roundedBox(box_l() - thickness, bit_max_h - bit_min_h + padding,
                       box_w() - thickness, 10);
        }

}

//////////////////////////////////////////////////////////////////////////////
//
module top_and_bottom() {
    translate([-((box_w() / 2) + 2.5), 0, 0]) {
        box_bottom();
    }
    translate([(box_w() / 2) + 2.5, 0, 0]) {
        box_top();
    }
}

top_and_bottom();
