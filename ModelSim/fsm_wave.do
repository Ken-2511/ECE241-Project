onerror {resume}
quietly WaveActivateNextPane {} 0

# Clock and Reset signals
add wave -noupdate -label clock -radix binary /fsm_testbench/clock
add wave -noupdate -label resetn -radix binary /fsm_testbench/resetn
add wave -noupdate -label enable -radix binary /fsm_testbench/enable
add wave -noupdate -label key3 -radix binary /fsm_testbench/key3
add wave -noupdate -label last_key_received -radix hexadecimal /fsm_testbench/last_key_received

# Game State Control Signals
# add wave -noupdate -divider game_state_control
# add wave -noupdate -label game_state -radix binary /fsm_testbench/UUT/game_state
# add wave -noupdate -label next_game_state -radix binary /fsm_testbench/UUT/next_game_state
# add wave -noupdate -label e_greeting -radix binary /fsm_testbench/UUT/e_greeting
# add wave -noupdate -label f_greeting -radix binary /fsm_testbench/UUT/f_greeting
# add wave -noupdate -label e_playing -radix binary /fsm_testbench/UUT/e_playing
# add wave -noupdate -label f_playing -radix binary /fsm_testbench/UUT/f_playing
# add wave -noupdate -label e_game_over -radix binary /fsm_testbench/UUT/e_game_over
# add wave -noupdate -label f_game_over -radix binary /fsm_testbench/UUT/f_game_over

# Greeting Module Signals
# add wave -noupdate -divider m_greeting
# add wave -noupdate -label enable_greeting -radix binary /fsm_testbench/UUT/m_greeting_inst/enable
# add wave -noupdate -label finished_greeting -radix binary /fsm_testbench/UUT/m_greeting_inst/finished

# Playing Module Signals
add wave -noupdate -divider m_playing
add wave -noupdate -label enable_playing -radix binary /fsm_testbench/UUT/m_playing_inst/enable
add wave -noupdate -label game_state_playing -radix binary /fsm_testbench/UUT/m_playing_inst/game_state
add wave -noupdate -label next_game_state_playing -radix binary /fsm_testbench/UUT/m_playing_inst/next_game_state
add wave -noupdate -label e_clear_screen -radix binary /fsm_testbench/UUT/m_playing_inst/e_clear_screen
add wave -noupdate -label e_update_position -radix binary /fsm_testbench/UUT/m_playing_inst/e_update_position
add wave -noupdate -label e_eat_food -radix binary /fsm_testbench/UUT/m_playing_inst/e_eat_food
add wave -noupdate -label e_update_ghost_directions -radix binary /fsm_testbench/UUT/m_playing_inst/e_update_ghost_directions
add wave -noupdate -label e_update_ghost_positions -radix binary /fsm_testbench/UUT/m_playing_inst/e_update_ghost_positions
add wave -noupdate -label e_fill_screen -radix binary /fsm_testbench/UUT/m_playing_inst/e_fill_screen
add wave -noupdate -label e_render_blocks -radix binary /fsm_testbench/UUT/m_playing_inst/e_render_blocks
add wave -noupdate -label e_render_player -radix binary /fsm_testbench/UUT/m_playing_inst/e_render_player
add wave -noupdate -label e_render_food -radix binary /fsm_testbench/UUT/m_playing_inst/e_render_food
add wave -noupdate -label e_render_ghosts -radix binary /fsm_testbench/UUT/m_playing_inst/e_render_ghosts
add wave -noupdate -label e_ghost_collision -radix binary /fsm_testbench/UUT/m_playing_inst/e_ghost_collision
add wave -noupdate -label e_update_vga -radix binary /fsm_testbench/UUT/m_playing_inst/e_update_vga
add wave -noupdate -label finished_playing -radix binary /fsm_testbench/UUT/m_playing_inst/finished

# Submodules within Playing Module Signals
add wave -noupdate -divider submodules_playing
add wave -noupdate -label f_clear_screen -radix binary /fsm_testbench/UUT/m_playing_inst/f_clear_screen
add wave -noupdate -label f_update_position -radix binary /fsm_testbench/UUT/m_playing_inst/f_update_position
add wave -noupdate -label f_eat_food -radix binary /fsm_testbench/UUT/m_playing_inst/f_eat_food
add wave -noupdate -label f_update_ghost_directions -radix binary /fsm_testbench/UUT/m_playing_inst/f_update_ghost_directions
add wave -noupdate -label f_update_ghost_positions -radix binary /fsm_testbench/UUT/m_playing_inst/f_update_ghost_positions
add wave -noupdate -label f_fill_screen -radix binary /fsm_testbench/UUT/m_playing_inst/f_fill_screen
add wave -noupdate -label f_render_blocks -radix binary /fsm_testbench/UUT/m_playing_inst/f_render_blocks
add wave -noupdate -label f_render_player -radix binary /fsm_testbench/UUT/m_playing_inst/f_render_player
add wave -noupdate -label f_render_food -radix binary /fsm_testbench/UUT/m_playing_inst/f_render_food
add wave -noupdate -label f_render_ghosts -radix binary /fsm_testbench/UUT/m_playing_inst/f_render_ghosts
add wave -noupdate -label f_ghost_collision -radix binary /fsm_testbench/UUT/m_playing_inst/f_ghost_collision
add wave -noupdate -label f_update_vga -radix binary /fsm_testbench/UUT/m_playing_inst/f_update_vga

