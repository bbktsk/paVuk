`include "defs.v"

`include "PaVuk.v"

module ItsAlive(input        clk_25mhz,
                input [6:0]  btn,
                output [7:0] led,
                output       wifi_gpio0);

   assign wifi_gpio0 = 1'b1;
   wire run;

   wire [`XBUS] result;
   wire [7:0]   result_low;

   assign result_low = result[7:0];
   assign led = result_low;

   Button button_run(.button(btn[1]),
                     .pressed(run),
                     .clk(clk_25mhz));


   PaVuk #(.rom_content("../../test/sumseq20.mem"))
   cpu (.clk(clk_25mhz),
        .run(run),
        .result(result));
endmodule
