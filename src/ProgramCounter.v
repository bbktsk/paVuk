`include "defs.v"

module ProgramCounter(input [`PC_MODE_MSB:0] mode,

                      input [`XBUS]          update,

                      input                  update_en,
                      output reg [`XBUS]     current,
                      output [`XBUS]         next,

                      input                  clk
                      );

   assign next = current + 4;

   initial begin
      current = 0;
   end

   always @(posedge clk) begin
      if (update_en) begin
         case (mode)
           `PC_MODE_INC: current <= next;
           `PC_MODE_ADD: current <= current + update;
           `PC_MODE_SET: current <= update;
           default: current <= current;  // TODO: exc?
         endcase // case (mode)
      end
   end
endmodule // ProgramCounter
