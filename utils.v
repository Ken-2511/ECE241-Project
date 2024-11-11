


// module top(CLOCK_50, KEY, VGA_R, VGA_G, VGA_B, 
// 				VGA_HS, VGA_VS, VGA_BLANK_N, VGA_SYNC_N, VGA_CLK,
// 				PS2_CLK, PS2_DAT);

// 	input CLOCK_50;
// 	input [3:0] KEY;
// 	output [7:0] VGA_R;
// 	output [7:0] VGA_B;
// 	output [7:0] VGA_G;
// 	output VGA_HS, VGA_VS, VGA_BLANK_N, VGA_SYNC_N, VGA_CLK;
	
// 	inout PS2_CLK;
// 	inout PS2_DAT;
	
// 	//note: the VGA stuff is just for reference here, I'm focusing on PS2 rn
	
// 	wire [7:0] ps2_key_data;
// 	wire ps2_key_pressed;
// 	reg [7:0] last_key_received;
	
// 	wire hs_enable;
// 	half_sec_counter(CLOCK_50, KEY[0], hs_enable);
	
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
					
// 	//game state
// 	parameter start = 2'b00, gaming = 2'b01, won = 2'b10, lost = 2'b11;
// 	wire [1:0] game_state;
	
// 	//player character
// 	integer x, y, new_x, new_y;
// 	wire [2:0] direction, next_direction;
// 	get_direction(last_key_received, hs_enable, direction, next_direction);
// 	assign direction = new_direction;
	
// 	//note: up = 2'00, left = 2'01, down = 2'b10, right = 2'b11;
	

// endmodule 

// //get the direciton from WASD keyboard input
// module get_direction(key, enable, oldDir, newdir);
// 	input [7:0] key;
// 	input enable;
// 	input [2:0] oldDir;
// 	output [2:0] newDir;
	
// 	parameter W = 8'b00011101, A = 8'b00011100, S = 8'b00011010, D = 8'b00100011;
	
// 	//note: up = 00, left = 01, down = 10, right = 11
	
// 	always @(enable) begin 
// 		case(key)
// 			W: newDir = 2'b00;
// 			A: newDir = 2'b01;
// 			S: newDir = 2'b10;
// 			D: newDir = 2'b11;
// 			default: newdir = oldDir;
// 		endcase 
// 	end 
	
// endmodule 

// module move_player(direction, x, y, enable, new_x, new_y); //add wall collision later
// 	input integer x, y;
// 	input enable;
// 	input [2:0] direction;
// 	output integer new_x, new_y;
	
// 	parameter up = 2'b00, left = 2'b01, down = 2'b10, right = 2'b11;
	
// 	always @(enable) begin 
// 		case(direction)
// 			up: begin
// 				new_x = x;
// 				new_y = y - 1;
// 			end 
// 			left: begin
// 				new_x = x - 1;
// 				new_y = y;
// 			end
// 			down: begin 
// 				new_x = x;
// 				new_y = y + 1;
// 			end 
// 			right: begin
// 				new_x = x + 1;
// 				new_y = y;
// 			end 
// 		endcase
	

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



