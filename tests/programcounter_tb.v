`timescale 1ns / 1ps

module programcounter_tb;

  // Control signals
  reg i_clk;
  reg i_reset;
  reg i_read_n;
  reg i_write_n;
  reg i_inc_n;

  // Inputs & Outputs
  wire [7:0] io_bus;
  wire [7:0] internal_data;

  reg [7:0] bus_value;
  assign io_bus = (i_write_n == 1'b0) ? bus_value : 8'bZZZZZZZZ;

  programcounter pc
  (
    .i_clk(i_clk),
    .i_reset(i_reset),
    .i_read_n(i_read_n),
    .i_write_n(i_write_n),
    .i_inc_n(i_inc_n),
    .io_bus(io_bus),
    .internal_data(internal_data)
  );

  // Test Internals
  integer testCount = 0;
  integer testCountPass = 0;
  integer testCountFail = 0;

  `define PROCESS_CLK \
    $display("  PROCESS CLOCK"); \
    i_clk = ~i_clk; \ // Neg
    #10 \
    i_clk = ~i_clk; \ // Pos
    #10

  `define RESET_INPUTS \
    i_reset = 0; \
    i_read_n = 1; \
    i_write_n = 1; \
    i_inc_n = 1;

  `define DISPLAY_INPUTS \
    $display("  i_reset: %b i_read_n: %b i_write_n: %b i_inc_n: %b", i_reset, i_read_n, i_write_n, i_inc_n);

  `define DISPLAY_OUTPUTS \
    $display("  io_bus: %b", io_bus); \
    $display("  internal_data: %b", internal_data);

  `define TEST(desc) \
    testCount = testCount + 1; \
    $display(); \
    $display("%s", desc); \
    `RESET_INPUTS

  `define FINISH \
    $display(); \
    $display("Tests:  %d", testCount); \
    $display("Passed: %d", testCountPass); \
    $display("Failed: %d", testCountFail); \
    $display(); \
    $finish;

  `define EXPECT(desc, a, b) \
    if (a === b) begin \
      $display("  == PASS == %s", desc); \
      testCountPass = testCountPass + 1; \
    end else begin\
      $display("  == FAIL == %s (%B != %B)", desc, a, b); \
      testCountFail = testCountFail + 1; \
    end

  initial begin
    $dumpfile("test.vcd");
    i_clk = 1'b1;
  end

  always begin
    #10
    $display("Starting Program Counter unit tests");

    `TEST("should have an known state at start:")
    `DISPLAY_INPUTS
    `PROCESS_CLK
    `DISPLAY_OUTPUTS
    `EXPECT("should verify internal_data", internal_data, 8'b00000000)
    `EXPECT("should verify io_bus", io_bus, 8'bZZZZZZZZ)

    `TEST("should increment value:")
    i_inc_n = 0;
    `DISPLAY_INPUTS
    `PROCESS_CLK
    `DISPLAY_OUTPUTS
    `EXPECT("should verify internal_data", internal_data, 8'b00000001)
    `EXPECT("should verify io_bus", io_bus, 8'bZZZZZZZZ)

    `TEST("should read value:")
    i_read_n = 0;
    `DISPLAY_INPUTS
    `PROCESS_CLK
    `DISPLAY_OUTPUTS
    `EXPECT("should verify internal_data", internal_data, 8'b00000001)
    `EXPECT("should verify io_bus", io_bus, 8'b00000001)

    `TEST("should write value:")
    i_write_n = 0;
    bus_value = 8'b00110011;
    `DISPLAY_INPUTS
    `PROCESS_CLK
    `DISPLAY_OUTPUTS
    `EXPECT("should verify internal_data", internal_data, 8'b00110011)
    `EXPECT("should verify io_bus", io_bus, 8'b00110011)

    `TEST("should write value:")
    i_reset = 1;
    `DISPLAY_INPUTS
    `PROCESS_CLK
    `DISPLAY_OUTPUTS
    `EXPECT("should verify internal_data", internal_data, 8'b00000000)
    `EXPECT("should verify io_bus", io_bus, 8'bZZZZZZZZ)

    `FINISH
  end
endmodule
