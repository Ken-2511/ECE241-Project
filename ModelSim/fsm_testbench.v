`timescale 1ns / 1ps

module fsm_testbench ();

    parameter CLOCK_PERIOD = 20;

    reg clock;
    reg resetn;
    reg enable;
    reg key3;
    wire f_greeting, f_playing, f_game_over;
    wire [2:0] data;
    wire [16:0] addr;
    wire wren;
    wire [2:0] q;
    wire [8:0] VGA_X;
    wire [7:0] VGA_Y;
    wire [2:0] VGA_COLOR;

    // Clock generation
    initial begin
        clock <= 1'b0;
    end
    always @ (*) begin
        #((CLOCK_PERIOD) / 2) clock <= ~clock;
    end

    // Instantiate game_state_control module
    fsm_game_state UUT (
        .clock(clock),
        .resetn(resetn),
        .enable(enable),
        .key3(key3),
        .data(data),
        .addr(addr),
        .wren(wren),
        .q(q),
        .VGA_X(VGA_X),
        .VGA_Y(VGA_Y),
        .VGA_COLOR(VGA_COLOR)
    );

    // Test stimulus
    initial begin
        // Initialize signals
        resetn = 1'b0;
        enable = 1'b0;
        key3 = 1'b1;
        
        // Apply reset
        #20 resetn = 1'b1; // Release reset
        
        // Enable FSM
        #20 enable = 1'b1;
        
        // Test GREETING state transition
        #40 key3 = 1'b0; // Simulate key press to progress from GREETING to PLAYING
        #20 key3 = 1'b1;

        // Wait for a while
        #100;
        
    end

endmodule
