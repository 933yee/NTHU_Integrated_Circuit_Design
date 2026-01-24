** 110062222_HW2 **
** Environment setting **
*************************
.protect
.lib "/usr/cad/cic018.l" tt  
.unprotect
*************************

*.include "Inv.cir"
*.include "Xor.cir"

.global VDD GND
Vdd VDD 0 DC=+1.8v
Vgnd GND 0 DC=0v

.subckt Inv in1 inv_out VDD GND
mp1 inv_out in1 VDD VDD P_18 w=1.2u l=0.18u
mn1 inv_out in1 GND GND N_18 w=0.6u l=0.18u
.ends


.subckt Xor A B C S VDD GND
** inv
        Xinv1 A A_inv VDD GND Inv
        Xinv2 B B_inv VDD GND Inv
        Xinv3 C C_inv VDD GND Inv
** pmos
        mp1 P_A_inv_out A_inv VDD VDD P_18 w=1.2u l=0.18u
        mp2 P_A_out A VDD VDD P_18 w=1.2u l=0.18u
        mp3 P_B_out_L B P_A_out VDD P_18 w=1.2u l=0.18u
        mp4 P_B_out_R B P_A_inv_out VDD P_18 w=1.2u l=0.18u
        mp5 P_B_out_L B_inv P_A_inv_out VDD P_18 w=1.2u l=0.18u
        mp6 P_B_out_R B_inv P_A_out VDD P_18 w=1.2u l=0.18u
        mp7 S C_inv P_B_out_L VDD P_18 w=1.2u l=0.18u
        mp8 S C P_B_out_R VDD P_18 w=1.2u l=0.18u
** npos
        mn1 N_A_out A GND GND N_18 w=0.6u l=0.18u
        mn2 N_A_inv_out A_inv GND GND N_18 w=0.6u l=0.18u
        mn3 N_B_out_L B N_A_out GND N_18 w=0.6u l=0.18u
        mn4 N_B_out_R B N_A_inv_out GND N_18 w=0.6u l=0.18u
        mn5 N_B_out_L B_inv N_A_inv_out GND N_18 w=0.6u l=0.18u
        mn6 N_B_out_R B_inv N_A_out GND N_18 w=0.6u l=0.18u
        mn7 S C_inv N_B_out_L GND N_18 w=0.6u l=0.18u
        mn8 S C N_B_out_R GND N_18 w=0.6u l=0.18u
.ends


*** Logic Circuit Instantiation ***
Xxor A B C S VDD GND Xor

*** Input Signals ***
Vin1 A GND PULSE(0v 1.8v 2.5n 10p 10p 2.5n 5n)
Vin2 B GND PULSE(0v 1.8v 5n 10p 10p 5n 10n)
Vin3 C GND PULSE(0v 1.8v 10n 10p 10p 10n 20n)

*** Load Capacitor ***
Cload S GND 0.005pF

.tran 0.01n 50n
.measure tran power AVG POWER
.meas tran Delay1_XOR trig v(A) val=0.9 fall=4 targ v(S) val=0.9 fall=3
.meas tran Delay2_XOR trig v(A) val=0.9 rise=1 targ v(S) val=0.9 rise=1
.unprotect
.ten 30
.option post
.op
.end
