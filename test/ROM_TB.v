`timescale 1ns/100ps

`include "defs.v"

`default_nettype none

module ROM_TB();
   reg [`XBUS] addr;
   wire [`XBUS] data;

   ROM #(.content("sumseq.mem")) dut
   (.addr(addr),
    .data(data));
   initial begin
      addr = 0;
      #1;
      assert(data == 'h00a54533);
      addr = 4;
      #1;
      assert(data == 'h0052c2b3);
      addr = 'h1c;
      #1;
      assert(data == 'h00000063);
      $finish;
   end
endmodule // Button_TB
