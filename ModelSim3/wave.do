# Filename: m_game_logic_wave.do

# Turn off error reporting to continue simulation in case of errors
onerror {resume}
quietly WaveActivateNextPane {} 0

# Clock and Reset signals
add wave -noupdate -label clock -radix binary /testbench/CLOCK_50
add wave -noupdate -label resetn -radix binary /testbench/resetn
add wave -noupdate -label enable -radix binary /testbench/enable

# Game Logic Module Signals
add wave -noupdate -divider m_game_logic
add wave -noupdate -label player_x -radix unsigned /testbench/logic/player_x
add wave -noupdate -label player_y -radix unsigned /testbench/logic/player_y
add wave -noupdate -label score -radix unsigned /testbench/logic/score
add wave -noupdate -label state -radix binary /testbench/logic/state

# finished signals
add wave -noupdate -label f_wall_collision -radix binary /testbench/logic/f_wall_collision
add wave -noupdate -label f_update_player_position -radix binary /testbench/logic/f_update_player_position
add wave -noupdate -label f_update_ghost_positions -radix binary /testbench/logic/f_update_ghost_positions
add wave -noupdate -label f_eat_food -radix binary /testbench/logic/f_eat_food
add wave -noupdate -label finished -radix binary /testbench/logic/finished
add wave -noupdate -label food_dot -radix binary /testbench/logic/food_dot
add wave -noupdate -label address_food -radix hexadecimal /testbench/logic/address_food

# Input Signals
add wave -noupdate -divider inputs
add wave -noupdate -label last_key_received -radix binary /testbench/last_key_received

# Additional Signals if needed
add wave -noupdate -divider internal
add wave -noupdate -label state -radix binary /testbench/logic/state
add wave -noupdate -label next_state -radix binary /testbench/logic/next_state
add wave -noupdate -label collision -radix binary /testbench/logic/collision

# Update the tree view
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
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
WaveRestoreZoom {0 ps} {1 us}
