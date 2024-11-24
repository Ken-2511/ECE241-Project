quit -sim

vlib work;

# if simulating with a MIF file, copy it to the working folder. Assumes image.colour.mif
foreach file [glob -nocomplain ../*.mif] {
    set filename [file tail $file]
    file delete -force $filename
    file copy $file .
}

vlog ../*.v;
vlog *.v;
vsim work.testbench -Lf 220model_ver -Lf altera_mf_ver -Lf verilog

do wave.do

run 1200ns
