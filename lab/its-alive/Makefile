.PHONY: clean
clean:
	rm -rf *.gen.{json,config} ItsAlive.bit

%.bit : %.v
	yosys -p "read_verilog -sv -I ../../src $<; synth_ecp5 -json $*.gen.json"
	nextpnr-ecp5 --85k --json $*.gen.json \
		--lpf ../../src/ulx3s_v20.lpf \
		--package CABGA381 \
		--textcfg $*.gen.config
	ecppack $*.gen.config $@

prog: ItsAlive.bit
	openFPGALoader --board=ulx3s ItsAlive.bit
