// Simple ALU that can add and subtract

module alu
(
  // Control signals
  input wire i_clk,
  input wire i_reset,
  input wire i_read_n,
  input wire i_subtract,
  input wire i_read_flags_n,

  // Inputs & Outputs
  input wire [7:0] i_data_a,
  input wire [7:0] i_data_b,
  inout wire [7:0] o_bus,
  output reg o_flag_c,
  output reg o_flag_z
);

  reg [8:0] internal_data;
  reg flag_c;
  reg flag_z;

  assign o_bus = (i_read_n == 1'b0) ? internal_data[7:0] : 8'bZZZZZZZZ;
  assign o_flag_c = (i_read_flags_n == 1'b0) ? flag_c : 8'bZ;
  assign o_flag_z = (i_read_flags_n == 1'b0) ? flag_z : 8'bZ;
  
  initial internal_data = 9'b000000000;

  always @(negedge i_clk or posedge i_reset) begin
    if (i_reset == 1'b1) begin
      internal_data = 9'b000000000;
    end else begin
      if (i_read_n == 1'b0) begin
        if (i_subtract == 1'b1) begin
          internal_data = i_data_a - i_data_b;
        end else begin
          internal_data = i_data_a + i_data_b;
        end
      end

      if (internal_data == 9'b000000000) begin
        flag_z = 1'b1;
      end else begin
        flag_z = 1'b0;
      end

      if (internal_data[8:8] == 1'b1) begin
        flag_c = 1'b1;
      end else begin
        flag_c = 1'b0;
      end
    end
  end
endmodule
