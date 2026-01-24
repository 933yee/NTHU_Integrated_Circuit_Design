** DCIM **
** Environment setting **
* .include "./testcases.sp"

* .tran 0.01n 26n
* .option POST
* .protect
* .lib "/usr/cad/cic018.l" tt
* .temp 30
* .unprotect

*********************
** Clock Parameter **
*********************
* .param    CLK_Period = 2n
* .param    CLK_Period_2 = 'CLK_Period/2'
* .param    r_time = 1p
* .param    f_time = 1p
* .param    SupplyV = 1.8v

* ********************
* * voltage setting **
* ********************
* .global vdd gnd
* Vvdd vdd 0 DC=+1.8v
* Vgnd gnd 0 DC=0v

**********************************************
*** Don't modify the pin name in this file ***
**********************************************

*** Inverter ***
.subckt INV in1 inv_out
mp1 vdd in1 inv_out vdd P_18 w=0.72u l=0.18u
mn1 inv_out in1 gnd gnd N_18 w=0.36u l=0.18u
.ends

*** AND ***
.subckt AND2 in4 in5 AND
Xnand in4 in5 nand_output NAND2
Xinv nand_output AND INV
.ends

*** NOR ***
.subckt NOR2 in1 in2 n1
mp1 vdd in1 n vdd P_18 w=0.72u l=0.18u
mp2 n in2 n1 vdd P_18 w=0.72u l=0.18u
mn1 n1 in1 gnd gnd N_18 w=0.36u l=0.18u
mn2 n1 in2 gnd gnd N_18 w=0.36u l=0.18u
.ends 

*** NAND ***
.subckt NAND2 in1 in2 n1
mp1 vdd in1 n1 vdd P_18 w=0.72u l=0.18u
mp2 vdd in2 n1 vdd P_18 w=0.72u l=0.18u
mn1 n in1 gnd gnd N_18 w=0.36u l=0.18u
mn2 n1 in2 n gnd N_18 w=0.36u l=0.18u
.ends

.subckt LATCH IN OUT
Xinv1 IN OUT INV
Xinv2 OUT IN INV
.ends

.subckt LATCH_MULT IN W OUT
* LATCH *
XLatch W W_inv LATCH
* MUL *
Xnor1 W_inv IN OUT NOR2
.ends

.subckt LATCH_MULT_4BIT W0 W1 W2 W3 IN OUT0 OUT1 OUT2 OUT3
Xinv In In_inv INV
Xlatch0 In_inv W0 OUT0 LATCH_MULT
Xlatch1 In_inv W1 OUT1 LATCH_MULT
Xlatch2 In_inv W2 OUT2 LATCH_MULT
Xlatch3 In_inv W3 OUT3 LATCH_MULT
.ends

*** Transmission Gate ***
.subckt TG S S_inv input OUT
mp1 input S_inv OUT vdd P_18 w=0.72u l=0.18u
mn1 OUT S input gnd N_18 w=0.36u l=0.18u
.ends

*** LATCH with TG ***
.subckt LATCH_TG IN CLK CLK_inv OUT
Xinv1 IN OUT INV
Xinv2 OUT OUT_inv INV
XTG CLK CLK_inv OUT_inv IN TG
.ends

.subckt FF D CLK RST Q
Xand1 D RST D_rst AND2
Xinv CLK CLK_inv INV
XTG1 CLK_inv CLK D_rst o1 TG
XLATCH_TG1 o1 CLK CLK_inv o1_inv LATCH_TG
XTG2 CLK CLK_inv o1_inv o2 TG 
XLATCH_TG2 o2 CLK_inv CLK Q LATCH_TG
.ends

*** Full Adder ***
.subckt FULL_ADDER A B C S Cout
Xinv1 A A_inv INV
Xinv2 C C_inv INV
mp1 A B P vdd P_18 w=0.72u l=0.18u
mn1 P B A_inv gnd N_18 w=0.36u l=0.18u
mp2 A_inv B P_inv vdd P_18 w=0.72u l=0.18u
mn2 P_inv B A gnd N_18 w=0.36u l=0.18u
Xtg1 A_inv A B P TG
Xtg2 A A_inv B P_inv TG

Xtg3 P_inv P C_inv S_inv TG
Xtg4 P P_inv C S_inv TG

