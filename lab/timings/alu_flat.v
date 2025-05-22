`include "defs.v"

module alu(input [`XMSB:0]       a,
           input [`XMSB:0]       b,
           input                 is_cond,
           input [`ALU_OP_MSB:0] op,

           output reg [`XMSB:0]  result);

   always @(*) begin
      result[`XMSB:1] = 0;
      case ({is_cond, op})
        {1'b1, `ALU_OP_EQ}: result[0] = a == b;
        {1'b1, `ALU_OP_NE}: result[0] = a != b;
        {1'b1, `ALU_OP_LT}: result[0] = $signed(a) < $signed(b);
        {1'b1, `ALU_OP_GE}: result[0] = $signed(a) >= $signed(b);
        {1'b1, `ALU_OP_LTU}: result[0] = a < b;
        {1'b1, `ALU_OP_GEU}: result[0] = a >= b;

        {1'b0, `ALU_OP_ADD}:  result = a + b;
        {1'b0, `ALU_OP_SUB}:  result = a - b;
        {1'b0, `ALU_OP_SLL}:  result = a << b[4:0];
        {1'b0, `ALU_OP_SLT}:  result[0] = $signed(a) < $signed(b);
        {1'b0, `ALU_OP_SLTU}: result[0] = a < b;
        {1'b0, `ALU_OP_XOR}:  result = a ^ b;
        {1'b0, `ALU_OP_SRL}:  result = a >> b[4:0];
        {1'b0, `ALU_OP_SRA}:  result = $signed(a) >>> b[4:0];
        {1'b0, `ALU_OP_OR}:   result = a | b;
        {1'b0, `ALU_OP_AND}:  result = a & b;
        default:     result = 'hdeadbeef;
      endcase
   end
endmodule
