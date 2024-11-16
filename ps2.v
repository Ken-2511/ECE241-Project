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
// 			right: 
// 				if (w == 3'b001) next_state = up;
// 				else if (w == 3'b010) next_state = left;
// 				else if (w == 3'b011) next_state = down;
// 				else next_state = up;
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