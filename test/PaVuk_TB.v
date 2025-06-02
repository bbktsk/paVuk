`timescale 1ns/100ps

`include "defs.v"
`include "utils.v"

`default_nettype none

module PaVuk_TB();
   reg clk = 0;
   reg run = 0;
   wire [`XBUS] result;

   PaVuk #(.rom_content("sumseq20.mem"))
   dut (.clk(clk),
        .run(run),
        .result(result));

`include "clk.v"

   initial begin
      $dumpfile("PaVuk_TB.vcd");
      $dumpvars(0, PaVuk_TB);
   end

   initial begin
      `assert_eq(dut.pc.current, 0);
      tick();
      `assert_eq(dut.pc.current, 0);
      tock();
      `assert_eq(dut.pc.current, 0);

      run = 1;

      // 00 00a54533 xor a0,a0,a0
      tick();
      `assert_eq(dut.pc.current, 4);
      tock();

      // 0052c2b3 xor t0,t0,t0
      tick();
      `assert_eq(dut.pc.current, 8);
      tock();

      // 3e828293 for addi t0,t0,1000
      tick();
      `assert_eq(dut.pc.current, 'hc);
      `assert_eq(dut.regs.regs[5], 20);

      // 00550533 add a0,a0,t0
      tick();
      `assert_eq(dut.pc.current, 'h10);
      `assert_eq(dut.regs.regs[10], 20);

      // fff28293 addi t0,t0,-1
      tick();
      `assert_eq(dut.pc.current, 'h14);
      `assert_eq(dut.regs.regs[5], 19);

      // fe504ce3 blt zero,t0,loop
      tick();
      `assert_eq(dut.pc.current, 'hc);

      #100000;
      $display("RESULT: a10=%d, console=%d", dut.regs.regs[10], result);

      // 00000073 ecall
      // 00000063 beq zero, zero, halt
      $finish();
   end
endmodule
