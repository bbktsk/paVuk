`timescale 1ns/100ps

`include "defs.v"

`default_nettype none

module Button_TB();
   reg                  clk = 0;
   reg                  button = 0;
   wire                 pressed;
   wire                 pulse;

   initial begin
      $dumpfile("Button_TB.vcd");
      $dumpvars(0, Button_TB);

      $monitor("%06t: %d, button=%d, sync_button=%d, pressed=%d, pulse=%d, stages=%03b, pulsed=%d",
               $time, clk, button, dut.sync_button, pressed, pulse, dut.stages, dut.pulsed);
   end

   always begin
      #10;
      clk = ~clk;
   end


   Button dut(.button(button),
              .pressed(pressed),
              .pulse(pulse),
              .clk(clk));

   task tick;
      @(posedge clk);
      #1;
   endtask // tick

   task tock;
      @(negedge clk);
      #1;
   endtask // tock

   initial begin
      tick();
      tock();
      tick();
      tock();
      button = 1;
      #200;
      $finish;
   end
endmodule // Button_TB
