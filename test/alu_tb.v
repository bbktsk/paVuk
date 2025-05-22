`timescale 1ns/100ps

`include "defs.v"

`default_nettype none

module alu_tb();
   reg [`XBUS] a;
   reg [`XBUS] b;
   reg           is_cond;
   reg [`ALU_OP_MSB:0] op;
   wire [`XBUS]      result;

   alu dut (.a(a),
            .b(b),
            .op(op),
            .is_cond(is_cond),
            .result(result));

   integer data_file;
   integer io_code;
   string data_line;
   string op_name;

   reg [`XBUS] expected;

   initial begin
      $dumpfile("alu_tb.vcd");
      $dumpvars(0, alu_tb);

      data_file = $fopen("alu_tb.csv", "r");
      if (data_file == 0) begin
         $display("Error opening alu_tb.csv");
         $finish;
      end
   end

   always begin
      io_code = $fscanf(data_file, "%s\n", data_line);

      if (data_line[0] == 33) begin // 33 is '!' and marks instuction definition
         io_code = $sscanf(data_line, "!,%d,%d,%s\n", is_cond, op, op_name);
         if (io_code != 3) begin
            $display("Failed to parse op description %s =%d", data_line, io_code);
            $finish;
         end
      end else begin
         io_code = $sscanf(data_line, "%b,%b,%b", a, b, expected);
         if (io_code != 3) begin
            $display("Failed to parse test case %s", data_line);
            $finish;
         end
         #1;
         assert (result == expected)
           //$display("PASS@%0t: %s cnd=%01b op=%04b a=%08x b=%08x res=%08x exp=%08x",
           //         $time, op_name, is_cond, op, a, b, result, expected);
         else
           $display("FAIL@%0t: %s cnd=%01b op=%04b a=%08x b=%08x res=%08x exp=%08x",
                    $time, op_name, is_cond, op, a, b, result, expected);
      end
      if ($feof(data_file))
        $finish;
   end
endmodule
