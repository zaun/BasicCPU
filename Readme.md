### BasicCPU FPGA project for the Tang Nano 9K

This is my first go at a real FPGA project. I initially created a blink project to test my toolchain. I have created a 8bit computer from ICs and a breadboard in the past so I thought this would be a good starting point. This project has taken approxamately 3 weeks to get to this point.

The main goal is to have a simple CPU that can run a program hardcoded in memory. The program should be able to count down from some 8 bit number loaded from a memory location to zero. The current value should be displayed in LEDs.

A big shout out to [lushaylabs.com](https://learn.lushaylabs.com/os-toolchain-manual-installation/) for the instructions to get the toolchain up and running on MacOS.

*Updates made after suggestions from [r/FPGA](https://www.reddit.com/r/FPGA/comments/1227pq4/first_working_fpga_project/) are on a [v2 branch](https://github.com/zaun/BasicCPU/tree/v2).*