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

ROM_TB:
	$(IVERILOG) -D BK_TEST -o ROM_TB.gen.vvp ROM_TB.v $(SRC)/ROM.v
	vvp ROM_TB.gen.vvp

Decoder_TB:
	$(IVERILOG) -D BK_TEST -o Decoder_TB.gen.vvp Decoder_TB.v $(SRC)/Decoder.v
	vvp Decoder_TB.gen.vvp

ExecChain_TB:
	$(IVERILOG) -D BK_TEST -o ExecChain_TB.gen.vvp ExecChain_TB.v $(SRC)/PaVuk.v
	vvp ExecChain_TB.gen.vvp

PaVuk_TB:
	$(IVERILOG) -D BK_TEST -o PaVuk_TB.gen.vvp PaVuk_TB.v $(SRC)/PaVuk.v
	vvp PaVuk_TB.gen.vvp

all: ALU_TB Registers_TB ProgramCounter_TB Button_TB ROM_TB Decoder_TB ExecChain_TB PaVuk_TB
	@echo
	@echo "*** All tests passed ***"
