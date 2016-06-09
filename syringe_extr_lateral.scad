include <shortcuts.scad>
include <scad_utils\morphology.scad>
include <Bracket.scad>
include <syringe.scad>
//include <StepMotor.scad>
//mostra portasiringa
srg_hold=0;
//mostra bracket
brkt=0;
//mostra attuatore
actuator=1;
//mostra siringa
estetica=0;
//mostra struttra palo filettato
thr_rod=0;



x=[1,0,0];
y=[0,1,0];
z=[0,0,1];
//side wall
R_wall=30;
l_wall=30;
syr_flap_w=3;
syr_flap_h=2*syr_flap_r;
wall_th=5;
syr_hold_margin_in_syr_w=3 ;
syr_len_to_flaps=R_wall+l_wall-syr_hold_margin_in_syr_w*syr_flap_w;
round_r=5;
syr_axis_h=R_wall-syr_flap_h/2;
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
if (srg_hold){
sidesandbottom();
}
//aggiungo la siringa. nota che alcuni parametri della siringa sono ora parte di questo modello, ma non tutti! bisogna collegare lo spessore della fessura e altri parametri.

if (estetica) {
Tz(syr_OD)
	Tx(-syr_body_h/2+syr_flap_th+l_wall-syr_hold_margin_in_syr_w*syr_flap_w)
		Ry(-90)
			Rz(90)
				syringe(-20+20*cos($t*360));
}

//piastra per azionamento (attuatore): versione 1: senza secondo palo
act_OD_1=25;
act_OD_2=15;
act_extra_d=10;
act_extra_d=(Bdia/2+tot_w/2) - (act_OD_1/2+act_OD_1/2);
act_tot_d=act_OD_1/2+act_OD_1/2 + act_extra_d;
act_th=10 ;
hold_tube_h=30;
nut_th=5 ;
//contrafforte
contr_th=4;
contr_h=hold_tube_h;
contr_w=act_tot_d;
bound_circle_r=7 ; 

module attuatore(){
D(){ 
	U(){
		l_e(act_th)
				hull(){
					Tx(act_tot_d/2)
						Ci(act_OD_1/2); //cerchio 1 per base
					Tx(-act_tot_d/2)
						Ci(act_OD_2/2); //cerchio 2 per base
				}
		Tx(act_tot_d/2)
			Tz(-hold_tube_h/2)
				Cy(act_OD_1/2,hold_tube_h); //tubo per secondo dado
		
		Tz(-contr_h/2)
			Cu(contr_w,contr_th,contr_h) ; //contrafforte

		}
	//fori per il dado e il palo
	
	
	Tz(act_th-nut_th)
		Tx(act_tot_d/2)
			l_e(nut_th)
				Ci(bound_circle_r,$fn=6); //dado superficie 
	Tz(-hold_tube_h)
		Tx(act_tot_d/2)
			l_e(nut_th)
				Ci(bound_circle_r,$fn=6); //dado in fondo al tubo
	
	Tx(act_tot_d/2)
		Cy(5,2*hold_tube_h);
	Tx(-contr_w/2) //incavo ellittico contrafforte
		Tz(-contr_h)
			resize([contr_w+act_extra_d,contr_th*1.1,2*contr_h])
				Rx(90)
					Cy(contr_h,contr_th);

}

}

//altezza dell'asse del motore rispetto alla base del supporto:
mot_ax_h=-eps +MBD/2+Bthick-SBO;

//alzo bracket e attuatore in modo che siano entrambi a livello con la siringa
Tz(syr_axis_h-mot_ax_h){
	if (actuator){
	//attuatore
	T(100+20*cos($t*360),-act_tot_d/2,mot_ax_h)
		Rx(90)
			Ry(270)
				attuatore();
		}
	//Bracket per il motore
	if (brkt){
	Ty(-Bdia/2-tot_w/2)
		Tz(-eps +MBD/2+Bthick)
			Tx(20-Bthick/2)
				R(0,90,0){
					bracket();
					MOT();
					}
			}
}
// aggiungo un ulteriore spessore alla base del motore
if (brkt){
Tz(syr_axis_h-mot_ax_h+Bthick)
	Ty(-tot_w/2)
		mirror(y)
			Ry(90)
				cube([syr_axis_h-mot_ax_h+Bthick,Bdia,20]); 
		}

//il palo filettato
thr_rod_OD=8;
thr_rod_l=150;
thr_rod_supp_r=12;
thr_rod_supp_th=10;
bearing_r=9;
if (thr_rod){
Tx(thr_rod_l/2+20)
	Ty(-Bdia/2-tot_w/2)
		Tz(syr_axis_h)
			Ry(90){
				//il palo
				Cy(thr_rod_OD/2,thr_rod_l);
				//il supporto per il palo filettato
				Tz(thr_rod_l*0.5*0.75){
					l_e(thr_rod_supp_th){
						Ci(thr_rod_supp_r);
						Tx(syr_axis_h/2)
							Sq(syr_axis_h,2*thr_rod_supp_r);
						}
					Tz(thr_rod_supp_th)
						D(){
							Cy(thr_rod_supp_r,thr_rod_supp_th);
							Cy(bearing_r,thr_rod_supp_th);
							}
					}
				}
}
