.PHONY: clean
clean:
	rm -rf *.gen.{json,config} blinky.bit


%.bit : %.v
	yosys -p "read_verilog $<; synth_ecp5 -json $*.gen.json"
	nextpnr-ecp5 --85k --json $*.gen.json \
		--lpf ulx3s_v20.lpf \
		--textcfg $*.gen.config
	ecppack $*.gen.config $@

prog: blinky.bit
	openFPGALoader --board=ulx3s blinky.bit

test:
	iverilog -g2012  -o blinky_tb.gen.vvp blinky_tb.v blinky.v
	vvp blinky_tb.gen.vvp
