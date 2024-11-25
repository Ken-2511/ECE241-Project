# filename: _fsm.do

# Filename: fsm_game_state_wave.do

onerror {resume}
quietly WaveActivateNextPane {} 0

# Clock and Reset signals
add wave -noupdate -label clock -radix binary /fsm_tb/clock
add wave -noupdate -label resetn -radix binary /fsm_tb/resetn
add wave -noupdate -label enable -radix binary /fsm_tb/enable
add wave -noupdate -label last_key_received -radix hexadecimal /fsm_tb/last_key_received

# FSM Signals
add wave -noupdate -divider fsm_signals
add wave -noupdate -label state -radix unsigned /fsm_tb/uut/state
add wave -noupdate -label next_state -radix unsigned /fsm_tb/uut/next_state
add wave -noupdate -label e_greeting -radix binary /fsm_tb/uut/e_greeting
add wave -noupdate -label e_logic -radix binary /fsm_tb/uut/e_logic
add wave -noupdate -label e_render -radix binary /fsm_tb/uut/e_render
add wave -noupdate -label e_game_over -radix binary /fsm_tb/uut/e_game_over

# Completion Signals
add wave -noupdate -divider completion_signals
add wave -noupdate -label greeting_done -radix binary /fsm_tb/uut/greeting_done
add wave -noupdate -label logic_done -radix binary /fsm_tb/uut/logic_done
add wave -noupdate -label render_done -radix binary /fsm_tb/uut/render_done
add wave -noupdate -label game_over_done -radix binary /fsm_tb/uut/game_over_done

# Collision Detection Signals
add wave -noupdate -divider collision_signals
add wave -noupdate -label collision_detected -radix binary /fsm_tb/uut/collision_detected

# VGA Outputs
add wave -noupdate -divider vga_signals
add wave -noupdate -label VGA_X -radix unsigned /fsm_tb/uut/VGA_X
add wave -noupdate -label VGA_Y -radix unsigned /fsm_tb/uut/VGA_Y
add wave -noupdate -label VGA_COLOR -radix hexadecimal /fsm_tb/uut/VGA_COLOR
add wave -noupdate -label bg_color -radix hexadecimal /fsm_tb/uut/bg_color
add wave -noupdate -label bg_x -radix unsigned /fsm_tb/uut/bg_x
add wave -noupdate -label bg_y -radix unsigned /fsm_tb/uut/bg_y

# Player Position
add wave -noupdate -divider player_signals
add wave -noupdate -label player_x -radix unsigned /fsm_tb/uut/player_x
add wave -noupdate -label player_y -radix unsigned /fsm_tb/uut/player_y

# Ghost Positions
add wave -noupdate -divider ghost_signals
add wave -noupdate -label ghost1_x -radix unsigned /fsm_tb/uut/ghost1_x
add wave -noupdate -label ghost1_y -radix unsigned /fsm_tb/uut/ghost1_y
add wave -noupdate -label ghost2_x -radix unsigned /fsm_tb/uut/ghost2_x
add wave -noupdate -label ghost2_y -radix unsigned /fsm_tb/uut/ghost2_y
add wave -noupdate -label ghost3_x -radix unsigned /fsm_tb/uut/ghost3_x
add wave -noupdate -label ghost3_y -radix unsigned /fsm_tb/uut/ghost3_y

# Delayed Ghost Positions
add wave -noupdate -divider ghost_signals
add wave -noupdate -label ghost1_x_ -radix unsigned /fsm_tb/uut/renderer_inst/g1_game_x_
add wave -noupdate -label ghost1_y_ -radix unsigned /fsm_tb/uut/renderer_inst/g1_game_y_
add wave -noupdate -label ghost2_x_ -radix unsigned /fsm_tb/uut/renderer_inst/g2_game_x_
add wave -noupdate -label ghost2_y_ -radix unsigned /fsm_tb/uut/renderer_inst/g2_game_y_
add wave -noupdate -label ghost3_x_ -radix unsigned /fsm_tb/uut/renderer_inst/g3_game_x_
add wave -noupdate -label ghost3_y_ -radix unsigned /fsm_tb/uut/renderer_inst/g3_game_y_

# PS2 Controller Input
add wave -noupdate -divider ps2_signals
add wave -noupdate -label last_key_received -radix hexadecimal /fsm_tb/uut/last_key_received

# Renderer
add wave -noupdate -divider renderer_signals
add wave -noupdate -label render_index -radix unsigned /fsm_tb/uut/renderer_inst/render_index
add wave -noupdate -label finished -radix binary /fsm_tb/uut/renderer_inst/finished
add wave -noupdate -label state -radix unsigned /fsm_tb/uut/renderer_inst/state
add wave -noupdate -label curr_x -radix unsigned /fsm_tb/uut/renderer_inst/curr_x
add wave -noupdate -label curr_y -radix unsigned /fsm_tb/uut/renderer_inst/curr_y
add wave -noupdate -label dx -radix unsigned /fsm_tb/uut/renderer_inst/dx
add wave -noupdate -label dy -radix unsigned /fsm_tb/uut/renderer_inst/dy

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
