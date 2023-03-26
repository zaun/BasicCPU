// Defines for the CPU's ABI

`default_nettype none

`define OPCODE_NOP  4'b0000 // No Operation
`define OPCODE_LDA  4'b0001 // Load content of mem into A reg
`define OPCODE_LDB  4'b0010 // Load content of mem into B reg
`define OPCODE_LDO  4'b0011 // Load content of mem into Output reg
`define OPCODE_MOVA 4'b0100 // Move A reg to Ouput reg
`define OPCODE_LDAI 4'b0101 // Load immediate into A reg
`define OPCODE_LDBI 4'b0110 // Load immediate into B reg
`define OPCODE_LDOI 4'b0111 // Load immediate into Output reg
`define OPCODE_ADD  4'b1000 // Add A reg and B reg and store in A reg
`define OPCODE_SUB  4'b1001 // Subtract B reg from A reg and store in A reg
`define OPCODE_JNZ  4'b1100 // Jump is ALU is not zero
`define OPCODE_HLT  4'b1111 // Halt the CPU
