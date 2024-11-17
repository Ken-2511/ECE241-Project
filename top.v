    // top DUT (.CLOCK_50(CLOCK_50), .SW(SW), .KEY(KEY), .HEX0(HEX0), .HEX1(HEX1), 
    //          .HEX2(HEX2), .HEX3(HEX3), .HEX4(HEX4), .HEX5(HEX5), .LEDR(LEDR), 
    //          .VGA_X(VGA_X), .VGA_Y(VGA_Y), .VGA_COLOR(VGA_COLOR), .plot(plot));

module top(CLOCK_50, SW, KEY, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0, LEDR, VGA_X, VGA_Y, VGA_COLOR, plot);
	
	input CLOCK_50;
	input [9:0] SW;
	input [3:0] KEY;
    output [6:0] HEX5, HEX4, HEX3, HEX2, HEX1, HEX0;
	output [8:0] VGA_X;
	output [7:0] VGA_Y;
	output [2:0] VGA_COLOR;
	output plot;
	output [9:0] LEDR;

	// for data memory
	wire [2:0] data;
	wire [16:0] addr;
	wire wren;
	wire [2:0] q;

	wire [8:0] X;           // starting x location of object
	wire [7:0] Y;           // starting y location of object

	// store (x,y) starting location
    regn U1 (SW[7:0], KEY[0], ~KEY[1], CLOCK_50, Y);
        defparam U1.n = 8;
    regn U2 (SW[8:0], KEY[0], ~KEY[2], CLOCK_50, X);
        defparam U2.n = 9;

    hex7seg H3 (X[7:4], HEX3);
    hex7seg H2 (X[3:0], HEX2);
    hex7seg H1 ({1'b0, Y[6:4]}, HEX1);
    hex7seg H0 (Y[3:0], HEX0);

    assign plot = ~KEY[3];

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
		.VGA_COLOR(VGA_COLOR)
	);

	canvas canvas_inst(
        .address(addr),
        .clock(CLOCK_50),
        .data(data),
        .wren(wren),
        .q(q)
    );

endmodule