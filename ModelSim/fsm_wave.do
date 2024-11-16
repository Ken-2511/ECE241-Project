onerror {resume}
quietly WaveActivateNextPane {} 0

# Clock and Reset signals
add wave -noupdate -label clock -radix binary /fsm_testbench/clock
add wave -noupdate -label resetn -radix binary /fsm_testbench/resetn
add wave -noupdate -label enable -radix binary /fsm_testbench/enable
add wave -noupdate -label key3 -radix binary /fsm_testbench/key3

# Game State Control Signals
add wave -noupdate -divider game_state_control
add wave -noupdate -label game_state -radix binary /fsm_testbench/UUT/game_state
add wave -noupdate -label next_game_state -radix binary /fsm_testbench/UUT/next_game_state
add wave -noupdate -label e_greeting -radix binary /fsm_testbench/UUT/e_greeting
add wave -noupdate -label f_greeting -radix binary /fsm_testbench/UUT/f_greeting
add wave -noupdate -label e_playing -radix binary /fsm_testbench/UUT/e_playing
add wave -noupdate -label f_playing -radix binary /fsm_testbench/UUT/f_playing
add wave -noupdate -label e_game_over -radix binary /fsm_testbench/UUT/e_game_over
add wave -noupdate -label f_game_over -radix binary /fsm_testbench/UUT/f_game_over

# Greeting Module Signals
add wave -noupdate -divider m_greeting
add wave -noupdate -label enable_greeting -radix binary /fsm_testbench/UUT/m_greeting/enable
add wave -noupdate -label finished_greeting -radix binary /fsm_testbench/UUT/m_greeting/finished

# Playing Module Signals
add wave -noupdate -divider m_playing
add wave -noupdate -label enable_playing -radix binary /fsm_testbench/UUT/m_playing/enable
add wave -noupdate -label game_state_playing -radix binary /fsm_testbench/UUT/m_playing/game_state
add wave -noupdate -label next_game_state_playing -radix binary /fsm_testbench/UUT/m_playing/next_game_state
add wave -noupdate -label e_clear_screen -radix binary /fsm_testbench/UUT/m_playing/e_clear_screen
add wave -noupdate -label e_update_position -radix binary /fsm_testbench/UUT/m_playing/e_update_position
add wave -noupdate -label e_eat_food -radix binary /fsm_testbench/UUT/m_playing/e_eat_food
add wave -noupdate -label e_ghost_collision -radix binary /fsm_testbench/UUT/m_playing/e_ghost_collision
add wave -noupdate -label finished_playing -radix binary /fsm_testbench/UUT/m_playing/finished

# Submodules within Playing Module Signals
add wave -noupdate -divider submodules_playing
add wave -noupdate -label f_clear_screen -radix binary /fsm_testbench/UUT/m_playing/f_clear_screen
add wave -noupdate -label f_update_position -radix binary /fsm_testbench/UUT/m_playing/f_update_position
add wave -noupdate -label f_eat_food -radix binary /fsm_testbench/UUT/m_playing/f_eat_food
add wave -noupdate -label f_update_ghost_directions -radix binary /fsm_testbench/UUT/m_playing/f_update_ghost_directions
add wave -noupdate -label f_update_ghost_positions -radix binary /fsm_testbench/UUT/m_playing/f_update_ghost_positions
add wave -noupdate -label f_fill_screen -radix binary /fsm_testbench/UUT/m_playing/f_fill_screen
add wave -noupdate -label f_render_blocks -radix binary /fsm_testbench/UUT/m_playing/f_render_blocks
add wave -noupdate -label f_render_player -radix binary /fsm_testbench/UUT/m_playing/f_render_player
add wave -noupdate -label f_render_food -radix binary /fsm_testbench/UUT/m_playing/f_render_food
add wave -noupdate -label f_render_ghosts -radix binary /fsm_testbench/UUT/m_playing/f_render_ghosts
add wave -noupdate -label f_ghost_collision -radix binary /fsm_testbench/UUT/m_playing/f_ghost_collision

# Game Over Module Signals
add wave -noupdate -divider m_game_over
add wave -noupdate -label enable_game_over -radix binary /fsm_testbench/UUT/m_game_over/enable
add wave -noupdate -label finished_game_over -radix binary /fsm_testbench/UUT/m_game_over/finished

# Arbiter Signals
add wave -noupdate -divider arbiter
add wave -noupdate -label requests -radix binary /fsm_testbench/UUT/arbiter/requests
add wave -noupdate -label grant -radix binary /fsm_testbench/UUT/arbiter/grant

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