module blinky(input        clk_25mhz,
              input [6:0]  btn,
              output [7:0] led,
              output       wifi_gpio0);

   wire i_clk;

   // Tie GPIO0, keep board from rebooting
   assign wifi_gpio0 = 1'b1;
   assign i_clk = clk_25mhz;

   localparam ctr_width = 32;
   reg [ctr_width-1:0] ctr = 0;

   // leftmost led is LSB of the counter, for easy testing
   assign led[7] = ctr[0];
   // next led shows the button
   assign led[6] = btn[1];
   // human-compatible blinky
   assign led[5:0] = ctr[26:21];

   always @(posedge i_clk) begin
      ctr = ctr + 1;
   end

endmodule
