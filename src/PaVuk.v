`include "defs.v"

`include "ProgramCounter.v"
`include "ROM.v"
`include "Decoder.v"
`include "Registers.v"
`include "ALU.v"
`include "Button.v"

module PaVuk #(parameter rom_content = "sumseq20.mem")
   (input              clk,
    input              run,
    output reg [`XBUS] result);


   wire [`XBUS] inst;
   wire [`XBUS] pc_current;
   wire [`R_MSB:0] rs1;
   wire [`R_MSB:0] rs2;
   wire [`R_MSB:0] rd;

   wire            is_cond;
   wire [`ALU_OP_MSB:0] alu_op;
   wire [`XBUS]         alu_op1;
   wire [`XBUS]         alu_op2;
   wire [`XBUS]         alu_op2_reg;
   wire [`XBUS]         alu_op2_imm;
   wire [`XBUS]         alu_result;

   wire                 op2_is_imm;

   wire [`XBUS]         pc_update;
   wire [`PC_MODE_MSB:0] pc_mode;
   wire [`PC_MODE_MSB:0] pc_mode_if_taken;

   wire                  act_write_reg;
   wire                  act_ecall;

   wire                  pc_update_en;
   wire                  reg_wr_en;
   wire                  ecall_en;

   // All non-B instruction set pc_mode_if_taken to the correct value,
   // either by default (non-Jx), or explicitly (Jx).
   // Ie., all non-B instructions are considered "taken" even if that means just
   // a regular increment.
   // Here we just handle the case of B with false condition
   assign pc_mode = (is_cond & !alu_result[0]) ? `PC_MODE_INC : pc_mode_if_taken;

   assign alu_op2 = op2_is_imm ? alu_op2_imm : alu_op2_reg;

   // Make sure that all stateful components are properly enabled/disabled
   // here based on run and other signals
   assign reg_wr_en = run && act_write_reg;
   assign pc_update_en = run;
   assign ecall_en = run && act_ecall;

   ProgramCounter pc(.current(pc_current),
                     .update(pc_update),
                     .mode(pc_mode),
                     .update_en(pc_update_en),
                     .clk(clk));

   ROM #(.content(rom_content)) rom
     (.addr(pc_current),
      .data(inst));

   Decoder decoder(.inst(inst),

                   .rs1(rs1),
                   .rs2(rs2),
                   .rd(rd),

                   .op2_is_imm(op2_is_imm),
                   .imm(alu_op2_imm),
                   .act_write_reg(act_write_reg),

                   .is_cond(is_cond),
                   .alu_op(alu_op),

                   .pc_update(pc_update),
                   .pc_mode_if_taken(pc_mode_if_taken),

                   .act_ecall(act_ecall));

   Registers regs(.rd_addr1(rs1),
                  .rd_data1(alu_op1),

                  .rd_addr2(rs2),
                  .rd_data2(alu_op2_reg),

                  .wr_addr(rd),
                  .wr_data(alu_result),
                  .wr_en(reg_wr_en),
                  .clk(clk));

   ALU alu(.op1(alu_op1),
           .op2(alu_op2),
           .is_cond(is_cond),
           .op(alu_op),
           .result(alu_result));

   initial begin
      result = 0;
   end

   always @(posedge clk) begin
      if (ecall_en)
        result <= alu_result;
   end

endmodule
