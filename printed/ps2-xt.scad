case_thickness=1.6;
tolerance=0.1;
$fn=72;

board_width=0.925*25.4;
board_length=1.925*25.4;
component_height=21.0; // DIN-5 connector
board_thickness=1.6; // check if it's correct
component_leads=2; // component leads sticking out on the bottom side of the PCB
din5_width=20.5;
din5_height=21.0;
minidin6_width=14;
minidin6_height=13;
switch_width=4;
switch_height=2;
switch_y=board_length/2-0.9875*25.4;
switch_z=3.9;
standoff_radius=2.2;
standoff_width=tolerance+0.1*25.4;
standoff1_x=-board_width/2+0.825*25.4;
standoff1_y=board_length/2-0.4*25.4;
standoff2_x=-board_width/2+0.1*25.4;
standoff2_y=board_length/2-1.15*25.4;
// #2-56 UNC screw... Pretty close to M2
screw_thread=2;
screw_diameter=2.4; // 0.086*25.4 =2.1844 mm
screw_head_height=0.051*25.4;
screw_head_diameter=0.162*25.4;
text_thickness=0.2; // one 3D printer layer


case_width=board_width+tolerance*2;
case_length=board_length+tolerance*2;
case_height=component_height+board_thickness+component_leads+tolerance*2;
case_bottom_height=board_thickness+component_leads+tolerance;
case_top_height=component_height+tolerance;
overlap_width=0.8;
overlap_height=0.2;
top_bottom_overlap=0.4;

// comment out functions below to draw specific parts only
case_top();
color("cyan") case_bottom();
translate([0,0,case_top_height+case_thickness-text_thickness]) {
    color("blue") case_label();
}

module case_label()
{
    rotate([0,0,-90]) {
        linear_extrude(text_thickness) {
            text("PS/2 to XT",size=7,font = "Bahnschrift",halign="center",valign= "center");
        }
    }
}

// axis orientation: X-Y - bottom/top, X-Z - front/back, Y-Z - left/right
module case_top()
{        
    // move above X-Y plane
    translate([0,0,(case_top_height+case_thickness)/2]) {
        difference() {
            union() {
                color("silver") {
                    translate([0,0,-overlap_height/2]) rotate([180,0,0]) {
                        case_shell(case_width,case_length,case_top_height+overlap_height,case_thickness,case_thickness/2);
                    }
                    // standoff - far / righ
                    translate([standoff1_x,standoff1_y,-case_thickness/2]) {
                        cylinder(h=case_top_height,r=standoff_radius,center=true);
                        translate([standoff_width/2,0,0]) {
                            cube([standoff_width,standoff_radius*2,case_top_height],center=true);
                        }
                    }
                    // standoff - near / left
                    translate([standoff2_x,standoff2_y,-case_thickness/2]) {
                        cylinder(h=case_top_height,r=standoff_radius,center=true);
                        translate([-standoff_width/2,0,0]) {
                            cube([standoff_width,standoff_radius*2,case_top_height],center=true);
                        }
                    }
                }
            }
            // MiniDIN-6 cutout
            translate([0,(case_length+case_thickness)/2,(minidin6_height-case_top_height-case_thickness-overlap_height)/2]) {
                cube([minidin6_width+tolerance*2,case_thickness+tolerance*2,minidin6_height+overlap_height+tolerance],center=true);
            }
            // DIN-5 cutout
            translate([0,-(case_length+case_thickness)/2,(din5_height-case_top_height-case_thickness-overlap_height)/2]) {
                cube([din5_width+tolerance*2,case_thickness+tolerance*2,din5_height+overlap_height+tolerance],center=true);
            }
            // switch cutout
            translate([(case_width+case_thickness)/2,switch_y,(switch_height/2+tolerance+switch_z-case_top_height-case_thickness-top_bottom_overlap)/2]) {
                cube([case_thickness+tolerance*2,switch_width+tolerance*2,switch_height/2+top_bottom_overlap+tolerance+switch_z],center=true);
            }
            // screw hole - far / right
            translate([standoff1_x,standoff1_y,-case_thickness/2-tolerance]) {
                cylinder(h=case_top_height,d=screw_thread,center=true);
            }
            // screw hole - near / left
            translate([standoff2_x,standoff2_y,-case_thickness/2-tolerance]) {
                cylinder(h=case_top_height,d=screw_thread,center=true);
            }
            // label
            translate([0,0,(case_top_height+case_thickness)/2-text_thickness]) {
                case_label();
            }
            // overlap cut-out
            translate([0,0,-(case_top_height+case_thickness+overlap_height+tolerance)/2]) {
                cube([case_width+overlap_width*2,case_length+overlap_width*2,overlap_height+tolerance],center=true);
            }
        }
    }
}

