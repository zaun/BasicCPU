BOARD=tangnano9k
FAMILY=GW1N-9C
DEVICE=GW1NR-LV9QN88PC6/I5

all: out.fs

# Synthesis
synthesis.json: src/*.v
	yosys -p "read_verilog src/*.v; synth_gowin -top cpu -json synthesis.json"

# Place and Route
bitstream.json: synthesis.json
	nextpnr-gowin --json synthesis.json --freq 27 --write bitstream.json --device ${DEVICE} --family ${FAMILY} --cst ${BOARD}.cst

# Generate Bitstream
out.fs: bitstream.json
	gowin_pack -d ${FAMILY} -o out.fs bitstream.json

# Program Board
load: out.fs
	openFPGALoader -b ${BOARD} out.fs -f

# Remove build files
clean:
	rm -rf out.fs bitstream.json synthesis.json

test:
	iverilog -o test.out src/*.v tests/programcounter_tb.v; vvp ./test.out; rm test.out
	iverilog -o test.out src/*.v tests/clock_tb.v; vvp ./test.out; rm test.out

.PHONY: load clean
.INTERMEDIATE: bitstream.json synthesis.json