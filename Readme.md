### BasicCPU FPGA project for the Tang Nano 9K

This is my first go at a real FPGA project. I initially created a blink project to test my toolchain. I have created a 8bit computer from ICs and a breadboard in the past so I thought this would be a good starting point. This project has taken approxamately 3 weeks to get to this point.

The main goal is to have a simple CPU that can run a program hardcoded in memory. The program should be able to count down from some 8 bit number loaded from a memory location to zero. The current value should be displayed in LEDs.

A big shout out to [lushaylabs.com](https://learn.lushaylabs.com/os-toolchain-manual-installation/) for the instructions to get the toolchain up and running on MacOS.

**Update:**

Based on feedback I recieved from [r/fpga](https://www.reddit.com/r/FPGA/comments/1227pq4/first_working_fpga_project/) the following changes were made to the project:

* Set the type for inputs and outputs in the cpu
* Remove internal_data as an output in the programcounter
* Add `default_nettype none to all source files
* Moved controller to use case statements rather than if / else if chains
* Moved to non-blocking <= assignments where I thought possible (most locations)
  * I left the zeroing out of the memory blocking so it happens before the assignment of the program
  * I left the clockCounter increment in the clock blocking so its done before the compair

*The above changes made the following changes the the overall CPU stats:*

| Name                       | Initial Result | After Update Result |
|----------------------------|----------------|---------------------|
| Number of wires            |           1268 |                 838 | 
| Number of wire bits        |           1844 |                1317 | 
| Number of public wires     |           1268 |                 838 | 
| Number of public wire bits |           1844 |                1317 | 
| Number of memories         |              0 |                   0 | 
| Number of memory bits      |              0 |                   0 | 
| Number of processes        |              0 |                   0 | 
| Number of cells            |           1363 |                 924 | 
| >> ALU                     |             50 |                  50 | 
| >> DFF                     |              3 |                   2 | 
| >> DFFC                    |              8 |                   0 | 
| >> DFFCE                   |             46 |                  50 | 
| >> DFFNC                   |              9 |                   9 | 
| >> DFFNE                   |              1 |                   1 | 
| >> DFFPE                   |             10 |                  10 | 
| >> DFFRE                   |             25 |                  25 | 
| >> GND                     |              1 |                   1 | 
| >> IBUF                    |              2 |                   2 | 
| >> LUT1                    |            517 |                 370 | 
| >> LUT2                    |             39 |                  18 | 
| >> LUT3                    |             50 |                  35 | 
| >> LUT4                    |            143 |                  99 | 
| >> MUX2_LUT5               |            272 |                 154 | 
| >> MUX2_LUT6               |            118 |                  63 | 
| >> MUX2_LUT7               |             51 |                  27 | 
| >> MUX2_LUT8               |             11 |                   1 | 
| >> OBUF                    |              6 |                   6 | 
| >> VCC                     |              1 |                   1 | 

*Some things to look into:*

* Testing with Verilator or VUnit or CocoTB
* Structs for grouping your input and output signals
* [Cummings FSM paper](http://www.sunburst-design.com/papers/CummingsSNUG2019SV_FSM1.pdf)
