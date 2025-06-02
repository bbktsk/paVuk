yosys -p "read_verilog -sv -I ../../src ItsAlive.v ; synth_ecp5 -json ItsAlive.gen.json"
name=PaVuk
for n in $(seq 1 10000) ; do
    nextpnr-ecp5 --85k --json ItsAlive.gen.json --seed $n \
                 --package CABGA381 \
                 --lpf ../../src/ulx3s_v20.lpf \
                 --textcfg ItsAlive.gen.config 2>&1 |
        grep -E 'Max frequency for clock' | tail -n 1 | awk -v name=$name -v n=$n -- ' { print name, ",", n, ",", $7 }'
done
