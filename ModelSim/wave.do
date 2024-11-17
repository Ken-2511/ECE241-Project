onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -label CLOCK_50 -radix binary /testbench/CLOCK_50
add wave -noupdate -label KEY -radix binary /testbench/KEY
add wave -noupdate -label SW -radix binary /testbench/SW
add wave -noupdate -label VGA_R -radix hexadecimal /testbench/VGA_R
add wave -noupdate -label VGA_G -radix hexadecimal /testbench/VGA_G
add wave -noupdate -label VGA_B -radix hexadecimal /testbench/VGA_B
add wave -noupdate -label VGA_HS -radix binary /testbench/VGA_HS
add wave -noupdate -label VGA_VS -radix binary /testbench/VGA_VS
add wave -noupdate -label VGA_BLANK_N -radix binary /testbench/VGA_BLANK_N
add wave -noupdate -label VGA_SYNC_N -radix binary /testbench/VGA_SYNC_N
add wave -noupdate -label VGA_CLK -radix binary /testbench/VGA_CLK

add wave -noupdate -divider milestone2
add wave -noupdate -label data -radix hexadecimal /testbench/U1/data
add wave -noupdate -label addr -radix hexadecimal /testbench/U1/addr
add wave -noupdate -label wren -radix binary /testbench/U1/wren
add wave -noupdate -label q -radix hexadecimal /testbench/U1/q
add wave -noupdate -label VGA_X -radix hexadecimal /testbench/U1/VGA_X
add wave -noupdate -label VGA_Y -radix hexadecimal /testbench/U1/VGA_Y
add wave -noupdate -label VGA_COLOR -radix hexadecimal /testbench/U1/VGA_COLOR

add wave -noupdate -divider fsm1
add wave -noupdate -label VGA_COLOR -radix hexadecimal /testbench/U1/U3/VGA_COLOR
add wave -noupdate -label q -radix hexadecimal /testbench/U1/U3/q

add wave -noupdate -divider vga_adapter
add wave -noupdate -label VGA_COLOR -radix hexadecimal /testbench/U1/VGA/colour
add wave -noupdate -label VGA_X -radix hexadecimal /testbench/U1/VGA/x
add wave -noupdate -label VGA_Y -radix hexadecimal /testbench/U1/VGA/y

add wave -noupdate -divider fsm2
add wave -noupdate -label VGA_COLOR -radix hexadecimal /testbench/U1/U3/m_playing_inst/VGA_COLOR
add wave -noupdate -label q -radix hexadecimal /testbench/U1/U3/m_playing_inst/q
add wave -noupdate -label VGA_X -radix hexadecimal /testbench/U1/U3/m_playing_inst/VGA_X
add wave -noupdate -label VGA_Y -radix hexadecimal /testbench/U1/U3/m_playing_inst/VGA_Y

add wave -noupdate -divider update_vga_signals
add wave -noupdate -label VGA_COLOR -radix hexadecimal /testbench/U1/U3/m_playing_inst/m_update_vga_inst/VGA_COLOR
add wave -noupdate -label q -radix hexadecimal /testbench/U1/U3/m_playing_inst/m_update_vga_inst/q
add wave -noupdate -label wren -radix binary /testbench/U1/U3/m_playing_inst/m_update_vga_inst/wren
add wave -noupdate -label VGA_X -radix hexadecimal /testbench/U1/U3/m_playing_inst/m_update_vga_inst/VGA_X
add wave -noupdate -label VGA_Y -radix hexadecimal /testbench/U1/U3/m_playing_inst/m_update_vga_inst/VGA_Y

add wave -noupdate -divider canvas
add wave -noupdate -label data -radix hexadecimal /testbench/U1/canvas_inst/data
add wave -noupdate -label addr -radix hexadecimal /testbench/U1/canvas_inst/address
add wave -noupdate -label wren -radix binary /testbench/U1/canvas_inst/wren
add wave -noupdate -label q -radix hexadecimal /testbench/U1/canvas_inst/q

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
WaveRestoreZoom {0 ps} {3000 ns}
