`include "defs.v"

`define OPCODE_R 7'b0110011
`define OPCODE_I 7'b0010011
`define OPCODE_B 7'b1100011
`define OPCODE_E 7'b1110011

module Decoder(input [`XBUS]               inst,

               output wire [`ALU_OP_MSB:0] alu_op,
               output reg                  is_cond,
               output wire [`R_MSB:0]      rs1,
               output wire [`R_MSB:0]      rs2,
               output wire [`R_MSB:0]      rd,
               output wire [`XBUS]         imm,


               output reg                  op2_is_imm,
               output reg [`XBUS]          pc_update,
               output reg [`PC_MODE_MSB:0] pc_mode_if_taken,

               output reg                  act_write_reg,
               output reg                  act_ecall,

               output reg                  exc
               );

   reg rs1_use_override;
   reg [`R_MSB:0] rs1_override;

   // override is used to give ECALL access to registers
   assign rs1 = rs1_use_override ? rs1_override : inst[19:15];
   assign rs2 = inst[24:20];
   assign rd = inst[11:7];

   assign imm = {{20{inst[31]}}, inst[31:20]}; // sign-extend

   wire [6:0] opcode;
   wire [6:0] funct7;
   wire [2:0] funct3;

   assign opcode = inst[6:0];
   assign funct7 = inst[31:25];
   assign funct3 = inst[14:12];

   wire [`ALU_OP_MSB-1:0] alu_op_low;
   reg                    alu_op_high;

   // low bits of alu_op can be extracted directly from inst
   // highest bit is zero for Bs and most Rs, one for some Rs
   // and must be computed separetely
   assign alu_op = {alu_op_high, alu_op_low};
   assign alu_op_low = inst[14:12];

   // validate instructions separatedly from operand extraction
   // to make it more readable
   // valid_* signals indicate that inst is a valid instruction of that type
   // they are not used to decode, only to signal errors
   wire valid_r;
   assign valid_r = (opcode == `OPCODE_R
                     && (funct7 == 7'b0000000
                         || (funct7 == 7'b0100000 & (funct3 == 3'b000 || funct3 == 3'b101))));

   wire valid_i;
   assign valid_i = (opcode == `OPCODE_I
                     && ((funct3 != 3'b001 && funct3 != 3'b101)
                         || (funct3 == 3'b001 && funct7 == 7'b0000000)
                         || (funct3 == 3'b101 && funct7 == 7'b0000000 )
                         || (funct3 == 3'b101 && funct7 == 7'b0100000)));

   wire valid_b;
   assign valid_b = (opcode == `OPCODE_B
                     && funct3 != 3'b010 && funct3 != 3'b011);

   wire valid_e;
   assign valid_e = (inst == 32'b000000000000_00000_000_00000_1110011); // ECALL only

   always @(*) begin
      // set all outputs to some default, override later
      exc = 0;
      rs1_use_override = 0;
      rs1_override = 0;

      alu_op_high = 0;

      is_cond = 0;
      pc_mode_if_taken = `PC_MODE_INC;
      is_cond = 0;

      op2_is_imm = 0;

      pc_update = 0;

      act_write_reg = 0;
      act_ecall = 0;

      case (opcode)
        `OPCODE_B: begin
           is_cond = 1;
           pc_mode_if_taken = `PC_MODE_ADD;
           is_cond = 1;
           pc_update = {{19{inst[31]}},inst[31],inst[7],inst[30:25],inst[11:8],1'b0};
           exc = ~valid_b;
        end
        `OPCODE_I: begin
           // note that for for SRAI, the immediate is technically incorrect
           // as funct7 overlaps with imm and in this case is 7'b0100000
           // but that's not a problem, ALU ignores upper bites for shift ops.
           op2_is_imm = 1;
           if (funct3 == 3'b101)
             alu_op_high = inst[30]; // SRLI (0) / SRAI (1)
           act_write_reg = 1;
           exc = ~valid_i;
        end
        `OPCODE_R: begin
           alu_op_high = inst[30];
           act_write_reg = 1;
           exc = ~valid_r;
        end
        `OPCODE_E: begin
           if (inst == 'h00000073) begin
              rs1_override = 10;
              rs1_use_override = 1;
              act_ecall = 1;
           end
           exc = ~valid_e;
        end
        default: exc = 1;
      endcase // case (opcode)
   end
endmodule
