`include "defs.v"

module ALU(input [`XBUS]         op1,
           input [`XBUS]         op2,
           input                 is_cond,
           input [`ALU_OP_MSB:0] op,

           output reg [`XBUS]    result);

   always @(*) begin
      if (is_cond) begin
         // we set only lsb of result, rest is zero
        result[`XMSB:1] = 0;
        case (op)
          `ALU_OP_EQ: result[0] = op1 == op2;
          `ALU_OP_NE: result[0] = op1 != op2;
          `ALU_OP_LT: result[0] = $signed(op1) < $signed(op2);
          `ALU_OP_GE: result[0] = $signed(op1) >= $signed(op2);
          `ALU_OP_LTU: result[0] = op1 < op2;
          `ALU_OP_GEU: result[0] = op1 >= op2;
          default: result = 'hbaddcafe;
        endcase // case (op)
      end else
        case (op)
          `ALU_OP_ADD:  result = op1 + op2;
          `ALU_OP_SUB:  result = op1 - op2;
          `ALU_OP_SLL:  result = op1 << op2[4:0];
          `ALU_OP_SLT:  result = {{(`XLEN-1){1'b0}}, $signed(op1) < $signed(op2)};
          `ALU_OP_SLTU: result = {{(`XLEN-1){1'b0}}, op1 < op2};
          `ALU_OP_XOR:  result = op1 ^ op2;
          `ALU_OP_SRL:  result = op1 >> op2[4:0];
          `ALU_OP_SRA:  result = $signed(op1) >>> op2[4:0];
          `ALU_OP_OR:   result = op1 | op2;
          `ALU_OP_AND:  result = op1 & op2;
        default:     result = 'hdeadbeef;
        endcase // case (op)
   end
endmodule
