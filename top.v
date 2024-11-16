	// inout PS2_CLK;
	// inout PS2_DAT;

    // // for PS2 controller
	// wire [7:0] ps2_key_data;
	// wire ps2_key_pressed;
	// reg [7:0] last_key_received;
	
	// wire hs_enable;
	// half_sec_counter counter(CLOCK_50, KEY[0], hs_enable);
	
	// //for getting keystrokes
	// always @(CLOCK_50) begin
	// 	if(!KEY[0])
	// 		last_key_received = 8'b0;
	// 	else if(hs_enable)
	// 		last_key_received <= ps2_key_data;
	// end 
	
	// PS2_Controller PS2 (
	// 	// Inputs
	// 	.CLOCK_50				(CLOCK_50),
	// 	.reset				(~KEY[0]),

	// 	// Bidirectionals
	// 	.PS2_CLK			(PS2_CLK),
	// 	.PS2_DAT			(PS2_DAT),

	// 	// Outputs
	// 	.received_data		(ps2_key_data),
	// 	.received_data_en	(ps2_key_pressed)
	// );

    
	// //note: may have to put the current top module in another module later
	// //player character
	// wire [8:0] vga_player_x, vga_player_y;
	// reg [8:0] x, y;
	// wire [3:0] w; //internal carry to deal with the movement FSM
	// wire [2:0] direction;
	// parameter up = 3'b001, left = 3'b010, down = 3'b011, right = 3'b100;
	
	// initial begin
	// 	x = 9'b0;
	// 	y = 9'b0;
	// end 
	
	// get_direction U4 (last_key_received, hs_enable, w);
	// movement_FSM U5 (CLOCK_50, KEY[0], hs_enable, w, direction);
	
	// always @(hs_enable) begin 
	// 	if(direction == up) begin 
	// 		x = x;
	// 		y = y - 1;
	// 	end 
	// 	else if (direction == left) begin 
	// 		x = x - 1;
	// 		y = y;
	// 	end 
	// 	else if(direction == down) begin 
	// 		x = x;
	// 		y = y + 1;
	// 	end 
	// 	else if(direction == right) begin 
	// 		x = x + 1;
	// 		y = y;
	// 	end 
	// end 
	
	// assign vga_player_x = x;
	// assign vga_player_y = y;
	