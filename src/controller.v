// The main controller for the CPU. It will preform the
// fetch -> execute cycle, reading in the program from memory
// and excuting each opcode.

`default_nettype none

module controller
(
  // Control signals
  input wire i_clk,
  input wire i_reset,

  // Inputs & Outputs
  input wire [3:0] i_instruction,
  input wire [3:0] i_instruction_argument,
  input wire i_flag_c,
  input wire i_flag_z,
  inout wire [7:0] o_bus,
  output reg o_halt,
  output reg o_reg_mem_write_n,
  output reg o_mem_read_n,
  output reg o_mem_write_n,
  output reg o_reg_instruction_read_n,
  output reg o_reg_instruction_write_n,
  output reg o_reg_a_read_n,
  output reg o_reg_a_write_n,
  output reg o_alu_read_n,
  output reg o_alu_subtract,
  output reg o_alu_read_flags_n,
  output reg o_reg_b_read_n,
  output reg o_reg_b_write_n,
  output reg o_reg_out_write_n,
  output reg o_pc_read_n,
  output reg o_pc_write_n,
  output reg o_pc_inc_n
);

  // Internal
  reg o_bus_n;
  reg [7:0] out_buff;
  reg [1:0] cycle_step; // Up to 4 steps
  reg [1:0] instruction_step; // Up to 4 steps

  assign o_bus = (o_bus_n == 1'b0) ? out_buff : 8'bZZZZZZZZ;

  initial begin
    cycle_step <= 2'b00;
    out_buff <= 8'b00000000;
    o_halt <= 1'b0;
    o_reg_mem_write_n <= 1'b1;
    o_mem_read_n <= 1'b1;
    o_mem_write_n <= 1'b1;
    o_reg_instruction_read_n <= 1'b1;
    o_reg_instruction_write_n <= 1'b1;
    o_reg_a_read_n <= 1'b1;
    o_reg_a_write_n <= 1'b1;
    o_alu_read_n <= 1'b1;
    o_alu_subtract <= 1'b0;
    o_alu_read_flags_n <= 1'b1;
    o_reg_b_read_n <= 1'b1;
    o_reg_b_write_n <= 1'b1;
    o_reg_out_write_n <= 1'b1;
    o_pc_read_n <= 1'b1;
    o_pc_write_n <= 1'b1;
    o_pc_inc_n <= 1'b1;
    o_bus_n <= 1'b1;
  end

  // Main controller loop
  always @(posedge i_clk or posedge i_reset) begin
    if (i_reset == 1'b1) begin
      cycle_step <= 2'b00;
      out_buff <= 8'bZZZZZZZZ;
      o_halt <= 1'b0;
      o_reg_mem_write_n <= 1'b1;
      o_mem_read_n <= 1'b1;
      o_mem_write_n <= 1'b1;
      o_reg_instruction_read_n <= 1'b1;
      o_reg_instruction_write_n <= 1'b1;
      o_reg_a_read_n <= 1'b1;
      o_reg_a_write_n <= 1'b1;
      o_alu_read_n <= 1'b1;
      o_alu_subtract <= 1'b0;
      o_alu_read_flags_n <= 1'b1;
      o_reg_b_read_n <= 1'b1;
      o_reg_b_write_n <= 1'b1;
      o_reg_out_write_n <= 1'b1;
      o_pc_read_n <= 1'b1;
      o_pc_write_n <= 1'b1;
      o_pc_inc_n <= 1'b1;
    end else begin

      case(cycle_step)
        2'b00: begin
          // Load the PC contents into mem reg
          o_pc_read_n <= 1'b0;
          o_reg_mem_write_n <= 1'b0;

          cycle_step <= 3'b01;
        end
        
        3'b01: begin
          o_pc_read_n <= 1'b1;
          o_reg_mem_write_n <= 1'b1;

          // Load mem content into instruction reg
          o_mem_read_n <= 1'b0;
          o_reg_instruction_write_n <= 1'b0;

          // Inc the PC register
          o_pc_inc_n <= 1'b0;

          cycle_step <= 3'b10;
        end
        
        3'b10: begin
          o_mem_read_n <= 1'b1;
          o_reg_instruction_write_n <= 1'b1;
          o_pc_inc_n <= 1'b1;

          instruction_step <= 2'b00;
          cycle_step <= 2'b11;
        end

        default: begin
          case(i_instruction)
            `OPCODE_LDA: begin
              case (instruction_step)
                2'b00: begin
                  out_buff[7:4] <= 4'b0000;
                  out_buff[3:0] <= i_instruction_argument;
                  o_bus_n <= 1'b0;
                  o_reg_mem_write_n <= 1'b0;

                  instruction_step <= 2'b01;
                end

                2'b01: begin
                  o_reg_mem_write_n <= 1'b1;
                  o_bus_n <= 1'b1;
                  out_buff <= 8'b00000000;

                  o_mem_read_n <= 1'b0;
                  o_reg_a_write_n <= 1'b0;

                  instruction_step <= 2'b10;
                end

                default: begin
                  o_mem_read_n <= 1'b1;
                  o_reg_a_write_n <= 1'b1;

                  // Finish instruction
                  cycle_step <= 2'b00;
                end
              endcase
            end

            `OPCODE_LDAI: begin
              if (instruction_step == 2'b00) begin
                out_buff[7:4] <= 4'b0000;
                out_buff[3:0] <= i_instruction_argument;
                o_bus_n <= 1'b0;
                o_reg_a_write_n <= 1'b0;

                instruction_step <= 2'b01;
              end else begin
                o_reg_a_write_n <= 1'b1;
                o_bus_n <= 1'b1;
                out_buff <= 8'b00000000;

                // Finish instruction
                cycle_step <= 2'b00;
              end
            end

            `OPCODE_LDB: begin
              case (instruction_step)
                2'b00: begin
                  out_buff[7:4] <= 4'b0000;
                  out_buff[3:0] <= i_instruction_argument;
                  o_bus_n <= 1'b0;
                  o_reg_mem_write_n <= 1'b0;

                  instruction_step <= 2'b01;
                end
                
                2'b01: begin
                  o_reg_mem_write_n <= 1'b1;
                  o_bus_n <= 1'b1;
                  out_buff <= 8'b00000000;

                  o_mem_read_n <= 1'b0;
                  o_reg_b_write_n <= 1'b0;

                  instruction_step <= 2'b10;
                end

                default: begin
                  o_mem_read_n <= 1'b1;
                  o_reg_b_write_n <= 1'b1;

                  // Finish instruction
                  cycle_step <= 2'b00;
                end
              endcase
            end

            `OPCODE_LDBI: begin
              if (instruction_step == 2'b00) begin
                out_buff[7:4] <= 4'b0000;
                out_buff[3:0] <= i_instruction_argument;
                o_bus_n <= 1'b0;
                o_reg_b_write_n <= 1'b0;

                instruction_step <= 2'b01;
              end else begin
                o_reg_b_write_n <= 1'b1;
                o_bus_n <= 1'b1;
                out_buff <= 8'b00000000;

                // Finish instruction
                cycle_step <= 2'b00;
              end
            end

            `OPCODE_LDO: begin
              case (instruction_step)
                2'b00: begin
                  out_buff[7:4] <= 4'b0000;
                  out_buff[3:0] <= i_instruction_argument;
                  o_bus_n <= 1'b0;
                  o_reg_mem_write_n <= 1'b0;

                  instruction_step <= 2'b01;
                end
                
                2'b01: begin
                  o_reg_mem_write_n <= 1'b1;
                  o_bus_n <= 1'b1;
                  out_buff <= 8'b00000000;

                  o_mem_read_n <= 1'b0;
                  o_reg_out_write_n <= 1'b0;

                  instruction_step <= 2'b10;
                end
                
                default: begin
                  o_mem_read_n <= 1'b1;
                  o_reg_out_write_n <= 1'b1;

                  // Finish instruction
                  cycle_step <= 2'b00;
                end
              endcase
            end

            `OPCODE_LDOI: begin
              if (instruction_step == 2'b00) begin
                out_buff[7:4] <= 4'b0000;
                out_buff[3:0] <= i_instruction_argument;
                o_bus_n <= 1'b0;
                o_reg_out_write_n <= 1'b0;

                instruction_step <= 2'b01;
              end else begin
                o_reg_out_write_n <= 1'b1;
                o_bus_n <= 1'b1;
                out_buff <= 8'b00000000;

                // Finish instruction
                cycle_step <= 2'b00;
              end
            end

            `OPCODE_MOVA: begin
              if (instruction_step == 2'b00) begin
                o_reg_a_read_n <= 1'b0;
                o_reg_out_write_n <= 1'b0;

                instruction_step <= 2'b01;
              end else begin
                o_reg_a_read_n <= 1'b1;
                o_reg_out_write_n <= 1'b1;

                // Finish instruction
                cycle_step <= 2'b00;
              end
            end

            `OPCODE_ADD: begin
              if (instruction_step == 2'b00) begin
                o_alu_read_n <= 1'b0;
                o_reg_a_write_n <= 1'b0;

                instruction_step <= 2'b01;
              end else begin
                o_alu_read_n <= 1'b1;
                o_reg_a_write_n <= 1'b1;

                // Finish instruction
                cycle_step <= 2'b00;
              end
            end

            `OPCODE_SUB: begin
              if (instruction_step == 2'b00) begin
                o_alu_subtract <= 1'b1;
                o_alu_read_n <= 1'b0;
                o_reg_a_write_n <= 1'b0;

                instruction_step <= 2'b01;
              end else begin
                o_alu_subtract <= 1'b0;
                o_alu_read_n <= 1'b1;
                o_reg_a_write_n <= 1'b1;

                // Finish instruction
                cycle_step <= 2'b00;
              end
            end

            `OPCODE_JNZ: begin
              case (instruction_step)
                2'b00: begin
                  o_alu_read_flags_n <= 1'b0;

                  instruction_step <= 2'b01;
                end
                
                2'b01: begin
                  o_alu_read_flags_n <= 1'b1;
                  if (i_flag_z == 1'b1) begin
                    // Finish instruction
                    cycle_step <= 2'b00;
                  end else begin
                    out_buff[7:4] <= 4'b0000;
                    out_buff[3:0] <= i_instruction_argument;
                    o_bus_n <= 1'b0;
                    o_pc_write_n <= 1'b0;

                    instruction_step <= 2'b10;
                  end
                end
                
                default: begin
                  o_pc_write_n <= 1'b1;
                  o_bus_n <= 1'b1;
                  out_buff <= 8'b00000000;

                  // Finish instruction
                  cycle_step <= 2'b00;
                end
              endcase
            end

            `OPCODE_HLT: begin
              // set halt signal
              o_halt <= 1'b1;
            end
            
            default: begin
              // Unknown instruction
              cycle_step <= 1'b00;
            end
          endcase
        end
      endcase
    end
  end
endmodule
