/*
*   Displays a pattern, which is read from a small memory, at (x,y) on the VGA output.
*   To set coordinates, first place the desired value of y onto SW[6:0] and press KEY[1].
*   Next, place the desired value of x onto SW[7:0] and then press KEY[2]. The (x,y)
*   coordinates are displayed (in hexadecimal) on (HEX3-2,HEX1-0). Finally, press KEY[3]
*   to draw the pattern at location (x,y).
*/
module milestone2(CLOCK_50, SW, KEY, HEX3, HEX2, HEX1, HEX0,
				VGA_R, VGA_G, VGA_B,
				VGA_HS, VGA_VS, VGA_BLANK_N, VGA_SYNC_N, VGA_CLK,
				PS2_CLK, PS2_DAT,
				HEX4, HEX5, LEDR, VGA_X, VGA_Y, VGA_COLOR, plot);
	
	input CLOCK_50;	
	input [7:0] SW;
	input [3:0] KEY;
    output [6:0] HEX3, HEX2, HEX1, HEX0;
	output [7:0] VGA_R;
	output [7:0] VGA_G;
	output [7:0] VGA_B;
	output VGA_HS;
	output VGA_VS;
	output VGA_BLANK_N;
	output VGA_SYNC_N;
	output VGA_CLK;
	inout PS2_CLK;
	inout PS2_DAT;
	output [6:0] HEX4;
	output [6:0] HEX5;
	output [9:0] LEDR;
	output [8:0] VGA_X;
	output [7:0] VGA_Y;
	output [2:0] VGA_COLOR;
	output plot;

	wire [8:0] X;           // starting x location of object
	wire [7:0] Y;           // starting y location of object
	wire [8:0] VGA_X;       // x location of each object pixel
	wire [7:0] VGA_Y;       // y location of each object pixel
	wire [2:0] VGA_COLOR;   // color of each object pixel

	// store (x,y) starting location
    regn U1 (SW[6:0], KEY[0], ~KEY[1], CLOCK_50, Y);
        defparam U1.n = 8;
    regn U2 (SW[7:0], KEY[0], ~KEY[2], CLOCK_50, X);
        defparam U2.n = 9;

	draw_block U3 (CLOCK_50, KEY[0], VGA_X, VGA_Y, VGA_COLOR, ~KEY[3], X, Y);

    hex7seg H3 (X[7:4], HEX3);
    hex7seg H2 (X[3:0], HEX2);
    hex7seg H1 ({1'b0, Y[6:4]}, HEX1);
    hex7seg H0 (Y[3:0], HEX0);

    assign plot = ~KEY[3];

    // connect to VGA controller
    vga_adapter VGA (
			.resetn(KEY[0]),
			.clock(CLOCK_50),
			.colour(VGA_COLOR),
			.x(VGA_X),
			.y(VGA_Y),
			.plot(~KEY[3]),
			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HS(VGA_HS),
			.VGA_VS(VGA_VS),
			.VGA_BLANK_N(VGA_BLANK_N),
			.VGA_SYNC_N(VGA_SYNC_N),
			.VGA_CLK(VGA_CLK));
		defparam VGA.RESOLUTION = "320x240";
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
		defparam VGA.BACKGROUND_IMAGE = "black.mif";

endmodule


// module vga_demo(CLOCK_50, SW, KEY, HEX3, HEX2, HEX1, HEX0, VGA_X, VGA_Y, VGA_COLOR, plot);

module milestone2_desim(CLOCK_50, SW, KEY, HEX3, HEX2, HEX1, HEX0, VGA_X, VGA_Y, VGA_COLOR, plot);
	
	input CLOCK_50;	
	input [7:0] SW;
	input [3:0] KEY;
    output [6:0] HEX3, HEX2, HEX1, HEX0;
	output [8:0] VGA_X;
	output [7:0] VGA_Y;
	output [2:0] VGA_COLOR;
	output plot;

	wire [8:0] X;           // starting x location of object
	wire [7:0] Y;           // starting y location of object

	// store (x,y) starting location
    regn U1 (SW[6:0], KEY[0], ~KEY[1], CLOCK_50, Y);
        defparam U1.n = 8;
    regn U2 (SW[7:0], KEY[0], ~KEY[2], CLOCK_50, X);
        defparam U2.n = 9;

	draw_block U3 (CLOCK_50, KEY[0], VGA_X, VGA_Y, VGA_COLOR, ~KEY[3], X, Y);

    hex7seg H3 (X[7:4], HEX3);
    hex7seg H2 (X[3:0], HEX2);
    hex7seg H1 ({1'b0, Y[6:4]}, HEX1);
    hex7seg H0 (Y[3:0], HEX0);

    assign plot = ~KEY[3];

endmodule


module draw_block(clock, resetn, vga_x, vga_y, color, enable, bias_x, bias_y);
	// draw a maze with blocks of 8x8 pixels

	input clock, resetn, enable;
	output [7:0] color;
	output reg [8:0] vga_x;
	output reg [7:0] vga_y;
    input [8:0] bias_x;
    input [7:0] bias_y;

	reg [3:0] dx, dy;

	parameter n = 8;

	always @ (posedge clock) begin
		if (!resetn) begin
			dx <= 0;
			dy <= 0;
			vga_x <= 0;
			vga_y <= 0;
		end
		else if (enable) begin
			// update the position
			if (dx == n - 1) begin
				dx <= 0;
				if (dy == n - 1) begin
					dy <= 0;
				end
				else
					dy <= dy + 1;
			end
			else
				dx <= dx + 1;
			// update the VGA position
			vga_x <= bias_x + dx;
			vga_y <= bias_y + dy;
		end
	end

	assign color = 8'hff;

endmodule
