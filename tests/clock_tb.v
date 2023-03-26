`timescale 1ns / 1ps

module clock_tb;

  // Control signals
  reg i_clk;
  reg i_halt;

  // Inputs & Outputs
  wire sys_clock;

  clock system_clock
  (
    .i_clk(i_clk),
    .i_halt(i_halt),
    .o_clk(sys_clock)
  );

  // Test Internals
  integer testCount = 0;
  integer testCountPass = 0;
  integer testCountFail = 0;
  integer i = 0;

  `define PROCESS_CLK \
    $display("  PROCESS CLOCK"); \
    i_clk = ~i_clk; \ // Neg
    #10 \
    i_clk = ~i_clk; \ // Pos
    #10

  `define RESET_INPUTS \
    i_halt = 0;

  `define DISPLAY_INPUTS \
    $display("  i_halt: %b", i_halt);

  `define DISPLAY_OUTPUTS \
    $display("  sys_clock: %b", sys_clock);

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
    #1

    i_clk = ~i_clk; // Neg
    i_clk = ~i_clk; // Pos

    if (i == 1) begin
      $display("Starting Clock unit tests");

      `TEST("should update sys_clock on 13000000th clk:")
      `DISPLAY_INPUTS
    end

    if (i == 13000001) begin
      `DISPLAY_OUTPUTS
      `EXPECT("should verify sys_clock high", sys_clock, 1'b1)
    end

    if (i == 26000001) begin
      `DISPLAY_OUTPUTS
      `EXPECT("should verify sys_clock low", sys_clock, 1'b0)
    end

    if (i == 26000002) begin
      `TEST("should not update sys_clock on 13000000th clk when i_halt is high:")
      i_halt = 1'b1;
      `DISPLAY_INPUTS
    end

    if (i == 39000000) begin
      `DISPLAY_OUTPUTS
      `EXPECT("should verify sys_clock low", sys_clock, 1'b0)
    end

    if (i == 52000001) begin
      `DISPLAY_OUTPUTS
      `EXPECT("should verify sys_clock low", sys_clock, 1'b0)
    end

    if (i == 52000002) begin
      i_halt = 1'b0;
      `TEST("should have an known state at start:")
      `DISPLAY_INPUTS
      `DISPLAY_OUTPUTS
      `EXPECT("should verify sys_clock", sys_clock, 1'b0)

      `TEST("should not update sys_clock on each clk:")
      `DISPLAY_INPUTS
      `PROCESS_CLK
      `DISPLAY_OUTPUTS
      `EXPECT("should verify sys_clock", sys_clock, 1'b0)

      `FINISH
    end

    i = i + 1;
  end
endmodule
