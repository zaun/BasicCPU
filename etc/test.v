module cpu
(
    input i_clk,
    input i_reset,
    output [5:0] led
);

  tri [7:0] bus;

  wire programcounter_read_n;
  wire programcounter_write_n;
  wire programcounter_inc_n;
  wire [7:0] programcounter_internal;

  wire sys_clock;
  wire sys_reset;
  wire sys_reset_n;
  wire control_halt;

  // i_reset is ON untill pressed
  assign sys_reset = (i_reset == 1'b1) ? 1'b0 : 1'b1;
  assign sys_reset_n = (i_reset == 1'b1) ? 1'b1 : 1'b0;

  // LEDs 1 == OFF
  assign led[3:0] = ~bus[3:0];
  assign led[4] = programcounter_read_n;
  assign led[5] = ~sys_clock;

  clock system_clock
  (
    .i_clk(i_clk),
    .i_halt(control_halt),
    .o_clk(sys_clock)
  );

  programcounter pc
  (
    .i_clk(sys_clock),
    .i_reset(sys_reset),
    .i_read_n(programcounter_read_n),
    .i_write_n(programcounter_write_n),
    .i_inc_n(programcounter_inc_n),
    .io_bus(bus),
    .internal_data(programcounter_internal)
  );

  controllertest controller
  (
    .i_clk(sys_clock),
    .i_reset(sys_reset),
    .o_halt(control_halt),
    .o_pc_read_n(programcounter_read_n),
    .o_pc_write_n(programcounter_write_n),
    .o_pc_inc_n(programcounter_inc_n)
  );

endmodule

