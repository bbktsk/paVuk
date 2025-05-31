.PHONY = alu_tb

SRC = ../src
IVERILOG = iverilog -g2012 -I$(SRC)

ALU_TB:
	$(IVERILOG) -o ALU_TB.gen.vvp ALU_TB.v $(SRC)/ALU.v
	vvp ALU_TB.gen.vvp

Registers_TB:
	$(IVERILOG) -o Registers_TB.gen.vvp Registers_TB.v $(SRC)/Registers.v
	vvp Registers_TB.gen.vvp

ProgramCounter_TB:
	$(IVERILOG) -o ProgramCounter_TB.gen.vvp ProgramCounter_TB.v $(SRC)/ProgramCounter.v
	vvp ProgramCounter_TB.gen.vvp

Button_TB:
	$(IVERILOG) -D BK_TEST -o Button_TB.gen.vvp Button_TB.v $(SRC)/Button.v
	vvp Button_TB.gen.vvp
