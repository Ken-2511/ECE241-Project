# Filename: food_wave.do

onerror {resume}
quietly WaveActivateNextPane {} 0

# Clock and Reset signals
add wave -noupdate -label clock -radix binary /food_testbench/clock
add wave -noupdate -label resetn -radix binary /food_testbench/resetn
add wave -noupdate -label enable -radix binary /food_testbench/enable

# Render Food Module Signals
add wave -noupdate -divider m_render_food
add wave -noupdate -label wren -radix binary /food_testbench/UUT/wren
add wave -noupdate -label finished -radix binary /food_testbench/UUT/finished
add wave -noupdate -label addr -radix unsigned /food_testbench/UUT/addr
add wave -noupdate -label data -radix hexadecimal /food_testbench/UUT/data

# Submodules within Render Food Module Signals
add wave -noupdate -divider onchip_memory
add wave -noupdate -label wren -radix binary /food_testbench/UUT/FOOD/wren
add wave -noupdate -label address -radix unsigned /food_testbench/UUT/FOOD/address
add wave -noupdate -label q -radix hexadecimal /food_testbench/UUT/FOOD/q

# Coordinates
add wave -noupdate -divider coordinates
add wave -noupdate -label game_x -radix unsigned /food_testbench/UUT/game_x
add wave -noupdate -label game_y -radix unsigned /food_testbench/UUT/game_y

TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {10000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 80
configure wave -valuecolwidth 40
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
update
WaveRestoreZoom {0 ps} {700 ns}