Xtg5 P_inv P A_inv Cout_inv TG
Xtg6 P P_inv C_inv Cout_inv TG

Xinv3 S_inv S INV
Xinv4 Cout_inv Cout INV
.ends

*** 4-bit + 4-bit ＝ 5-bit ***
.subckt ADDER_4BIT A0 A1 A2 A3 B0 B1 B2 B3 Cin S0 S1 S2 S3 S4
Xfa0 A3 B3 Cin S4 c1 FULL_ADDER
Xfa1 A2 B2 c1 S3 c2 FULL_ADDER
Xfa2 A1 B1 c2 S2 c3 FULL_ADDER
Xfa3 A0 B0 c3 S1 S0 FULL_ADDER
.ends

*** 5-bit + 5-bit ＝ 6-bit ***
.subckt ADDER_5BIT A0 A1 A2 A3 A4 B0 B1 B2 B3 B4 Cin S0 S1 S2 S3 S4 S5
Xfa0 A4 B4 Cin S5 c1 FULL_ADDER
Xfa1 A3 B3 c1 S4 c2 FULL_ADDER
Xfa2 A2 B2 c2 S3 c3 FULL_ADDER
Xfa3 A1 B1 c3 S2 c4 FULL_ADDER
Xfa4 A0 B0 c4 S1 S0 FULL_ADDER
.ends

*** 10-bit adder ***
.subckt ADDER_10BIT A0 A1 A2 A3 A4 A5 A6 A7 A8 A9 B0 B1 B2 B3 B4 B5 B6 B7 B8 B9 Cin S0 S1 S2 S3 S4 S5 S6 S7 S8 S9
Xfa0 A0 B0 Cin S0 c1 FULL_ADDER
Xfa1 A1 B1 c1 S1 c2 FULL_ADDER
Xfa2 A2 B2 c2 S2 c3 FULL_ADDER
Xfa3 A3 B3 c3 S3 c4 FULL_ADDER
Xfa4 A4 B4 c4 S4 c5 FULL_ADDER
Xfa5 A5 B5 c5 S5 c6 FULL_ADDER
Xfa6 A6 B6 c6 S6 c7 FULL_ADDER
Xfa7 A7 B7 c7 S7 c8 FULL_ADDER
Xfa8 A8 B8 c8 S8 S9 FULL_ADDER
.ends

*** Main Circuit
.subckt Main I1 I2 I3 I4 CLK O0 O1 O2 O3 O4 O5 O6 O7 O8 O9 P0 P1 P2 P3 P4 P5 P6 P7 P8 P9 w0 w1 w2 w3 w4 w5 w6 w7 w8 w9 w10 w11 w12 w13 w14 w15 
* Step 1: Multiply each input (I1, I2, I3, I4) by the 4-bit weights (W)
Xlatch_mul_4bit1 w0 w1 w2 w3 I1 P1_0 P1_1 P1_2 P1_3 LATCH_MULT_4BIT
Xlatch_mul_4bit2 w4 w5 w6 w7 I2 P2_0 P2_1 P2_2 P2_3 LATCH_MULT_4BIT
Xlatch_mul_4bit3 w8 w9 w10 w11 I3 P3_0 P3_1 P3_2 P3_3 LATCH_MULT_4BIT
Xlatch_mul_4bit4 w12 w13 w14 w15 I4 P4_0 P4_1 P4_2 P4_3 LATCH_MULT_4BIT
* Step 2: Add I1's and I2's outputs (4-bit each) to get 5-bit
Xadd1 P1_0 P1_1 P1_2 P1_3 P2_0 P2_1 P2_2 P2_3 gnd S12_0 S12_1 S12_2 S12_3 S12_4 ADDER_4BIT
* Add I3's and I4's outputs (4-bit each) to get another 5-bit
Xadd2 P3_0 P3_1 P3_2 P3_3 P4_0 P4_1 P4_2 P4_3 gnd S34_0 S34_1 S34_2 S34_3 S34_4 ADDER_4BIT
* Step 3: Add the two 5-bit results to get 6-bit output (output6)
Xadd3 S12_0 S12_1 S12_2 S12_3 S12_4 S34_0 S34_1 S34_2 S34_3 S34_4 gnd O6_0 O6_1 O6_2 O6_3 O6_4 O6_5 ADDER_5BIT
* Step 4: Left shift the 10-bit value stored in Flip-Flop
* Step 5: Add the shifted 10-bit value and output6 (6-bit)
Xadd10 gnd O0 O1 O2 O3 O4 O5 O6 O7 O8 O6_5 O6_4 O6_3 O6_2 O6_1 O6_0 gnd gnd gnd gnd gnd P0 P1 P2 P3 P4 P5 P6 P7 P8 P9 ADDER_10BIT
.ends

