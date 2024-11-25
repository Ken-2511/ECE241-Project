# Filename: renderer_wave.do

onerror {resume}
quietly WaveActivateNextPane {} 0

# Clock and Reset signals
add wave -noupdate -label clock -radix binary /renderer_tb/clock
add wave -noupdate -label resetn -radix binary /renderer_tb/resetn
add wave -noupdate -label enable -radix binary /renderer_tb/enable

# Renderer Module Signals
add wave -noupdate -divider renderer_signals
add wave -noupdate -label finished -radix binary /renderer_tb/uut/finished
add wave -noupdate -label VGA_X -radix unsigned /renderer_tb/uut/VGA_X
add wave -noupdate -label VGA_Y -radix unsigned /renderer_tb/uut/VGA_Y
add wave -noupdate -label VGA_COLOR -radix hexadecimal /renderer_tb/uut/VGA_COLOR

# Player Signals
add wave -noupdate -divider player_signals
add wave -noupdate -label pl_game_x -radix unsigned /renderer_tb/uut/pl_game_x
add wave -noupdate -label pl_game_y -radix unsigned /renderer_tb/uut/pl_game_y

# Ghost Signals
add wave -noupdate -divider ghost_signals
add wave -noupdate -label g1_game_x -radix unsigned /renderer_tb/g1_game_x
add wave -noupdate -label g1_game_y -radix unsigned /renderer_tb/g1_game_y
add wave -noupdate -label g1_color -radix hexadecimal /renderer_tb/g1_color
add wave -noupdate -label g2_game_x -radix unsigned /renderer_tb/g2_game_x
add wave -noupdate -label g2_game_y -radix unsigned /renderer_tb/g2_game_y
add wave -noupdate -label g2_color -radix hexadecimal /renderer_tb/g2_color
add wave -noupdate -label g3_game_x -radix unsigned /renderer_tb/g3_game_x
add wave -noupdate -label g3_game_y -radix unsigned /renderer_tb/g3_game_y
add wave -noupdate -label g3_color -radix hexadecimal /renderer_tb/g3_color

# Delayed Ghost Signals
add wave -noupdate -divider delayed_ghost_signals
add wave -noupdate -label g1_game_x_ -radix unsigned /renderer_tb/uut/g1_game_x_
add wave -noupdate -label g1_game_y_ -radix unsigned /renderer_tb/uut/g1_game_y_
add wave -noupdate -label g2_game_x_ -radix unsigned /renderer_tb/uut/g2_game_x_
add wave -noupdate -label g2_game_y_ -radix unsigned /renderer_tb/uut/g2_game_y_
add wave -noupdate -label g3_game_x_ -radix unsigned /renderer_tb/uut/g3_game_x_
add wave -noupdate -label g3_game_y_ -radix unsigned /renderer_tb/uut/g3_game_y_

# Background Signals
add wave -noupdate -divider background_signals
add wave -noupdate -label bg_color -radix hexadecimal /renderer_tb/bg_color
add wave -noupdate -label bg_x -radix unsigned /renderer_tb/bg_x
add wave -noupdate -label bg_y -radix unsigned /renderer_tb/bg_y

# Internal Rendering Signals
add wave -noupdate -divider internal_signals
add wave -noupdate -label state -radix unsigned /renderer_tb/uut/state
add wave -noupdate -label dx -radix unsigned /renderer_tb/uut/dx
add wave -noupdate -label dy -radix unsigned /renderer_tb/uut/dy
add wave -noupdate -label render_index -radix unsigned /renderer_tb/uut/render_index

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
