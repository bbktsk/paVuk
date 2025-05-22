%.bit : %.v
	yosys -p "read_verilog -I ../../src $<; synth_ecp5 -json $*.gen.json"
	nextpnr-ecp5 --85k --json $*.gen.json --randomize-seed \
		--package CABGA756 \
		--lpf fake_alu.lpf \
		--textcfg $*.gen.config
	ecppack $*.gen.config $@


.PHONY = fake_alu_top
fake_alu_top: fake_alu_top.bit
