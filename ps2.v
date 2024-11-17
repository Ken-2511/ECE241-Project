// module top(CLOCK_50, SW, KEY, HEX3, HEX2, HEX1, HEX0,
// 				VGA_R, VGA_G, VGA_B,
// 				VGA_HS, VGA_VS, VGA_BLANK_N, VGA_SYNC_N, VGA_CLK,
// 				PS2_CLK, PS2_DAT,
// 				HEX4, HEX5, LEDR, VGA_X, VGA_Y, VGA_COLOR, plot);

// 	input CLOCK_50;	
// 	input [7:0] SW;
// 	input [3:0] KEY;
//    output [6:0] HEX3, HEX2, HEX1, HEX0;
// 	output [7:0] VGA_R;
// 	output [7:0] VGA_G;
// 	output [7:0] VGA_B;
// 	output VGA_HS;
// 	output VGA_VS;
// 	output VGA_BLANK_N;
// 	output VGA_SYNC_N;
// 	output VGA_CLK;
// 	inout PS2_CLK;
// 	inout PS2_DAT;
// 	output [6:0] HEX4;
// 	output [6:0] HEX5;
// 	output [9:0] LEDR;
// 	output [8:0] VGA_X;
// 	output [7:0] VGA_Y;
// 	output [2:0] VGA_COLOR;
// 	output plot;

// 	wire [8:0] X;           // starting x location of object
// 	wire [7:0] Y;           // starting y location of object
// 	wire [8:0] VGA_X;       // x location of each object pixel
// 	wire [7:0] VGA_Y;       // y location of each object pixel
// 	wire [2:0] VGA_COLOR;   // color of each object pixel

// 	// store (x,y) starting location
//     regn U1 (SW[6:0], KEY[0], ~KEY[1], CLOCK_50, Y);
//         defparam U1.n = 8;
//     regn U2 (SW[7:0], KEY[0], ~KEY[2], CLOCK_50, X);
//         defparam U2.n = 9;

    

//     assign plot = ~KEY[3];

//     // connect to VGA controller
//     vga_adapter VGA (
// 			.resetn(KEY[0]),
// 			.clock(CLOCK_50),
// 			.colour(VGA_COLOR),
// 			.x(VGA_X),
// 			.y(VGA_Y),
// 			.plot(~KEY[3]),
// 			.VGA_R(VGA_R),
// 			.VGA_G(VGA_G),
// 			.VGA_B(VGA_B),
// 			.VGA_HS(VGA_HS),
// 			.VGA_VS(VGA_VS),
// 			.VGA_BLANK_N(VGA_BLANK_N),
// 			.VGA_SYNC_N(VGA_SYNC_N),
// 			.VGA_CLK(VGA_CLK));
// 		defparam VGA.RESOLUTION = "320x240";
// 		defparam VGA.MONOCHROME = "FALSE";
// 		defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
// 		defparam VGA.BACKGROUND_IMAGE = "black.mif";	
		
// 	//MY STUFF--------------------------------------------------------------
	
// 	wire [7:0] ps2_key_data;
// 	wire ps2_key_pressed;
// 	reg [7:0] last_key_received;
	
// 	wire hs_enable;
// 	half_sec_counter counter(CLOCK_50, KEY[0], hs_enable); //quarter sec counter
	
// 	//for getting keystrokes
// 	always @(CLOCK_50) begin
// 		if(!KEY[0])
// 			last_key_received = 8'b0;
// 		else if(hs_enable)
// 			last_key_received <= ps2_key_data;
// 	end 
	
// 	PS2_Controller PS2 (
// 		// Inputs
// 		.CLOCK_50				(CLOCK_50),
// 		.reset				(~KEY[0]),

// 		// Bidirectionals
// 		.PS2_CLK			(PS2_CLK),
// 		.PS2_DAT			(PS2_DAT),

// 		// Outputs
// 		.received_data		(ps2_key_data),
// 		.received_data_en	(ps2_key_pressed)
// 	);
	
// 	//note: may have to put the current top module in another module later
// 	//player character
// 	wire [8:0] vga_player_x;
// 	wire [7:0] vga_player_y;
// 	reg [8:0] x;
// 	reg [7:0] y;
// 	wire [3:0] w; //internal carry to deal with the movement FSM
// 	wire [2:0] direction;
// 	parameter up = 3'b001, left = 3'b010, down = 3'b011, right = 3'b100;
	
// 	//colours
// 	wire [2:0] yellow = 3'b110;
// 	wire [2:0] red = 3'b100;
// 	wire [2:0] white = 3'b111;
// 	wire [2:0] black = 3'b000;
	
// 	initial begin
// 		x = 9'b0;
// 		y = 8'b0;
// 	end
	
// 	get_direction find_direction(last_key_received, hs_enable, w);
// 	movement_FSM track_movement(CLOCK_50, KEY[0], hs_enable, w, direction);
	
// 	always @(posedge CLOCK_50) begin 
// 		if(!KEY[0]) begin 
// 			x = 0;
// 			y = 0;
// 		end 
// 		else if (hs_enable) begin 
// 			if(direction == up) begin 
// 				x = x;
// 				y = y - 1;
// 			end 
// 			else if (direction == left) begin 
// 				x = x - 1;
// 				y = y;
// 			end 
// 			else if(direction == down) begin 
// 				x = x;
// 				y = y + 1;
// 			end 
// 			else if(direction == right) begin 
// 				x = x + 1;
// 				y = y;
// 			end 
// 			else begin 
// 				x = x;
// 				y = y;
// 			end 
// 		end 
// 		else begin 
// 			x = x;
// 			y = y;
// 		end 
// 	end 
	
// 	assign vga_player_x = x;
// 	assign vga_player_y = y;
	