# Game Over Module Signals
# add wave -noupdate -divider m_game_over
# add wave -noupdate -label enable_game_over -radix binary /fsm_testbench/UUT/m_game_over_inst/enable
# add wave -noupdate -label finished_game_over -radix binary /fsm_testbench/UUT/m_game_over_inst/finished

# Render Food Module Signals
add wave -noupdate -divider m_render_food
add wave -noupdate -label finished -radix binary /fsm_testbench/UUT/m_playing_inst/m_render_food_inst/finished
add wave -noupdate -label temp_food_addr -radix hexadecimal /fsm_testbench/UUT/m_playing_inst/m_render_food_inst/temp_food_addr
add wave -noupdate -label food_exists -radix binary /fsm_testbench/UUT/m_playing_inst/m_render_food_inst/food_exists

# VGA and Canvas Signals
add wave -noupdate -divider VGA_and_canvas
add wave -noupdate -label data -radix octal /fsm_testbench/UUT/data
add wave -noupdate -label addr -radix hexadecimal /fsm_testbench/UUT/addr
add wave -noupdate -label q -radix octal /fsm_testbench/UUT/q
add wave -noupdate -label wren -radix binary /fsm_testbench/UUT/wren
add wave -noupdate -label VGA_X -radix unsigned /fsm_testbench/UUT/VGA_X
add wave -noupdate -label VGA_Y -radix unsigned /fsm_testbench/UUT/VGA_Y
add wave -noupdate -label VGA_COLOR -radix octal /fsm_testbench/UUT/VGA_COLOR

# canvas signals
add wave -noupdate -divider canvas
add wave -noupdate -label data -radix octal /fsm_testbench/canvas_inst/data
add wave -noupdate -label address -radix hexadecimal /fsm_testbench/canvas_inst/address
add wave -noupdate -label q -radix octal /fsm_testbench/canvas_inst/q
add wave -noupdate -label wren -radix binary /fsm_testbench/canvas_inst/wren

# Player render signals
add wave -noupdate -divider player
add wave -noupdate -label canvas_x -radix unsigned /fsm_testbench/UUT/m_playing_inst/m_render_player_inst/canvas_x
add wave -noupdate -label canvas_y -radix unsigned /fsm_testbench/UUT/m_playing_inst/m_render_player_inst/canvas_y
add wave -noupdate -label dx -radix signed /fsm_testbench/UUT/m_playing_inst/m_render_player_inst/dx
add wave -noupdate -label dy -radix signed /fsm_testbench/UUT/m_playing_inst/m_render_player_inst/dy
add wave -noupdate -label temp_player_addr -radix hexadecimal /fsm_testbench/UUT/m_playing_inst/m_render_player_inst/temp_player_addr
add wave -noupdate -label addr -radix hexadecimal /fsm_testbench/UUT/m_playing_inst/m_render_player_inst/addr
add wave -noupdate -label wren -radix binary /fsm_testbench/UUT/m_playing_inst/m_render_player_inst/wren
add wave -noupdate -label data -radix octal /fsm_testbench/UUT/m_playing_inst/m_render_player_inst/data
add wave -noupdate -label color -radix octal /fsm_testbench/UUT/m_playing_inst/m_render_player_inst/color

# food signals
# add wave -noupdate -divider Food
# add wave -noupdate -label address -radix unsigned /fsm_testbench/UUT/m_playing_inst/m_render_food_inst/U2/address
# add wave -noupdate -label data -radix octal /fsm_testbench/UUT/m_playing_inst/m_render_food_inst/U2/data
# add wave -noupdate -label wren -radix binary /fsm_testbench/UUT/m_playing_inst/m_render_food_inst/U2/wren
# add wave -noupdate -label q -radix binary /fsm_testbench/UUT/m_playing_inst/m_render_food_inst/U2/q
# add wave -noupdate -label game_x -radix unsigned /fsm_testbench/UUT/m_playing_inst/m_render_food_inst/game_x
# add wave -noupdate -label game_y -radix unsigned /fsm_testbench/UUT/m_playing_inst/m_render_food_inst/game_y
# add wave -noupdate -label finished -radix binary /fsm_testbench/UUT/m_playing_inst/m_render_food_inst/finished

# update_vga_signals
add wave -noupdate -divider update_vga_signals
add wave -noupdate -label enable -radix binary fsm_testbench/UUT/m_playing_inst/m_update_vga_inst/enable
add wave -noupdate -label finished -radix binary fsm_testbench/UUT/m_playing_inst/m_update_vga_inst/finished
add wave -noupdate -label VGA_COLOR -radix octal fsm_testbench/UUT/m_playing_inst/m_update_vga_inst/VGA_COLOR
add wave -noupdate -label VGA_X -radix unsigned fsm_testbench/UUT/m_playing_inst/m_update_vga_inst/VGA_X
add wave -noupdate -label VGA_Y -radix unsigned fsm_testbench/UUT/m_playing_inst/m_update_vga_inst/VGA_Y

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
