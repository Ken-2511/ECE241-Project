# filename: player_testbench.tcl

# stop any simulation that is currently running
quit -sim

# if simulating with a MIF file, copy it to the working folder. Assumes image.colour.mif
foreach file [glob -nocomplain ../*.mif] {
    set filename [file tail $file]
    file delete -force $filename
    file copy $file .
}

# create the default "work" library
vlib work;

# compile the Verilog source code in the parent folder
vlog ../vga_adapter/*.v
# vlog ..PS2_Controller/*.v
vlog *.v
vlog ../*.v
# start the Simulator, including some libraries that may be needed
vsim work.player_testbench -Lf 220model -Lf altera_mf_ver -Lf verilog
# show waveforms specified in wave.do
do player_wave.do
# advance the simulation the desired amount of time
run 1000 ns
