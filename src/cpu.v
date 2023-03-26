// 3 register CPU; A, B and Output
// Registers A and B are tied to the ALU.
// Output is displayed on a set of LEDs

`default_nettype none

module cpu
(
    input wire i_clk,
    input wire i_reset,
    output wire [5:0] led
);

  wire [7:0] bus;

  wire register_a_read_n;
  wire register_a_write_n;

  wire register_b_read_n;
  wire register_b_write_n;

  wire register_instruction_read_n;
  wire register_instruction_write_n;
  wire [7:0] regiter_instruction_internal;

  wire register_out_write_n;
  wire [7:0] regiter_out_internal;

  wire register_mem_write_n;
  wire [7:0] regiter_mem_internal;

  wire programcounter_read_n;
  wire programcounter_write_n;
  wire programcounter_inc_n;

  wire alu_read_n;
  wire alu_subtract;
  wire alu_read_flags_n;
  wire [7:0] alu_input_a;
  wire [7:0] alu_input_b;

  wire [3:0] mem_address;
  wire mem_read_n;
  wire mem_write_n;

  wire [3:0] instruction;
  wire [3:0] instruction_argument;

  wire flag_c;
  wire flag_z;

  wire sys_clock;
  wire sys_reset;
  wire sys_reset_n;
  wire control_halt;

  assign mem_address[3:0] = regiter_mem_internal[3:0];
  assign instruction = regiter_instruction_internal[7:4];
  assign instruction_argument = regiter_instruction_internal[3:0];

  // i_reset is ON untill pressed
  assign sys_reset = (i_reset == 1'b1) ? 1'b0 : 1'b1;
  assign sys_reset_n = (i_reset == 1'b1) ? 1'b1 : 1'b0;

  // LEDs 1 == OFF
  assign led[5:0] = ~regiter_out_internal[5:0];
  // assign led[4] = ~alu_subtract;
  // assign led[5] = ~sys_clock;

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
    .io_bus(bus)
  );

  register register_mem
  (
    .i_clk(sys_clock),
    .i_reset(sys_reset),
    .i_read_n(1'b1),
    .i_write_n(register_mem_write_n),
    .io_bus(bus),
    .internal_data(regiter_mem_internal)
  );

  register register_instruction
  (
    .i_clk(sys_clock),
    .i_reset(sys_reset),
    .i_read_n(register_instruction_read_n),
    .i_write_n(register_instruction_write_n),
    .io_bus(bus),
    .internal_data(regiter_instruction_internal)
  );

  register register_a
  (
    .i_clk(sys_clock),
    .i_reset(sys_reset),
    .i_read_n(register_a_read_n),
    .i_write_n(register_a_write_n),
    .io_bus(bus),
    .internal_data(alu_input_a)
  );

  register register_b
  (
    .i_clk(sys_clock),
    .i_reset(sys_reset),
    .i_read_n(register_b_read_n),
    .i_write_n(register_b_write_n),
    .io_bus(bus),
    .internal_data(alu_input_b)
  );

  register register_output
  (
    .i_clk(sys_clock),
    .i_reset(sys_reset),
    .i_read_n(1'b1),
    .i_write_n(register_out_write_n),
    .io_bus(bus),
    .internal_data(regiter_out_internal)
  );

  alu alu
  (
    .i_clk(sys_clock),
    .i_reset(sys_reset),
    .i_read_n(alu_read_n),
    .i_subtract(alu_subtract),
    .i_read_flags_n(alu_read_flags_n),
    .i_data_a(alu_input_a),
    .i_data_b(alu_input_b),
    .o_flag_c(flag_c),
    .o_flag_z(flag_z),
    .o_bus(bus)
  );

  memory mem
  (
    .i_clk(sys_clock),
    .i_address(mem_address),
    .i_read_n(mem_read_n),
    .i_write_n(mem_write_n),
    .io_bus(bus)
  );

  controller controller
  (
    .i_clk(sys_clock),
    .i_reset(sys_reset),
    .i_instruction(instruction),
    .i_instruction_argument(instruction_argument),
    .i_flag_c(flag_c),
    .i_flag_z(flag_z),
    .o_bus(bus),
    .o_halt(control_halt),
    .o_reg_mem_write_n(register_mem_write_n),
    .o_mem_read_n(mem_read_n),
    .o_mem_write_n(mem_write_n),
    .o_reg_instruction_read_n(register_instruction_read_n),
    .o_reg_instruction_write_n(register_instruction_write_n),
    .o_reg_a_read_n(register_a_read_n),
    .o_reg_a_write_n(register_a_write_n),
    .o_alu_read_n(alu_read_n),
    .o_alu_read_flags_n(alu_read_flags_n),
    .o_alu_subtract(alu_subtract),
    .o_reg_b_read_n(register_b_read_n),
    .o_reg_b_write_n(register_b_write_n),
    .o_reg_out_write_n(register_out_write_n),
    .o_pc_read_n(programcounter_read_n),
    .o_pc_write_n(programcounter_write_n),
    .o_pc_inc_n(programcounter_inc_n)
  );

endmodule

