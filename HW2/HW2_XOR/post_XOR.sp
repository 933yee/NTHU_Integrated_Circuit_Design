.protect
.lib "/usr/cad/cic018.l" tt
.unprotect

.include "INV_pex.cir"

.global VDD GND
Vdd VDD 0 DC=+1.8v
Vgnd GND 0 DC=0v

**logic Circuit Instantiation ***
Xxor C B A S GND VDD Xor

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
                                                                                                                                                                                 
