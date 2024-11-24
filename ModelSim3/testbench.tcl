quit -sim

vlib work;

vlog ../*.v;
vlog *.v;
vsim work.testbench -Lf 220model_ver -Lf altera_mf_ver -Lf verilog

do wave.do

run 120ns
