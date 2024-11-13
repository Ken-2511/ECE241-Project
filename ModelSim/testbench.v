`timescale 1ns / 1ps

module testbench ( );

	parameter CLOCK_PERIOD = 20;

    reg CLOCK_50;	
	reg [7:0] SW;
	reg [3:0] KEY;
    wire [6:0] HEX3, HEX2, HEX1, HEX0;
	wire [7:0] VGA_R;
	wire [7:0] VGA_G;
	wire [7:0] VGA_B;
	wire VGA_HS;
	wire VGA_VS;
	wire VGA_BLANK_N;
	wire VGA_SYNC_N;
	wire VGA_CLK;	
	reg PS2_CLK;
	reg PS2_DAT;

	initial begin
        CLOCK_50 <= 1'b0;
	end // initial
	always @ (*)
	begin : Clock_Generator
		#((CLOCK_PERIOD) / 2) CLOCK_50 <= ~CLOCK_50;
	end
	
	initial begin
        KEY <= 4'b0;
        #20 KEY[0] <= 1'b1; // reset
	end // initial

	initial begin
        KEY[1] <= 1'b1; KEY[2] <= 1'b1; KEY[3] <= 1'b1;
        SW <= 8'b01001000;  // randomly chosen (x,y) address
        #20 KEY[1] <= 1'b0; // press to store y
        #20 KEY[1] <= 1'b1;
        #20 KEY[2] <= 1'b0; // press to store x
        #20 KEY[2] <= 1'b1;
        #20 KEY[3] <= 1'b0; // press to display (in reality would stay
                            // pressed long enough to draw the whole box
	end // initial

	// // test the ps2 module
	// initial begin
	// 	// PS/2 protocol: start bit (0), 8 data bits, parity bit, stop bit (1)
	// 	// Let's send the byte 0xF0 (which is often the "break" code prefix in PS/2 keyboards)
	// 	#10000;  // Wait some time to allow everything else to initialize

	// 	// Start bit (0)
	// 	PS2_CLK <= 1'b1; // Ensure the clock line is initially high
	// 	PS2_DAT <= 1'b0; // Start bit is always 0
	// 	#(CLOCK_PERIOD * 10); // Wait one clock period

	// 	// Send 8 data bits (for byte 0xF0)
	// 	send_ps2_data_byte(8'hF0);

	// 	// Optionally, you could send more data bytes here to simulate multiple key events
	// end

	// // This task will send one byte of data over PS2_DATA and generate the corresponding PS2 clock transitions.
	// task send_ps2_data_byte(input [7:0] data_byte);
	// 	integer i;
	// 	reg parity_bit;
	// 	begin
	// 		// Calculate odd parity bit
	// 		parity_bit = ^data_byte; // Odd parity is the XOR of all data bits
	// 		parity_bit = ~parity_bit; // Make it odd parity by negating

	// 		// Send 8 data bits (LSB first)
	// 		for (i = 0; i < 8; i = i + 1) begin
	// 			PS2_CLK <= 0; // Set PS2_CLK low
	// 			#(CLOCK_PERIOD / 2);
	// 			PS2_DAT <= data_byte[i]; // Send data bit
	// 			PS2_CLK <= 1; // Set PS2_CLK high
	// 			#(CLOCK_PERIOD / 2);
	// 		end

	// 		// Send parity bit
	// 		PS2_CLK <= 0; // Set PS2_CLK low
	// 		#(CLOCK_PERIOD / 2);
	// 		PS2_DAT <= parity_bit; // Send parity bit
	// 		PS2_CLK <= 1; // Set PS2_CLK high
	// 		#(CLOCK_PERIOD / 2);

	// 		// Send stop bit (always 1)
	// 		PS2_CLK <= 0; // Set PS2_CLK low
	// 		#(CLOCK_PERIOD / 2);
	// 		PS2_DAT <= 1; // Stop bit
	// 		PS2_CLK <= 1; // Set PS2_CLK high
	// 		#(CLOCK_PERIOD / 2);

	// 		// Idle state, both lines high
	// 		PS2_CLK <= 1;
	// 		PS2_DAT <= 1;
	// 	end
	// endtask


	milestone1 U1 (CLOCK_50, SW, KEY[3:0], HEX3, HEX2, HEX1, HEX0, VGA_R, VGA_G, VGA_B,
				VGA_HS, VGA_VS, VGA_BLANK_N, VGA_SYNC_N, VGA_CLK);
	
	// ps2 U2(CLOCK_50, KEY, VGA_R, VGA_G, VGA_B, VGA_HS, VGA_VS, VGA_BLANK_N, VGA_SYNC_N, VGA_CLK, PS2_CLK, PS2_DAT);

endmodule