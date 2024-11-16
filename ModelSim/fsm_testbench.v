`timescale 1ns / 1ps

module fsm_testbench ();

    parameter CLOCK_PERIOD = 20;

    reg clock;
    reg resetn;
    reg enable;
    reg key3;
    wire f_greeting, f_playing, f_game_over;

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
        .key3(key3)
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
