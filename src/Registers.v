`include "defs.v"

module Registers(input [`R_MSB:0]   rd_addr1,
                 output reg [`XBUS] rd_data1,

                 input [`R_MSB:0]   rd_addr2,
                 output reg [`XBUS] rd_data2,

                 input [`R_MSB:0]   wr_addr,
                 input [`XBUS]      wr_data,
                 input              wr_en,

                 input              clk
                 );


   reg [`XBUS] regs [`R_LAST:0];


   initial begin
      rd_data1 = 0;
      rd_data2 = 0;

      for (integer i = 0; i < `R_COUNT; i = i+1)
        regs[i] = 0;
    end

   always @(*) begin
      rd_data1 = regs[rd_addr1];
      rd_data2 = regs[rd_addr2];
   end

   always @(posedge clk) begin
      if (wr_en && wr_addr != 0)
        regs[wr_addr] <= wr_data;
   end
endmodule
