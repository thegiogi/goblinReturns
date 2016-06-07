include <shortcuts.scad>
include <scad_utils\morphology.scad>
include <Bracket.scad>
//include <StepMotor.scad>
x=[1,0,0];
y=[0,1,0];
z=[0,0,1];
//side wall
R_wall=30;
l_wall=30;
syr_flap_w=3;
syr_flap_h=20;
wall_th=5;
syr_len_to_flaps=30;
round_r=5;
module side()
{
    l_e(wall_th)
    D(){
        
        U(){
            //creo parte circolare
            Rz(180)CiS(R_wall);
            //creo parte quadrata
            Tx(l_wall/2-round_r)Ty(-R_wall/2)rounding(round_r)Sq(l_wall+2*round_r,R_wall);
            }
            //creo il taglio per i flap della siringa, la distanza è calcolata dal bordo ricurvo
        Tx(syr_len_to_flaps+syr_flap_w/2-R_wall)Ty(-syr_flap_h/2)Sq(syr_flap_w,syr_flap_h);
        }
    echo("Lunghezza parete =" ,R_wall+l_wall);
}

//two sides
tot_w=30;

module both_sides(){
Tz(R_wall)U(){
    Ty(tot_w/2)Rx(90)side();
    mirror(y)Ty(tot_w/2)Rx(90)side();
}
}

//both_sides();


//bottom + curved bottom surface
module sidesandbottom(){
U(){
    both_sides();
    Tz(R_wall)Rx(90)RiS(R_wall,R_wall-wall_th,tot_w,180,270);
    Tz(wall_th/2)Tx(l_wall/2)Cu(l_wall,tot_w,wall_th);
}
}
sidesandbottom();

//aggiungiamo la base per il motore
mot_base_len=100;
mot_base_w=Bdia;
module mot_base(){
Tx(mot_base_len/2+l_wall-round_r/2)l_e(wall_th)rounding(round_r)Sq(mot_base_len+round_r,mot_base_w);
}
mot_base();

//qui c'è la montatura specifica per il byj48

//Tx(R_wall+l_wall)Tz(MBD/2+wall_th)Ry(90)Rz(0)StepMotor28BYJ();
Tx(l_wall+mot_base_len)Tz(MBFNW2+wall_th)Ry(90){
    
    rotate([180,0,0]) bracket();  // show the motor bracket
rotate([180,0,0])translate([0,0,-MBH/2]) 
 rotate([180,0,0]) StepMotor28BYJ();
}