.subckt CON_IN I1 I2 I3 I4 CLK IN_VAL OUT_VAL ii1 ii2 ii3 ii4
Xff1 I1 CLK vdd ii1 FF
Xff2 I2 CLK vdd ii2 FF
Xff3 I3 CLK vdd ii3 FF
Xff4 I4 CLK vdd ii4 FF
Xinv IN_VAL IN_VAL_inv INV  
Xff5 IN_VAL_inv CLK vdd OUT_VAL FF
.ends

.subckt CON_OUT P10 P11 P12 P13 P14 P15 P16 P17 P18 P19 CLK RST O10 O11 O12 O13 O14 O15 O16 O17 O18 O19
* Flip-flops for each bit with positive edge triggering and active-low reset
Xff10 P10 CLK RST O10 FF
Xff11 P11 CLK RST O11 FF
Xff12 P12 CLK RST O12 FF
Xff13 P13 CLK RST O13 FF
Xff14 P14 CLK RST O14 FF
Xff15 P15 CLK RST O15 FF
Xff16 P16 CLK RST O16 FF
Xff17 P17 CLK RST O17 FF
Xff18 P18 CLK RST O18 FF
Xff19 P19 CLK RST O19 FF
.ends

*****************
*** call cell ***
*****************
Xdcim I1 I2 I3 I4 IN_VAL CLK RST O10 O11 O12 O13 O14 O15 O16 O17 O18 O19 O20 O21 O22 O23 O24 O25 O26 O27 O28 O29 OUT_VAL DCIM
******************
*** DCIM block ***
******************
.subckt DCIM I1 I2 I3 I4 IN_VAL CLK RST O10 O11 O12 O13 O14 O15 O16 O17 O18 O19 O20 O21 O22 O23 O24 O25 O26 O27 O28 O29 OUT_VAL 
Xcontrol_in I1 I2 I3 I4 CLK IN_VAL OUT_VAL ii1 ii2 ii3 ii4 CON_IN
Xcontrol_out1 P10 P11 P12 P13 P14 P15 P16 P17 P18 P19 CLK RST O10 O11 O12 O13 O14 O15 O16 O17 O18 O19 CON_OUT
Xcontrol_out2 P20 P21 P22 P23 P24 P25 P26 P27 P28 P29 CLK RST O20 O21 O22 O23 O24 O25 O26 O27 O28 O29 CON_OUT
Xmain1 ii1 ii2 ii3 ii4 CLK O10 O11 O12 O13 O14 O15 O16 O17 O18 O19 P10 P11 P12 P13 P14 P15 P16 P17 P18 P19 
+ w0_0 w1_0 w2_0 w3_0 w4_0 w5_0 w6_0 w7_0 w8_0 w9_0 w10_0 w11_0 w12_0 w13_0 w14_0 w15_0 Main
Xmain2 ii1 ii2 ii3 ii4 CLK O20 O21 O22 O23 O24 O25 O26 O27 O28 O29 P20 P21 P22 P23 P24 P25 P26 P27 P28 P29 
+ w0_1 w1_1 w2_1 w3_1 w4_1 w5_1 w6_1 w7_1 w8_1 w9_1 w10_1 w11_1 w12_1 w13_1 w14_1 w15_1 Main
.ends

**************************
*** Simulation setting ***
**************************


* Vclk CLK 0 PULSE(0v SupplyV 0 r_time f_time CLK_Period_2 CLK_Period)

* Vrst RST 0 PWL 0n SupplyV
* + 'CLK_Period*1.5' SupplyV 'CLK_Period*1.5+f_time' 0v 'CLK_Period*2.5' 0v 'CLK_Period*2.5+r_time' SupplyV
* + 'CLK_Period*6.5' SupplyV 'CLK_Period*6.5+f_time' 0v 'CLK_Period*7.5' 0v 'CLK_Period*7.5+r_time' SupplyV

