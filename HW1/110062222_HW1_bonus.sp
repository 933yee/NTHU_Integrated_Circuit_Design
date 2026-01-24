** 110062222_HW1_bonus **
** Environment setting **
*************************
.protect
.lib "/usr/cad/cic018.l" tt
.unprotect
*************************

.global vdd vss
Vdd vdd 0 DC=+1.8v
Vgnd vss 0 DC=0v

*** Inverter ***
.subckt INV in1 inv_out vdd vss
mp1 vdd in1 inv_out vdd P_18 w=0.5u l=0.18u
mn1 inv_out in1 vss vss N_18 w=0.25u l=0.18u
.ends

*** Transmission Gate ***
.subckt Transmission S input OUT vdd vss
Xinv S S_inv vdd vss INV
mp1 input S_inv OUT vdd P_18 w=0.5u l=0.18u
mn1 OUT S input vss N_18 w=0.25u l=0.18u
.ends

*** 2 to 1 MUX***
.subckt MUX_2to1 S0 D0 D1 Y vdd vss
Xinv S0 S0_inv vdd vss INV
Xtransmission1 S0_inv D0 Y vdd vss Transmission
Xtransmission2 S0 D1 Y vdd vss Transmission
.ends

*** 4 to 1 MUX ***
.subckt MUX S1 S0 D3 D2 D1 D0 Y vdd vss
Xmux1 S0 D0 D1 OUT1 vdd vss MUX_2to1
Xmux2 S0 D2 D3 OUT2 vdd vss MUX_2to1
Xmux3 S1 OUT1 OUT2 Y vdd vss MUX_2to1
.ends

Xmux S1 S0 D3 D2 D1 D0 OUT vdd vss MUX

Vin1 S1 vss pulse(0v 1.8v 0 1n 1n 512n 1024n)
Vin2 S0 vss pulse(0v 1.8v 0 1n 1n 256n 512n)
Vin3 D3 vss pulse(0v 1.8v 0 1n 1n 128n 256n)
Vin4 D2 vss pulse(0v 1.8v 0 1n 1n 64n 128n)
Vin5 D1 vss pulse(0v 1.8v 0 1n 1n 32n 64n)
Vin6 D0 vss pulse(0v 1.8v 0 1n 1n 16n 32n)

.tran 0.01n 1024n
.unprotect
.ten 30
.option post
.op
.end
