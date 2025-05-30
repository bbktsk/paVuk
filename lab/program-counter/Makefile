.PHONY: clean
clean:
	rm -rf *.gen.{json,config} blinky.bit


PCOnULX3S.bit :
	yosys -p "read_verilog -I ../../src PCOnULX3S.v ../../src/ProgramCounter.v; synth_ecp5 -json $*.gen.json"
	nextpnr-ecp5 --85k --json $*.gen.json \
		--lpf ../../src/ulx3s_v20.lpf \
		--textcfg $*.gen.config
	ecppack $*.gen.config $@

prog: PCOnULX3S.bit
	openFPGALoader --board=ulx3s PCOnULX3S.bit
