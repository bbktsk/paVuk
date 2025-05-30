`timescale 1ns/100ps

`include "defs.v"

`default_nettype none

module ProgramCounter_TB();
   reg [`PC_MODE_MSB:0] mode = 0;
   reg [`XBUS]          update = 0;
   reg                  update_en = 0;

   wire [`XBUS]         current;
   wire [`XBUS]         next;
   reg                  clk = 0;


   ProgramCounter dut(.mode(mode),
                      .update(update),
                      .update_en(update_en),

                      .current(current),
                      .next(next),

                      .clk(clk));

   task tick;
      @(posedge clk);
      #1;
   endtask // tick

   task tock;
      @(negedge clk);
      #1;
   endtask // tock

   task assert_pc;
      input [`XBUS] expected;

      assert(current == expected);
      assert(next == expected + 4);
   endtask

   initial begin
      $dumpfile("ProgramCounter_TB.vcd");
      $dumpvars(0, ProgramCounter_TB);

      //$monitor("%06t: %d, mode=%1x update=%08x update_en=%d current=%08x next=%08x",
      //         $time, clk, mode, update, update_en, current, next);
   end

   always begin
      #100;
      clk = ~clk;
   end

   always begin
      // nothing should happen with update_en == 0
      assert(current == 0);
      assert(next == current + 4);

      tick();
      assert_pc(0);
      tock();
      assert_pc(0);
      tick();
      assert_pc(0);
      tock();
      assert_pc(0);

      // check that INC works
      mode = `PC_MODE_INC;
      update_en = 1;
      tick();
      assert_pc(4);
      tock();
      assert_pc(4);
      tick();
      assert_pc(8);
      tock();
      assert_pc(8);

      // disable update_en, it should stop
      update_en = 0;
      #1;
      assert_pc(8);
      tick();
      assert_pc(8);
      tock();
      assert_pc(8);

      mode = `PC_MODE_ADD;
      update = 'hc;
      update_en = 1;
      #1;
      assert_pc(8);
      tick();
      assert_pc('h14);
      tock();
      assert_pc('h14);
      tick();
      assert_pc('h20);
      tock();
      assert_pc('h20);

      // back to INC
      mode = `PC_MODE_INC;
      tick();
      assert_pc('h24);

      // check SET
      mode = `PC_MODE_SET;
      update = 'h124;
      tick();
      assert_pc('h124);

      $finish;
   end
endmodule // ProgramCounter_TB
