# filename: fsm.tcl

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
vlog ../fsm.v
vlog ./_fsm.v

# start the Simulator, including some libraries that may be needed
vsim work.fsm_tb -Lf 220model -Lf altera_mf_ver -Lf verilog
# show waveforms specified in wave.do
do _fsm.do
# advance the simulation the desired amount of time
run 300 ns
