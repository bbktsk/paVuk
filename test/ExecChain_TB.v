`timescale 1ns/100ps

`include "defs.v"
`define assert_eq(a,b) assert(a==b) else $display("%5d FAIL: %h != %h", `__LINE__, a, b)

`default_nettype none

module ExecChain_TB();
   reg clk;
   reg run = 1;
   wire [`XBUS] result;

   PaVuk #(.rom_content("sumseq.mem"))
   dut (.clk(clk),
        .run(run),
        .result(result));

   initial begin
      // xor x10,x10,x10
      dut.pc.current = 0;
      dut.regs.regs[10] = 12;
      #1;
      `assert_eq(dut.inst, 'h00a54533);
      `assert_eq(dut.rs1, 10);
      `assert_eq(dut.rs2, 10);
      `assert_eq(dut.rd, 10);
      `assert_eq(dut.op2_is_imm, 0);
      `assert_eq(dut.alu_op, `ALU_OP_XOR);
      `assert_eq(dut.alu_op1, 12);
      `assert_eq(dut.alu_op2, 12);
      `assert_eq(dut.alu_result, 0);
      `assert_eq(dut.pc_mode, `PC_MODE_INC);
      `assert_eq(dut.act_write_reg, 1);

      // addi x5,x5,10
      dut.pc.current = 8;
      dut.regs.regs[5] = 0;
      #1;
      `assert_eq(dut.inst, 'h00a28293);
      `assert_eq(dut.rs1, 5);
      `assert_eq(dut.alu_op1, 0);
      `assert_eq(dut.alu_op2, 10);
      `assert_eq(dut.rd, 5);
      `assert_eq(dut.op2_is_imm, 1);
      `assert_eq(dut.alu_op, `ALU_OP_ADD);
      `assert_eq(dut.alu_result, 10);
      `assert_eq(dut.pc_mode, `PC_MODE_INC);
      `assert_eq(dut.act_write_reg, 1);

      // blt zero,x5,-8
      dut.pc.current = 'h14;
      dut.regs.regs[5] = 10;
      #1;
      `assert_eq(dut.inst, 'hfe504ce3);
      `assert_eq(dut.rs1, 0);
      `assert_eq(dut.rs2, 5);
      `assert_eq(dut.pc_update, -8);
      `assert_eq(dut.op2_is_imm, 0);
      `assert_eq(dut.alu_op, `ALU_OP_LT);
      `assert_eq(dut.alu_result, 1);
      `assert_eq(dut.pc_mode, `PC_MODE_ADD);
      `assert_eq(dut.act_write_reg, 0);
      `assert_eq(dut.act_ecall, 0);

      dut.regs.regs[5] = 0;
      #1;
      `assert_eq(dut.alu_result, 0);
      `assert_eq(dut.pc_mode, `PC_MODE_INC);
   end
endmodule
