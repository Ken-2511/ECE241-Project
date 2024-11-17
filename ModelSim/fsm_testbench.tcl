# stop any simulation that is currently running
quit -sim

# if simulating with a MIF file, copy it to the working folder. Assumes image.colour.mif
if {[file exists ../black.mif]} {
	file delete black.mif
	file copy ../black.mif .
}
if {[file exists ../canvas.mif]} {
	file delete canvas.mif
	file copy ../canvas.mif .
}
if {[file exists ../player.mif]} {
	file delete player.mif
	file copy ../player.mif .
}
if {[file exists ../food.mif]} {
	file delete food.mif
	file copy ../food.mif .
}

# create the default "work" library
vlib work;

# compile the Verilog source code in the parent folder
vlog ../milestone2.v
vlog ../vga_adapter/*.v
vlog ../utils.v
vlog *.v
vlog ../*.v
# start the Simulator, including some libraries that may be needed
vsim work.fsm_testbench -Lf 220model -Lf altera_mf_ver -Lf verilog
# show waveforms specified in wave.do
do fsm_wave.do
# advance the simulation the desired amount of time
run 1600000 ns
