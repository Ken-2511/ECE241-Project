// module ps2(CLOCK_50, KEY, VGA_R, VGA_G, VGA_B, 
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
// 	half_sec_counter U4 (CLOCK_50, KEY[0], hs_enable);
	
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
// 	reg [1:0] game_state;
	
// 	//player character
// 	reg [8:0] x, y;
// 	wire [2:0] z;
	
// 	get_direction U1 (last_key_received, hs_enable, w);
// 	movement_FSM U2(CLOCK_50, KEY[0], hs_enable, w, z_reg);
// 	player_movement U3(hs_enable, z, x, y);
	
// endmodule 

// //get the inputs for FSM from WASD keyboard input
// module get_direction(key, enable, w);

// 	input [7:0] key;
// 	input enable;
// 	output reg [3:0] w;
	
// 	parameter W = 8'b00011101, A = 8'b00011100, S = 8'b00011010, D = 8'b00100011;
	
// 	//note: still = 000, up = 001, left = 010, down = 011, right = 100
	
// 	always @(enable) begin 
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
// 	always @(enable or Resetn) begin
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
// 			up: 
// 				if (w == 3'b010) next_state = left;
// 				else if (w == 3'b011) next_state = down;
// 				else if (w == 3'b100) next_state = right;
// 				else next_state = up;
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

// //moves the player
// module player_movement(enable, z, x, y);

// 	input enable;
// 	input [3:0] z;
// 	output reg [9:0] x, y;
	
// 	always @(enable) begin 
// 		if(z == 3'b001) begin //up
// 			x = x;
// 			y = y - 1;
// 		end
// 		else if(z == 3'b010) begin //left
// 			x = x - 1;
// 			y = y;
// 		end 
// 		else if(z == 3'b011) begin //down
// 			x = x;
// 			y = y + 1;
// 		end
// 		else if(z == 3'b100) begin  //right
// 			x = x + 1;
// 			y = y;
// 		end
// 		else begin
// 			x = x;
// 			y = y;
// 		end
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