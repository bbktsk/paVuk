`timescale 1ns/100ps

`default_nettype none

module blinky_tb();
   reg        clk;
   reg [6:0]  btn;
   wire [7:0] led;
   wire       wifi_gpio0;

   blinky dut (.clk_25mhz(clk),
               .btn(btn),
               .led(led),
               .wifi_gpio0(wifi_gpio0));

   wire led_lsb;
   wire led_button;

   assign led_lsb = led[7];
   assign led_button = led[6];

   initial begin
      $dumpfile("blinky_tb.vcd");
      $dumpvars(0, blinky_tb);
   end

   initial begin
      clk = 0;
      btn = 0;
   end

   always begin
      #100;
      clk = ~clk;
   end

   initial begin
      #50;
      // test the initial state
      assert(led_lsb == 0);
      assert(wifi_gpio0 == 1);

      // test that the LSB LED toggles after each clock posedge
      #200;
      assert(led_lsb == 1);
      #200;
      assert(led_lsb == 0);
      #200;
      assert(led_lsb == 1);

      // test that the button led responds to the button press
      assert(led_button == 0);
      btn[1] = 1;
      #200;
      assert(led_button == 1);
      btn[1] = 0;
      #200;
      assert(led_button == 0);

      $finish;
   end
endmodule
