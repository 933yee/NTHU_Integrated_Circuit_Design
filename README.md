# NTHU Integrated Circuit Design

Transistor-level circuit design coursework from NTHU, spanning CMOS logic, custom layout and post-layout verification, network-on-chip performance analysis, and a final digital compute-in-memory circuit.

## Results

![HW1 grade](https://img.shields.io/badge/HW1-108-brightgreen)
![HW2 grade](https://img.shields.io/badge/HW2-98-green)
![HW3 grade](https://img.shields.io/badge/HW3-96-green)
![Final grade](https://img.shields.io/badge/Final-97-green)

## Coursework

### HW1 — CMOS logic in SPICE

Transistor-level implementations and simulations of:

- inverter, NAND, NOR, AND, and OR gates;
- a composed Boolean logic function;
- transmission-gate-based 2:1 and 4:1 multiplexers for the bonus task.

The SPICE decks define the transistor networks, stimuli, and transient analyses used to verify every input combination.

- [SPICE source](HW1/110062222_HW1.sp)
- [Bonus multiplexer source](HW1/110062222_HW1_bonus.sp)
- [Report](HW1/110062222_HW1.pdf)

### HW2 — 3-input XOR layout

A full custom-design flow for a transistor-level three-input XOR gate:

1. schematic and pre-layout simulation;
2. Virtuoso layout;
3. design-rule checking (DRC);
4. layout-versus-schematic verification (LVS);
5. parasitic extraction and post-layout simulation;
6. rising/falling delay comparison.

The measured pre-layout delays were 148.7402 ps and 255.3041 ps; extracted post-layout delays were 265.4899 ps and 437.3023 ps, illustrating the cost of layout parasitics.

Sources include the pre/post SPICE decks, extracted PEX netlist, DRC summary, and LVS report under [HW2/HW2_XOR](HW2/HW2_XOR/).

### HW3 — Network-on-Chip analysis

An experimental study of a NoC simulator rather than a source-code implementation. The report analyzes:

- total received flits and packets;
- global average packet delay;
- network and per-IP throughput;
- the effect of packet size, injection rate, and simulation duration;
- saturation near a packet injection rate of approximately 0.04;
- the energy/performance impact of changing router buffer depth.

[Report](HW3/110062222_HW3_report.pdf)

### Final — Digital compute-in-memory

A transistor-level digital compute-in-memory (DCIM) datapath built from reusable SPICE subcircuits:

- four input latches and positive-edge storage;
- 4-bit latch/multiply blocks;
- 4-, 5-, and 10-bit adder structures;
- bit shifting and accumulation;
- transmission gates, flip-flops, and a compact full adder;
- a registered 10-bit output.

The implementation is contained in [Final/DCIM.sp](Final/DCIM.sp), with schematics, waveforms, and design discussion in the [final report](Final/110062222_report.pdf).

## Repository structure

~~~text
HW1/    CMOS gate and multiplexer SPICE simulations
HW2/    XOR schematic/layout verification artifacts
HW3/    NoC experiment specification and report
Final/  DCIM SPICE implementation and report
~~~

## Reproducing the work

- The .sp files target the HSPICE-style flow and process models used by the course. Update model-library paths before running them in another environment.
- HW2 layout reproduction requires Cadence Virtuoso plus the matching process design kit; the repository preserves extracted netlists and verification reports, but not a portable PDK.
- HW3 depends on the course NoC simulator and configuration described by the assignment.
- PDF specifications and reports are included as the primary record of schematics, layouts, waveforms, and measured results.