* Vval IN_VAL 0 PWL 0n 0v
* + 'CLK_Period*1' 0v 'CLK_Period*1+f_time' SupplyV 'CLK_Period*5' SupplyV 'CLK_Period*5+r_time' 0v
* + 'CLK_Period*6' 0v 'CLK_Period*6+f_time' SupplyV 'CLK_Period*10' SupplyV 'CLK_Period*10+r_time' 0v

* *8 -> 15
* VD1 I1 0 PWL 0n 0v
* + 'CLK_Period*1' 0v 'CLK_Period*1+r_time' SupplyV 'CLK_Period*2' SupplyV 'CLK_Period*2+f_time' 0v
* + 'CLK_Period*6' 0v 'CLK_Period*6+r_time' SupplyV 'CLK_Period*10' SupplyV 'CLK_Period*10+f_time' 0v
* *2 -> 14
* VD2 I2 0 PWL 0n 0v
* + 'CLK_Period*3' 0v 'CLK_Period*3+r_time' SupplyV 'CLK_Period*4' SupplyV 'CLK_Period*4+r_time' 0v
* + 'CLK_Period*6' 0v 'CLK_Period*6+r_time' SupplyV 'CLK_Period*9' SupplyV 'CLK_Period*9+f_time' 0v
* *3 -> 13
* VD3 I3 0 PWL 0n 0v
* + 'CLK_Period*3' 0v 'CLK_Period*3+r_time' SupplyV 'CLK_Period*5' SupplyV 'CLK_Period*5+f_time' 0v
* + 'CLK_Period*6' 0v 'CLK_Period*6+r_time' SupplyV 'CLK_Period*8' SupplyV 'CLK_Period*8+f_time' 0v
* + 'CLK_Period*9' 0v 'CLK_Period*9+r_time' SupplyV 'CLK_Period*10' SupplyV 'CLK_Period*10+f_time' 0v
* *7 -> 12
* VD4 I4 0 PWL 0n 0v
* + 'CLK_Period*2' 0v 'CLK_Period*2+r_time' SupplyV 'CLK_Period*5' SupplyV 'CLK_Period*5+r_time' 0v
* + 'CLK_Period*6' 0v 'CLK_Period*6+r_time' SupplyV 'CLK_Period*8' SupplyV 'CLK_Period*8+f_time' 0v

* *******************
* *** Measurement ***
* *******************
* .measure TRAN td 
* + TRIG V(Xdcim.ii1) VAL=0.9 RISE=1
* + TARG V(Xdcim.P10)  VAL=0.9 RISE=1

* .measure TRAN pwr AVG POWER
* column 1 *
.ic V(Xdcim.w0_0)=0v
.ic V(Xdcim.w1_0)=0v
.ic V(Xdcim.w2_0)=0v
.ic V(Xdcim.w3_0)=1.8v

.ic V(Xdcim.w4_0)=0v
.ic V(Xdcim.w5_0)=0v
.ic V(Xdcim.w6_0)=1.8v
.ic V(Xdcim.w7_0)=1.8v

.ic V(Xdcim.w8_0)=0v
.ic V(Xdcim.w9_0)=1.8v
.ic V(Xdcim.w10_0)=1.8v
.ic V(Xdcim.w11_0)=1.8v

.ic V(Xdcim.w12_0)=1.8v
.ic V(Xdcim.w13_0)=1.8v
.ic V(Xdcim.w14_0)=1.8v
.ic V(Xdcim.w15_0)=1.8v
* column 2 *
.ic V(Xdcim.w0_1)=0v
.ic V(Xdcim.w1_1)=0v
.ic V(Xdcim.w2_1)=1.8v
.ic V(Xdcim.w3_1)=0v

.ic V(Xdcim.w4_1)=0v
.ic V(Xdcim.w5_1)=1.8v
.ic V(Xdcim.w6_1)=1.8v
.ic V(Xdcim.w7_1)=0v

.ic V(Xdcim.w8_1)=1.8v
.ic V(Xdcim.w9_1)=0v
.ic V(Xdcim.w10_1)=0v
.ic V(Xdcim.w11_1)=0v

.ic V(Xdcim.w12_1)=1.8v
.ic V(Xdcim.w13_1)=1.8v
.ic V(Xdcim.w14_1)=0v
.ic V(Xdcim.w15_1)=0v