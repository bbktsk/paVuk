`include "defs.v"

module PCOnULX3S(input            clk_25mhz,
                 input [6:0]      btn,
                 input [3:0]      sw,
                 output reg [7:0] led,
                 output           wifi_gpio0);

   // Tie GPIO0, keep board from rebooting
   assign wifi_gpio0 = 1'b1;

   wire [`XBUS] current;

   reg [`PC_MODE_MSB:0] mode;
   reg [`XBUS]          update;
   reg                  update_en;

   ProgramCounter pc(.clk(clk_25mhz),
                     .current(current),
                     .mode(mode),
                     .update(update),
                     .update_en(update_en)
                     );

   assign update_en = btn[1]; // button F1
   assign mode = 1;
 //btn[5:4];
   assign update = {28'b0,sw[3:0]};

   always @(*) begin
      if (btn[2])
        led = current[7:0];
      else
        led = current[29:22];
   end
endmodule