// 	draw_block player (CLOCK_50, KEY[0], VGA_X, VGA_Y, VGA_COLOR, ~KEY[3], vga_player_x, vga_player_y, yellow);
	
// 	//hex
// 	hex7seg H3 (last_key_received[7:4], HEX3);
//     hex7seg H2 (last_key_received[3:0], HEX2);
//    Hexadecimal_To_Seven_Segment Segment0 (
// 	// Inputs
// 	.hex_number			(last_key_received[3:0]),

// 	// Bidirectional

// 	// Outputs
// 	.seven_seg_display	(HEX0)
// );

// Hexadecimal_To_Seven_Segment Segment1 (
// 	// Inputs
// 	.hex_number			(last_key_received[7:4]),

// 	// Bidirectional

// 	// Outputs
// 	.seven_seg_display	(HEX1)
// );
	
// 	hex7seg H5 (vga_player_x[7:4], HEX5);
//     hex7seg H4 (vga_player_x[3:0], HEX4);
	
// endmodule 

// //get the inputs for FSM from WASD keyboard input
// module get_direction(key, enable, w);
// 	input [7:0] key;
// 	input enable;
// 	output reg [3:0] w;
	
// 	parameter W = 8'b00011101, A = 8'b00011100, S = 8'b00011011, D = 8'b00100011;
	
// 	//note: still = 000, up = 001, left = 010, down = 011, right = 100
	
// 	always @(enable or key) begin 
// 		case(key)
// 			W: w = 3'b001;
// 			A: w = 3'b010;
// 			S: w = 3'b011;
// 			D: w = 3'b100;
// 			default: w = 3'b000;
// 		endcase 
// 	end 
	
// endmodule 

// //handles states of moving
// module movement_FSM(clock, Resetn, enable, w, z); //add wall collision later
// 	input clock, Resetn, enable;
// 	input [2:0] w;
// 	output reg [3:0] z;
	
// 	reg [2:0] state, next_state;
// 	parameter still = 3'b000, up = 3'b001, left = 3'b010, down = 3'b011, right = 3'b100;
	
// 	//state selection
// 	always @(enable or Resetn or w or state) begin
// 		case(state)
// 			still:
// 				if (w == 3'b001) next_state <= up;
// 				else if (w == 3'b010) next_state <= left;
// 				else if (w == 3'b011) next_state <= down;
// 				else if (w == 3'b100) next_state <= right;
// 				else next_state = still;
// 			up:
// 				if (w == 3'b010) next_state <= left;
// 				else if (w == 3'b011) next_state <= down;
// 				else if (w == 3'b100) next_state <= right;
// 				else next_state <= up;
// 			left: 
// 				if (w == 3'b001) next_state = up;
// 				else if (w == 3'b011) next_state = down;
// 				else if (w == 3'b100) next_state = right;
// 				else next_state = left;
// 			down: 
// 				if (w == 3'b001) next_state = up;
// 				else if (w == 3'b010) next_state = left;
// 				else if (w == 3'b100) next_state = right;
// 				else next_state = down;
// 			right: 
// 				if (w == 3'b001) next_state = up;
// 				else if (w == 3'b010) next_state = left;
// 				else if (w == 3'b011) next_state = down;
// 				else next_state = right;
// 			default: next_state = still;
// 		endcase 
// 	end 
	
// 	//move to next state
// 	always @(posedge clock) begin 
// 		if(!Resetn)
// 			state <= still;
// 		else
// 			state <= next_state;
// 	end 
	
// 	//outputs
// 	always @(posedge clock) begin
// 		case (state)
// 			still: z = 3'b000;
// 			up: z = 3'b001;
// 			left: z = 3'b010;
// 			down: z = 3'b011;
// 			right: z = 3'b100;
// 			default: z = 3'b000;
// 		endcase 
// 	end 

// endmodule 

// //for half-second enable - we might have to change it to quarter second
// module half_sec_counter(clock, resetn, enable);
// 	input clock, resetn;
// 	output reg enable;
// 	reg [24:0] count;
	
// 	initial begin 
// 		count <= 25'b0;
// 		enable <= 1'b0;
// 	end 
	
// 	always @(posedge clock) begin
// 		if(!resetn) begin
// 			count <= 25'b0;
// 			enable <= 1'b0;
// 		end
// 		else if(count == 25000000) begin
// 			enable <= 1'b1;
// 			count <= 25'b0;
// 		end
// 		else begin
// 			enable <= 1'b0;
// 			count <= count + 1;
// 		end
// 	end
	
// endmodule 

// module draw_block(clock, resetn, vga_x, vga_y, color, enable, bias_x, bias_y, colour_to_draw);
// 	// draw a maze with blocks of 8x8 pixels

// 	input clock, resetn, enable;
// 	input [2:0] colour_to_draw;
// 	output [2:0] color;
// 	output reg [8:0] vga_x;
// 	output reg [7:0] vga_y;
//     input [8:0] bias_x;
//     input [7:0] bias_y;

// 	reg [3:0] dx, dy;

// 	parameter n = 8;

// 	always @ (posedge clock) begin
// 		if (!resetn) begin
// 			dx <= 0;
// 			dy <= 0;
// 			vga_x <= 0;
// 			vga_y <= 0;
// 		end
// 		else if (enable) begin
// 			// update the position
// 			if (dx == n - 1) begin
// 				dx <= 0;
// 				if (dy == n - 1) begin
// 					dy <= 0;
// 				end
// 				else
// 					dy <= dy + 1;
// 			end
// 			else
// 				dx <= dx + 1;
// 			// update the VGA position
// 			vga_x <= bias_x + dx;
// 			vga_y <= bias_y + dy;
// 		end
// 	end

// 	assign color = colour_to_draw;

// endmodule