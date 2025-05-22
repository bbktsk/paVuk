`include "alu.v"

module top(input  clk_25mhz,
           input  [31:0] a,
           input  [31:0] b,
           input  is_cond,
           input  [3:0] op,

           output [31:0] r);

   reg [31:0] r_a;
   reg [31:0] r_b;
   reg        r_is_cond;
   reg [3:0]  r_op;

   alu alu(.a(r_a),
           .b(r_b),
           .is_cond(r_is_cond),
           .op(r_op),
           .result(r));

   always @(posedge clk_25mhz) begin
      r_a <= a;
      r_b <= b;
      r_is_cond <= is_cond;
      r_op <= op;
   end
endmodule
