# stop any simulation that is currently running
quit -sim

# if simulating with a MIF file, copy it to the working folder. Assumes image.colour.mif
if {[file exists ../black.mif]} {
	file delete black.mif
	file copy ../black.mif .
}

# create the default "work" library
vlib work;

# compile the Verilog source code in the parent folder
vlog ../milestone1.v ../vga_adapter/*.v ../utils.v *.v ../*.v ../PS2_Controller/*
# start the Simulator, including some libraries that may be needed
vsim work.testbench -Lf 220model -Lf altera_mf_ver -Lf verilog
# show waveforms specified in wave.do
do wave.do
# advance the simulation the desired amount of time
run 100000 ns