module case_bottom()
{
    // move below X-Y plane
    translate([0,0,-(case_bottom_height+case_thickness)/2]) {
        difference() {
            union() {
                case_shell(case_width,case_length,case_bottom_height,case_thickness,case_thickness/2);
                // standoff - far / righ
                translate([standoff1_x,standoff1_y,(case_bottom_height-case_thickness-board_thickness)/2-tolerance*2]) {
                    cylinder(h=case_bottom_height-board_thickness,r=standoff_radius,center=true);
                    translate([standoff_width/2,0,0]) {
                        cube([standoff_width,standoff_radius*2,case_bottom_height-board_thickness],center=true);
                    }
                }
                // standoff - near / left
                translate([standoff2_x,standoff2_y,(case_bottom_height-case_thickness-board_thickness)/2-tolerance*2]) {
                    cylinder(h=case_bottom_height-board_thickness,r=standoff_radius,center=true);
                    translate([-standoff_width/2,0,0]) {
                        cube([standoff_width,standoff_radius*2,case_bottom_height-board_thickness],center=true);
                    }
                }
            }
            // screw hole - far / right
            translate([standoff1_x,standoff1_y,-board_thickness/2]) {
                cylinder(h=case_bottom_height+case_thickness-board_thickness+tolerance*2,d=screw_diameter,center=true);
            }

            //screw head countersink hole
            translate([standoff1_x,standoff1_y,-(case_bottom_height+case_thickness-screw_head_height)/2]) {
                cylinder(h=screw_head_height,d1=screw_head_diameter,d2=screw_diameter,center=true);
            }

            // screw hole - near / left
            translate([standoff2_x,standoff2_y,-board_thickness/2]) {
                cylinder(h=case_bottom_height+case_thickness-board_thickness+tolerance*2,d=screw_diameter,center=true);
            }
            
            //screw head countersink hole
            translate([standoff2_x,standoff2_y,-(case_bottom_height+case_thickness-screw_head_height)/2]) {
                cylinder(h=screw_head_height,d1=screw_head_diameter,d2=screw_diameter,center=true);
            }
            // overlap cut-out
            // right
            translate([(case_width+case_thickness+overlap_width)/2,0,(case_bottom_height+case_thickness-overlap_height+tolerance)/2]) {
                cube([overlap_width,case_length+case_thickness*2,overlap_height+tolerance],center=true);
            }         
            // left
            translate([-(case_width+case_thickness+overlap_width)/2,0,(case_bottom_height+case_thickness-overlap_height+tolerance)/2]) {
                cube([overlap_width,case_length+case_thickness*2,overlap_height+tolerance],center=true);
            }
            // far
            translate([0,(case_length+case_thickness+overlap_width)/2,(case_bottom_height+case_thickness-overlap_height+tolerance)/2]) {
                cube([case_width+case_thickness*2,overlap_width,overlap_height+tolerance],center=true);
            }
            // near
            translate([0,-(case_length+case_thickness+overlap_width)/2,(case_bottom_height+case_thickness-overlap_height+tolerance)/2]) {
                cube([case_width+case_thickness*2,overlap_width,overlap_height+tolerance],center=true);
            }
        }
        // switch cutout cover
        translate([(case_width+case_thickness)/2,switch_y,(case_bottom_height+case_thickness+switch_z-switch_height/2-overlap_height-tolerance)/2]) {
            cube([case_thickness,switch_width+tolerance*2,switch_z-switch_height/2+overlap_height-tolerance],center=true);
        }
        // MiniDIN-6 cutout cover
        translate([0,(case_length+case_thickness)/2,(case_bottom_height+case_thickness-overlap_height)/2]) {
            cube([minidin6_width+tolerance*2,case_thickness+tolerance*2,overlap_height],center=true);
        }
        // DIN-5 cutout cover
        translate([0,-(case_length+case_thickness)/2,(case_bottom_height+case_thickness-overlap_height)/2]) {
            cube([din5_width+tolerance*2,case_thickness+tolerance*2,overlap_height],center=true);
        }
    }
}


// case shell with cut corners
// input: inside dimensions, thickness, depth for cut corners
module case_shell(width,length,height,thickness,cut)
{
    out_width = width+thickness*2;
    out_length = length+thickness*2;
    out_height = height+thickness;
    difference() {
        // rectangular prism for the outside of the shell
        cube([out_width,out_length,out_height],center=true);
        union() {
            // cutout for the inside of the shell
            translate([0,0,thickness/2+0.05]) {
                cube([width,length,height],center=true);
            }
            // cut bottom corners
            translate([0,out_length/2,-out_height/2]) {
                rotate([45,0,0]) {
                    cube([out_width,cut*sqrt(2),cut*sqrt(2)],center=true);
                }
            }
            translate([0,-out_length/2,-out_height/2]) {
                rotate([45,0,0]) {
                    cube([out_width,cut*sqrt(2),cut*sqrt(2)],center=true);
                }
            }
            translate([out_width/2,0,-out_height/2]) {
                rotate([45,0,90]) {
                    cube([out_length,cut*sqrt(2),cut*sqrt(2)],center=true);
                }
            }
            translate([-out_width/2,0,-out_height/2]) {
                rotate([45,0,90]) {
                    cube([out_length,cut*sqrt(2),cut*sqrt(2)],center=true);
                }
            }
            // cut side corners
            translate([out_width/2,out_length/2,0]) {
                rotate([0,0,45]) {
                    cube([cut*sqrt(2),cut*sqrt(2),out_height+0.1],center=true);
                }
            }
            translate([out_width/2,-out_length/2,0]) {
                rotate([0,0,45]) {
                    cube([cut*sqrt(2),cut*sqrt(2),out_height+0.1],center=true);
                }
            }
            translate([-out_width/2,out_length/2,0]) {
                rotate([0,0,45]) {
                    cube([cut*sqrt(2),cut*sqrt(2),out_height+0.1],center=true);
                }
            }
            translate([-out_width/2,-out_length/2,0]) {
                rotate([0,0,45]) {
                    cube([cut*sqrt(2),cut*sqrt(2),out_height+0.1],center=true);
                }
            }
        }
    }
}