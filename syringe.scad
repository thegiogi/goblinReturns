include <shortcuts.scad>
syr_OD=20;
syr_body_h=80;
noz_h=10;
noz_OD=4;
pis_OD=18;
pis_body_h=80;
syr_flap_th=3;
syr_flap_r=10;
module syringe(c){
//main body
minkowski(){
Cy(syr_OD/2-1   , syr_body_h-1);
Sp(0.5);
}
//nozzle
Tz(syr_body_h/2+noz_h/2)Cy(noz_OD/2,noz_h);
//flaps (wings? I don't know...)
Tz(-syr_body_h/2)l_e(syr_flap_th)hull(){
Tx(syr_OD/2)Ci(syr_flap_r);
Tx(-syr_OD/2)Ci(syr_flap_r);
}
//piston
Tz(-syr_body_h-c){
    minkowski(){
    Cy(pis_OD/2-1   , pis_body_h-1);
    Sp(0.5);
    }
    Tz(-pis_body_h/2)Cy(pis_OD/2*1.2,syr_flap_th);
}
}
