// Generate the system clock based on in incoming
// clock. Stop clock if halt signal is high.

module clock
(
  // Control signals
  input wire i_clk,
  input wire i_halt,
  output reg o_clk
);

// localparam WAIT_TIME = 13500000;
// localparam WAIT_TIME = 13000000;
localparam WAIT_TIME = 130000;
reg [23:0] clockCounter = 0;

initial o_clk = 1'b0;

always @(posedge i_clk) begin
  if (i_halt == 1'b0) begin
    // o_clk = i_clk;

    clockCounter = clockCounter + 1;
    if (clockCounter == WAIT_TIME) begin
      o_clk = ~o_clk;
      clockCounter = 0;
    end
  end else begin
    o_clk = 1'b0;
  end
end
endmodule
