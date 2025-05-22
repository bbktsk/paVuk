#! /bin/bash

for f in baseline.v alu_flat_full_width.v alu_flat.v alu_full_width_cond.v alu_prezero_everywhere.v ; do
    name=$(basename $f .v)
    ln -sf $f alu.v
    yosys -p "read_verilog -I ../../src fake_alu_top.v ; synth_ecp5 -json fake_alu_top.gen.json" 2>&1 > /dev/null
    for n in $(seq 1 2000) ; do
        nextpnr-ecp5 --85k --json fake_alu_top.gen.json --seed $n \
                     --package CABGA756 \
                     --lpf fake_alu.lpf \
                     --textcfg fake_alu_top.gen.config 2>&1 |
            grep -E 'logic.*routing' | tail -n 1 | awk -v name=$name -v n=$n -- ' { print name, ",", n, ",", $2,",", $5; }'
    done
done
