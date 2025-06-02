`ifndef __defs_v
`define __defs_v
`define XLEN 32
`define XMSB 31
`define XBUS `XMSB:0

`define R_COUNT 32
`define R_LAST 31
`define R_MSB 4

`define PC_MODE_HLT 0
`define PC_MODE_INC 1
`define PC_MODE_SET 2
`define PC_MODE_ADD 3
`define PC_MODE_MSB 1

// ALU opcodes:
// for arithmetic instructitons start it is bits [30][14:12] of the opcode
`define ALU_OP_ADD  4'b0000
`define ALU_OP_SUB  4'b1000
`define ALU_OP_SLL  4'b0001
`define ALU_OP_SLT  4'b0010
`define ALU_OP_SLTU 4'b0011
`define ALU_OP_XOR  4'b0100
`define ALU_OP_SRL  4'b0101
`define ALU_OP_SRA  4'b1101
`define ALU_OP_OR   4'b0110
`define ALU_OP_AND  4'b0111
// for branch instructions it's zero then bits [14:12] of the opcode
`define ALU_OP_EQ   4'b0000
`define ALU_OP_NE   4'b0001
`define ALU_OP_LT   4'b0100
`define ALU_OP_GE   4'b0101
`define ALU_OP_LTU  4'b0110
`define ALU_OP_GEU  4'b0111
`define ALU_OP_MSB  3

`endif
