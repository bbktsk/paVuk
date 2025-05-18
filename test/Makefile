.PHONY = alu_tb

SRC = ../src
IVERILOG = iverilog -g2012 -I$(SRC)

alu_tb:
	$(IVERILOG) -o alu_tb.gen.vvp alu_tb.v $(SRC)/alu.v
	vvp alu_tb.gen.vvp
