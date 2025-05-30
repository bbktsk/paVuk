`timescale 1ns/100ps

`include "defs.v"

`default_nettype none

module Registers_TB();
   reg [`R_MSB:0]  rd_addr1 = 0;
   reg [`R_MSB:0]  rd_addr2 = 0;
   wire [`XBUS]    rd_data1;
   wire [`XBUS]    rd_data2;

   reg [`R_MSB:0]  wr_addr;
   reg [`XBUS]     wr_data = 0;
   reg             wr_en = 0;

   reg             clk = 0;

   Registers dut (.rd_addr1(rd_addr1),
                  .rd_data1(rd_data1),

                  .rd_addr2(rd_addr2),
                  .rd_data2(rd_data2),

                  .wr_addr(wr_addr),
                  .wr_data(wr_data),
                  .wr_en(wr_en),

                  .clk(clk));


   initial begin
      $dumpfile("Registers_TB.vcd");
      $dumpvars(0, Registers_TB);

      //$monitor("%06t: %d, ra1=%02d rd1=%08x ra2=%02d rd2=%08x wa=%02d wd=%08x we=%d",
      //         $time, clk, rd_addr1, rd_data1, rd_addr2, rd_data2, wr_addr, wr_data, wr_en);
   end

   always begin
      #100;
      clk = ~clk;
   end


   task assert_rd;
      input [`XBUS] a, b;

      assert(rd_data1 == a);
      assert(rd_data2 == b);
   endtask // assert_outs

   task tick;
      @(posedge clk);
   endtask // tick

   task tock;
      @(negedge clk);
   endtask // tock

   always begin
      assert_rd(0,0);

      // write 123 to x1
      wr_addr = 1;
      wr_data = 123;
      wr_en = 1;
      tick();
      wr_en = 0;

      // read from first port
      rd_addr1 = 1;
      #1;
      assert_rd(123,0);

      // see that the value stays there after a clock cycle
      tick();
      assert_rd(123,0);

      // read from x0
      rd_addr1 = 0;
      #1;
      assert_rd(0,0);

      // read x1 from second port
      rd_addr2 = 1;
      #1;
      assert_rd(0, 123);

      // read x1 from both ports
      rd_addr1 = 1;
      #1;
      assert_rd(123, 123);

      // try to write to x0
      wr_addr = 0;
      wr_data = 69;
      wr_en = 1;
      tick();
      rd_addr1 = 0;
      rd_addr2 = 0;
      #1;
      assert_rd(0,0);
      wr_en = 0;
      tock();
      assert_rd(0,0);
      tick();
      assert_rd(0,0);

      // write two values to two regs
      wr_data = 99;
      wr_addr = 3;
      wr_en = 1;
      tick();
      wr_data = 100;
      wr_addr = 15;
      tick();
      rd_addr1 = 3;
      rd_addr2 = 15;
      #1;
      assert_rd(99,100);
      $finish;
   end
endmodule
