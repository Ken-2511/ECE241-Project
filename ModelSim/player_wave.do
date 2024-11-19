onerror {resume}
quietly WaveActivateNextPane {} 0

# Clock and Reset signals
add wave -noupdate -label clock -radix binary /player_testbench/clock
add wave -noupdate -label resetn -radix binary /player_testbench/resetn
add wave -noupdate -label enable -radix binary /player_testbench/enable

# Game coordinates and direction
add wave -noupdate -divider game_coordinates_and_direction
add wave -noupdate -label game_x -radix unsigned /player_testbench/game_x
add wave -noupdate -label game_y -radix unsigned /player_testbench/game_y
add wave -noupdate -label direct -radix binary /player_testbench/direct

# Outputs from the module
add wave -noupdate -divider module_outputs
add wave -noupdate -label wren -radix binary /player_testbench/wren
add wave -noupdate -label finished -radix binary /player_testbench/finished
add wave -noupdate -label addr -radix decimal /player_testbench/addr
add wave -noupdate -label data -radix hexadecimal /player_testbench/data
add wave -noupdate -label VGA_X -radix unsigned /player_testbench/VGA_X
add wave -noupdate -label VGA_Y -radix unsigned /player_testbench/VGA_Y
add wave -noupdate -label VGA_COLOR -radix hexadecimal /player_testbench/VGA_COLOR

# Player render signals
add wave -noupdate -divider player
add wave -noupdate -label addr -radix unsigned /player_testbench/UUT/U2/address
add wave -noupdate -label q -radix hexadecimal /player_testbench/UUT/U2/q

# Configure the wave window layout
configure wave -namecolwidth 100
configure wave -valuecolwidth 50
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns

# Update the wave window
update
WaveRestoreZoom {0 ps} {500 ns}
