`include "defs.v"


module ROM #(parameter content = "sumseq20.mem")
   (input [`XBUS]      addr,
    output reg [`XBUS] data);

   reg [`XBUS] rom[256];

   initial begin
      $readmemh(content, rom);
   end

   always @(*) data = rom[{addr[9:2]}];
endmodule
