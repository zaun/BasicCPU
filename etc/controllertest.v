module controllertest
(
  // Control signals
  input wire i_clk,
  input wire i_reset,

  // Inputs & Outputs
  output reg o_halt,
  output reg o_pc_read_n,
  output reg o_pc_write_n,
  output reg o_pc_inc_n
);

  // Internal
  reg [1:0] cycle_step; // Up to 4 steps

  initial begin
    cycle_step = 2'b00;
    o_halt = 1'b0;
    o_pc_read_n = 1'b1;
    o_pc_write_n = 1'b1;
    o_pc_inc_n = 1'b1;
  end

  // Main controller loop
  always @(posedge i_clk) begin
    if (i_reset == 1'b1) begin
      cycle_step = 2'b00;
      o_halt = 1'b0;
      o_pc_read_n = 1'b1;
      o_pc_write_n = 1'b1;
      o_pc_inc_n = 1'b1;
    end else begin
      if (cycle_step == 2'b00) begin
        o_pc_read_n = 1'b0;

        cycle_step = 3'b01;
      end else if (cycle_step == 3'b01) begin
        o_pc_read_n = 1'b1;
        o_pc_inc_n = 1'b0;

        cycle_step = 2'b10;
      end else if (cycle_step == 3'b10) begin
        o_pc_inc_n = 1'b1;

        cycle_step = 2'b00;
      end
    end
  end
endmodule
