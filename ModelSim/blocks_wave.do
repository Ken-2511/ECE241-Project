# Filename: blocks_wave.do

onerror {resume}
quietly WaveActivateNextPane {} 0

# Clock and Reset signals
add wave -noupdate -label clock -radix binary /blocks_testbench/clock
add wave -noupdate -label resetn -radix binary /blocks_testbench/resetn
add wave -noupdate -label enable -radix binary /blocks_testbench/enable

# Render Blocks Module Signals
add wave -noupdate -divider m_render_blocks
add wave -noupdate -label wren -radix binary /blocks_testbench/UUT/wren
add wave -noupdate -label finished -radix binary /blocks_testbench/UUT/finished
add wave -noupdate -label addr -radix unsigned /blocks_testbench/UUT/addr
add wave -noupdate -label data -radix hexadecimal /blocks_testbench/UUT/data

# Block Memory Signals
add wave -noupdate -divider block_memory
add wave -noupdate -label blk_addr -radix unsigned /blocks_testbench/UUT/blk_addr
add wave -noupdate -label blk_wren -radix binary /blocks_testbench/UUT/blk_wren
add wave -noupdate -label blk_q -radix binary /blocks_testbench/UUT/blk_q

# Game Coordinates
add wave -noupdate -divider game_coordinates
add wave -noupdate -label maze_x -radix unsigned /blocks_testbench/UUT/maze_x
add wave -noupdate -label maze_y -radix unsigned /blocks_testbench/UUT/maze_y

# Hold Initial Flag
add wave -noupdate -divider control_flags
add wave -noupdate -label hold_initial -radix binary /blocks_testbench/UUT/hold_initial

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
wave cursor configure 1 -time 7600ns
update
WaveRestoreZoom {0 ps} {700 ns}
