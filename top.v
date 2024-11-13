// module top (CLOCK_50, SW, KEY, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, LEDR, VGA_X, VGA_Y, VGA_COLOR, plot);

//     input CLOCK_50;             // DE-series 50 MHz clock signal
//     input wire [9:0] SW;        // DE-series switches
//     input wire [3:0] KEY;       // DE-series pushbuttons

//     output wire [6:0] HEX0;     // DE-series HEX displays
//     output wire [6:0] HEX1;
//     output wire [6:0] HEX2;
//     output wire [6:0] HEX3;
//     output wire [6:0] HEX4;
//     output wire [6:0] HEX5;

//     output wire [9:0] LEDR;     // DE-series LEDs   
//     output wire [7:0] VGA_X;
//     output wire [6:0] VGA_Y;
//     output wire [2:0] VGA_COLOR;
//     output wire plot;
    
//     wire VGA_BLANK_N;
//     wire VGA_SYNC_N;
//     wire VGA_CLK;

//     milestone1 U1 (CLOCK_50, SW, KEY, HEX3, HEX2, HEX1, HEX0, VGA_R, VGA_G, VGA_B, VGA_X, VGA_Y, VGA_BLANK_N, VGA_SYNC_N, VGA_CLK);

// endmodule

// module milestone1(CLOCK_50, SW, KEY, HEX3, HEX2, HEX1, HEX0,
// 				VGA_R, VGA_G, VGA_B,
// 				VGA_HS, VGA_VS, VGA_BLANK_N, VGA_SYNC_N, VGA_CLK);
	