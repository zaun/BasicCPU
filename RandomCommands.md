iverilog -o alu.out src/alu.v tests/alu_tb.v; vvp ./alu.out; rm alu.out

iverilog -o alu.out src/alu.v ; rm alu.out

iverilog -o test.out src/alu.v src/register.v src/programcounter.v src/clock.v src/memory.v src/controller.v src/cpu.v; rm test.out


yosys -p "read_verilog src/alu.v src/register.v src/programcounter.v src/clock.v src/memory.v src/controller.v src/cpu.v; synth_gowin -top cpu -json synthesis.json"

nextpnr-gowin --json synthesis.json --freq 27 --write bitstream.json --device GW1NR-LV9QN88PC6/I5 --family GW1N-9C --cst tangnano9k.cst

gowin_pack -d GW1N-9C -o out.fs bitstream.json

openFPGALoader -b tangnano9k out.fs -f


yosys -p "read_verilog src/programcounter.v src/clock.v src/controllertest.v src/test.v; synth_gowin -top cpu -json synthesis.json"

