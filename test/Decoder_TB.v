`timescale 1ns/100ps

`include "defs.v"
`include "utils.v"
`default_nettype none

module Decoder_TB();
   reg [`XBUS] inst;

   wire        exc;
   wire [`R_MSB:0] rs1;
   wire [`R_MSB:0] rs2;
   wire [`R_MSB:0] rd;
   wire [`XBUS]    imm;
   wire [`XBUS]    pc_update;
   wire [`PC_MODE_MSB:0] pc_mode_if_taken;
   wire                  is_cond;
   wire [`ALU_OP_MSB:0]  alu_op;
   wire                  op2_is_imm;
   wire                  act_write_reg;
   wire                  act_ecall;

   Decoder dut(.inst(inst),
               .exc(exc),
               .rs1(rs1),
               .rs2(rs2),
               .rd(rd),
               .alu_op(alu_op),
               .is_cond(is_cond),
               .imm(imm),
               .pc_update(pc_update),
               .pc_mode_if_taken(pc_mode_if_taken),
               .op2_is_imm(op2_is_imm),
               .act_write_reg(act_write_reg),
               .act_ecall(act_ecall)
               );

   initial begin
      // beq     x1,x2,0
      inst = 'h00208063;
      #1;
      `assert_eq(exc, 0);
      `assert_eq(is_cond, 1);
      `assert_eq(op2_is_imm, 0);
      `assert_eq(rs1, 1);
      `assert_eq(rs2, 2);
      `assert_eq(pc_update, 0);
      `assert_eq(pc_mode_if_taken, `PC_MODE_ADD);
      `assert_eq(alu_op, `ALU_OP_EQ);
      `assert_eq(act_write_reg, 0);
      `assert_eq(act_ecall, 0);
      // bne     x3,x4,-4
      inst = 'hfe419ee3;
      #1;
      `assert_eq(exc, 0);
      `assert_eq(is_cond, 1);
      `assert_eq(op2_is_imm, 0);
      `assert_eq(rs1, 3);
      `assert_eq(rs2, 4);
      `assert_eq(pc_update, -4);
      `assert_eq(pc_mode_if_taken, `PC_MODE_ADD);
      `assert_eq(alu_op, `ALU_OP_NE);
      `assert_eq(act_write_reg, 0);
      `assert_eq(act_ecall, 0);

      // blt     x5,x6, +8
      inst = 'h0062c463;
      #1;
      `assert_eq(exc, 0);
      `assert_eq(is_cond, 1);
      `assert_eq(op2_is_imm, 0);
      `assert_eq(rs1, 5);
      `assert_eq(rs2, 6);
      `assert_eq(pc_update, 8);
      `assert_eq(pc_mode_if_taken, `PC_MODE_ADD);
      `assert_eq(alu_op, `ALU_OP_LT);
      `assert_eq(act_write_reg, 0);
      `assert_eq(act_ecall, 0);

      // bge     x6,x6,-12
      inst = 'hfe635ae3;
      #1;
      `assert_eq(exc, 0);
      `assert_eq(is_cond, 1);
      `assert_eq(op2_is_imm, 0);
      `assert_eq(rs1, 6);
      `assert_eq(rs2, 6);
      `assert_eq(pc_update, -12);
      `assert_eq(pc_mode_if_taken, `PC_MODE_ADD);
      `assert_eq(alu_op, `ALU_OP_GE);
      `assert_eq(act_write_reg, 0);
      `assert_eq(act_ecall, 0);

      // bltu    x7,x8,-16
      inst = 'hfe83e8e3;
      #1;
      `assert_eq(exc, 0);
      `assert_eq(is_cond, 1);
      `assert_eq(op2_is_imm, 0);
      `assert_eq(rs1, 7);
      `assert_eq(rs2, 8);
      `assert_eq(pc_update, -16);
      `assert_eq(pc_mode_if_taken, `PC_MODE_ADD);
      `assert_eq(alu_op, `ALU_OP_LTU);
      `assert_eq(act_write_reg, 0);
      `assert_eq(act_ecall, 0);

      // bgeu    x0,x31,-4
      inst = 'hfff07ee3;
      #1;
      `assert_eq(exc, 0);
      `assert_eq(is_cond, 1);
      `assert_eq(op2_is_imm, 0);
      `assert_eq(rs1, 0);
      `assert_eq(rs2, 31);
      `assert_eq(pc_update, -4);
      `assert_eq(pc_mode_if_taken, `PC_MODE_ADD);
      `assert_eq(alu_op, `ALU_OP_GEU);
      `assert_eq(act_write_reg, 0);
      `assert_eq(act_ecall, 0);

      // addi    x1,x2,1
      inst = 'h00110093;
      #1;
      `assert_eq(exc, 0);
      `assert_eq(is_cond, 0);
      `assert_eq(op2_is_imm, 1);
      `assert_eq(rs1, 2);
      `assert_eq(imm, 1);
      `assert_eq(rd, 1);
      `assert_eq(alu_op, `ALU_OP_ADD);
      `assert_eq(pc_mode_if_taken, `PC_MODE_INC);
      `assert_eq(act_write_reg, 1);
      `assert_eq(act_ecall, 0);

      // slti    x3,x4,-2
      inst = 'hffe22193;
      #1;
      `assert_eq(exc, 0);
      `assert_eq(is_cond, 0);
      `assert_eq(op2_is_imm, 1);
      `assert_eq(rs1, 4);
      `assert_eq(imm, -2);
      `assert_eq(rd, 3);
      `assert_eq(alu_op, `ALU_OP_SLT);
      `assert_eq(pc_mode_if_taken, `PC_MODE_INC);
      `assert_eq(act_write_reg, 1);
      `assert_eq(act_ecall, 0);

      // sltiu   x9,x2,11
      inst = 'h00b13493;
      #1;
      `assert_eq(exc, 0);
      `assert_eq(is_cond, 0);
      `assert_eq(op2_is_imm, 1);
      `assert_eq(rs1, 2);
      `assert_eq(imm, 11);
      `assert_eq(rd, 9);
      `assert_eq(alu_op, `ALU_OP_SLTU);
      `assert_eq(pc_mode_if_taken, `PC_MODE_INC);
      `assert_eq(act_write_reg, 1);
      `assert_eq(act_ecall, 0);

      // xori    x15,x1,23
      inst = 'h0170c793;
      #1;
      `assert_eq(exc, 0);
      `assert_eq(is_cond, 0);
      `assert_eq(op2_is_imm, 1);
      `assert_eq(rs1, 1);
      `assert_eq(imm, 23);
      `assert_eq(rd, 15);
      `assert_eq(alu_op, `ALU_OP_XOR);
      `assert_eq(pc_mode_if_taken, `PC_MODE_INC);
      `assert_eq(act_write_reg, 1);
      `assert_eq(act_ecall, 0);

      // ori     x30,x29,-1
      inst = 'hfffeef13;
      #1;
      `assert_eq(exc, 0);
      `assert_eq(is_cond, 0);
      `assert_eq(op2_is_imm, 1);
      `assert_eq(rs1, 29);
      `assert_eq(imm, -1);
      `assert_eq(rd, 30);
      `assert_eq(alu_op, `ALU_OP_OR);
      `assert_eq(pc_mode_if_taken, `PC_MODE_INC);
      `assert_eq(act_write_reg, 1);
      `assert_eq(act_ecall, 0);

      // andi    x22,x23,1234
      inst = 'h4d2bfb13;
      #1;
      `assert_eq(is_cond, 0);
      `assert_eq(op2_is_imm, 1);
      `assert_eq(rs1, 23);
      `assert_eq(imm, 1234);
      `assert_eq(rd, 22);
      `assert_eq(alu_op, `ALU_OP_AND);
      `assert_eq(pc_mode_if_taken, `PC_MODE_INC);
      `assert_eq(act_write_reg, 1);
      `assert_eq(act_ecall, 0);

      `assert_eq(exc, 0);
      // slli    x2,x1,3
      inst = 'h00309113;
      #1;
      `assert_eq(exc, 0);
      `assert_eq(is_cond, 0);
      `assert_eq(op2_is_imm, 1);
      `assert_eq(rs1, 1);
      `assert_eq(imm, 3);
      `assert_eq(rd, 2);
      `assert_eq(alu_op, `ALU_OP_SLL);
      `assert_eq(pc_mode_if_taken, `PC_MODE_INC);
      `assert_eq(act_write_reg, 1);
      `assert_eq(act_ecall, 0);

      // srli    x9,x9,9
      inst = 'h0094d493;
      #1;
      `assert_eq(exc, 0);
      `assert_eq(is_cond, 0);
      `assert_eq(op2_is_imm, 1);
      `assert_eq(rs1, 9);
      `assert_eq(imm, 9);
      `assert_eq(rd, 9);
      `assert_eq(alu_op, `ALU_OP_SRL);
      `assert_eq(pc_mode_if_taken, `PC_MODE_INC);
      `assert_eq(act_write_reg, 1);
      `assert_eq(act_ecall, 0);

      // srai    x10,x11,31
      inst = 'h41f5d513;
      #1;
      `assert_eq(exc, 0);
      `assert_eq(is_cond, 0);
      `assert_eq(op2_is_imm, 1);
      `assert_eq(rs1, 11);
      `assert_eq(imm[4:0], 31); // ALU cares about low 5 bits only for shifts
      `assert_eq(rd, 10);
      `assert_eq(alu_op, `ALU_OP_SRA);
      `assert_eq(pc_mode_if_taken, `PC_MODE_INC);
      `assert_eq(act_write_reg, 1);
      `assert_eq(act_ecall, 0);

      // add     x1,x2,x3
      inst = 'h003100b3;
      #1;
      `assert_eq(exc, 0);
      `assert_eq(is_cond, 0);
      `assert_eq(op2_is_imm, 0);
      `assert_eq(rs1, 2);
      `assert_eq(rs2, 3);
      `assert_eq(rd, 1);
      `assert_eq(alu_op, `ALU_OP_ADD);
      `assert_eq(pc_mode_if_taken, `PC_MODE_INC);
      `assert_eq(act_write_reg, 1);
      `assert_eq(act_ecall, 0);

      // sub     x1,x0,x4
      inst = 'h404000b3;
      #1;
      `assert_eq(exc, 0);
      `assert_eq(is_cond, 0);
      `assert_eq(op2_is_imm, 0);
      `assert_eq(rs1, 0);
      `assert_eq(rs2, 4);
      `assert_eq(rd, 1);
      `assert_eq(alu_op, `ALU_OP_SUB);
      `assert_eq(pc_mode_if_taken, `PC_MODE_INC);
      `assert_eq(act_write_reg, 1);
      `assert_eq(act_ecall, 0);

      // sll     x1,x9,x8
      inst = 'h008490b3;
      #1;
      `assert_eq(exc, 0);
      `assert_eq(is_cond, 0);
      `assert_eq(op2_is_imm, 0);
      `assert_eq(rs1, 9);
      `assert_eq(rs2, 8);
      `assert_eq(rd, 1);
      `assert_eq(alu_op, `ALU_OP_SLL);
      `assert_eq(pc_mode_if_taken, `PC_MODE_INC);
      `assert_eq(act_write_reg, 1);
      `assert_eq(act_ecall, 0);

      // slt     x9,x10,x11
      inst = 'h00b524b3;
      #1;
      `assert_eq(exc, 0);
      `assert_eq(is_cond, 0);
      `assert_eq(op2_is_imm, 0);
      `assert_eq(rs1, 10);
      `assert_eq(rs2, 11);
      `assert_eq(rd, 9);
      `assert_eq(alu_op, `ALU_OP_SLT);
      `assert_eq(pc_mode_if_taken, `PC_MODE_INC);
      `assert_eq(act_write_reg, 1);
      `assert_eq(act_ecall, 0);

      // sltu    x11,x12,x13
      inst = 'h00d635b3;
      #1;
      `assert_eq(exc, 0);
      `assert_eq(is_cond, 0);
      `assert_eq(op2_is_imm, 0);
      `assert_eq(rs1, 12);
      `assert_eq(rs2, 13);
      `assert_eq(rd, 11);
      `assert_eq(alu_op, `ALU_OP_SLTU);
      `assert_eq(pc_mode_if_taken, `PC_MODE_INC);
      `assert_eq(act_write_reg, 1);
      `assert_eq(act_ecall, 0);

      // xor     x1,x1,x1
      inst = 'h0010c0b3;
      #1;
      `assert_eq(exc, 0);
      `assert_eq(is_cond, 0);
      `assert_eq(op2_is_imm, 0);
      `assert_eq(rs1, 1);
      `assert_eq(rs2, 1);
      `assert_eq(rd, 1);
      `assert_eq(alu_op, `ALU_OP_XOR);
      `assert_eq(pc_mode_if_taken, `PC_MODE_INC);
      `assert_eq(act_write_reg, 1);
      `assert_eq(act_ecall, 0);

      // srl     x9,x2,x0
      inst = 'h000154b3;
      #1;
      `assert_eq(exc, 0);
      `assert_eq(is_cond, 0);
      `assert_eq(op2_is_imm, 0);
      `assert_eq(rs1, 2);
      `assert_eq(rs2, 0);
      `assert_eq(rd, 9);
      `assert_eq(alu_op, `ALU_OP_SRL);
      `assert_eq(pc_mode_if_taken, `PC_MODE_INC);
      `assert_eq(act_write_reg, 1);
      `assert_eq(act_ecall, 0);

      // sra     x22,x23,x24
      inst = 'h418bdb33;
      #1;
      `assert_eq(exc, 0);
      `assert_eq(is_cond, 0);
      `assert_eq(op2_is_imm, 0);
      `assert_eq(rs1, 23);
      `assert_eq(rs2, 24);
      `assert_eq(rd, 22);
      `assert_eq(alu_op, `ALU_OP_SRA);
      `assert_eq(pc_mode_if_taken, `PC_MODE_INC);
      `assert_eq(act_write_reg, 1);
      `assert_eq(act_ecall, 0);

      // or      x31,x30,x29
      inst = 'h01df6fb3;
      #1;
      `assert_eq(exc, 0);
      `assert_eq(is_cond, 0);
      `assert_eq(op2_is_imm, 0);
      `assert_eq(rs1, 30);
      `assert_eq(rs2, 29);
      `assert_eq(rd, 31);
      `assert_eq(alu_op, `ALU_OP_OR);
      `assert_eq(pc_mode_if_taken, `PC_MODE_INC);
      `assert_eq(act_write_reg, 1);
      `assert_eq(act_ecall, 0);

      // and     x28,x27,x26
      inst = 'h01adfe33;
      #1;
      `assert_eq(exc, 0);
      `assert_eq(is_cond, 0);
      `assert_eq(op2_is_imm, 0);
      `assert_eq(rs1, 27);
      `assert_eq(rs2, 26);
      `assert_eq(rd, 28);
      `assert_eq(alu_op, `ALU_OP_AND);
      `assert_eq(pc_mode_if_taken, `PC_MODE_INC);
      `assert_eq(act_write_reg, 1);
      `assert_eq(act_ecall, 0);

      // ecall
      inst = 'h00000073;
      #1;
      `assert_eq(exc, 0);
      `assert_eq(rs1, 10);
      `assert_eq(act_write_reg, 0);
      `assert_eq(act_ecall, 1);

      // Invalid instructions
      // sll but bit 30 is one
      inst = 'h008490b3 | 32'h4000_0000;
      #1;
      `assert_eq(exc, 1);

      // slli but bit 30 is one
      inst = 'h00309113 | 32'h4000_0000;
      #1;
      `assert_eq(exc, 1);

      // B with invalid func3
      inst = 'h0020_a063;
      #1;
      `assert_eq(exc, 1);

      $finish();
   end // initial begin
endmodule
