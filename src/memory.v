// CPU's built in memory. The program is hard coded here

`default_nettype none

module memory
(
  // Control signals
  input wire i_clk,
  input wire i_read_n,
  input wire i_write_n,

  // Inputs & Outputs
  inout wire [3:0] i_address,
  inout wire [7:0] io_bus
);

  // Internal
  reg [7:0] mem [15:0];

  integer i;
  assign io_bus = (i_read_n == 1'b0) ? mem[i_address] : 8'bZZZZZZZZ;

  initial begin
    for (i = 0; i < 16; i++) begin
        mem[i] = 8'b00000000;
    end

    // Count down from 63 and halt
    // Display count in Output register
    mem[00] <= 8'b00011101; // LDA  13
    mem[01] <= 8'b01100001; // LDBI 1
    mem[02] <= 8'b01000000; // MOVA
    mem[03] <= 8'b10010000; // SUB
    mem[04] <= 8'b11000010; // JNZ  2
    mem[05] <= 8'b01000000; // MOVA
    mem[06] <= 8'b11110000; // HLT

    mem[13] <= 8'b00111111;
  end

  always @(posedge i_clk) begin
    if (i_write_n == 1'b0) begin
      mem[(i_address)] <= io_bus;
    end
  end
endmodule
