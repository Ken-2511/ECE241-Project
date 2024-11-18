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
				HEX4, HEX5, LEDR, VGA_X_D, VGA_Y_D, VGA_COLOR, plot);
	
    parameter cbit = 11;

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
	output wire [7:0] VGA_X_D; // delayed signal
	output wire [6:0] VGA_Y_D;
	wire [7:0] VGA_X;
	wire [6:0] VGA_Y;
	output wire [cbit:0] VGA_COLOR;
	output plot;

	// for data memory
	wire [cbit:0] data;
	wire [14:0] addr;
	wire wren;
	wire [cbit:0] q;

	wire [7:0] X;           // starting x location of object
	wire [6:0] Y;           // starting y location of object

	// For PS2 controller
	wire [7:0] ps2_key_data;
	wire ps2_key_pressed;
	reg [7:0] last_key_received;

	// For PS2 controller
	PS2_Controller PS2 (
		// Inputs
		.CLOCK_50				(CLOCK_50),
		.reset				(~KEY[0]),

		// Bidirectionals
		.PS2_CLK			(PS2_CLK),
		.PS2_DAT			(PS2_DAT),

		// Outputs
		.received_data		(ps2_key_data),
		.received_data_en	(ps2_key_pressed)
	);

	always @(CLOCK_50) begin
		if(!KEY[0])
			last_key_received = 8'b0;
		else if (ps2_key_pressed)
			last_key_received <= ps2_key_data;
	end

	// // store (x,y) starting location
    // regn U1 (SW[6:0], KEY[0], ~KEY[1], CLOCK_50, Y);
    //     defparam U1.n = 8;
    // regn U2 (SW[7:0], KEY[0], ~KEY[2], CLOCK_50, X);
    //     defparam U2.n = 9;
	hex7seg H3 (last_key_received[7:4], HEX3);
    hex7seg H2 (last_key_received[3:0], HEX2);


	fsm_game_state U3 (
		.clock(CLOCK_50),
		.resetn(KEY[0]),
		.enable(~KEY[3]),
		.data(data),
		.addr(addr),
		.wren(wren),
		.q(q),
		.VGA_X(VGA_X),
		.VGA_Y(VGA_Y),
		.VGA_COLOR(VGA_COLOR),
		.last_key_received(last_key_received)
	);

    // hex7seg H3 (X[7:4], HEX3);
    // hex7seg H2 (X[3:0], HEX2);
    // hex7seg H1 ({1'b0, Y[6:4]}, HEX1);
    // hex7seg H0 (Y[3:0], HEX0);

    assign plot = ~KEY[3];

	canvas canvas_inst(
        .address(addr),
        .clock(CLOCK_50),
        .data(data),
        .wren(wren),
        .q(q)
    );

	delay_one_cycle U4 (CLOCK_50, KEY[0], VGA_X, VGA_X_D);
	defparam U4.n = 8;
	defparam U4.n_cycles = 1;
	delay_one_cycle U5 (CLOCK_50, KEY[0], VGA_Y, VGA_Y_D);
	defparam U5.n = 7;
	defparam U5.n_cycles = 1;

    // connect to VGA controller
    vga_adapter VGA (
			.resetn(KEY[0]),
			.clock(CLOCK_50),
			.colour(VGA_COLOR),
			.x(VGA_X_D),
			.y(VGA_Y_D),
			.plot(~KEY[3]),
			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HS(VGA_HS),
			.VGA_VS(VGA_VS),
			.VGA_BLANK_N(VGA_BLANK_N),
			.VGA_SYNC_N(VGA_SYNC_N),
			.VGA_CLK(VGA_CLK));
		defparam VGA.RESOLUTION = "160x120";
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 4;
		defparam VGA.BACKGROUND_IMAGE = "black.mif";

endmodule


module draw_big_maze(clock, resetn, vga_x, vga_y, color, enable);
	// draw a maze with blocks of 8x8 pixels

	input clock, resetn, enable;
	output [7:0] color;
	output reg [7:0] vga_x;
	output reg [6:0] vga_y;

	reg [4:0] maze_x;
	reg [3:0] maze_y;
	wire [0:0] maze_color;
	reg [3:0] dx, dy;

	parameter n = 4; // size of the block

	always @ (posedge clock) begin
		if (!resetn) begin
			dx <= 0;
			dy <= 0;
            maze_x <= 0;
            maze_y <= 0;
			vga_x <= 0;
			vga_y <= 0;
		end
		else if (enable) begin
			// update the position
			if (dx == n - 1) begin
				dx <= 0;
				if (dy == n - 1) begin
					dy <= 0;
                    if (maze_x == 29 - 1) begin
                        maze_x <= 0;
                        if (maze_y == 13 - 1) begin
                            maze_y <= 0;
                        end
                        else
                            maze_y <= maze_y + 1;
                    end
                    else
                        maze_x <= maze_x + 1;
				end
				else
					dy <= dy + 1;
			end
			else
				dx <= dx + 1;
			// update the VGA position
			vga_x <= maze_x * n + dx;
			vga_y <= maze_y * n + dy;
		end
	end

	assign color = maze_color == 1'b1 ? 8'hff : 8'h00;

    blocks U1 (
	.address({maze_y * 29 + maze_x}),
	.clock(clock),
	.data(8'h00),
	.wren(1'b0),
	.q(maze_color)
    );

endmodule
