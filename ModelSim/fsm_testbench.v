`timescale 1ns / 1ps

module fsm_testbench ();

    parameter CLOCK_PERIOD = 20;

    reg clock;
    reg resetn;
    reg enable;
    reg key3;
    wire f_greeting, f_playing, f_game_over;
    wire [23:0] data;
    wire [14:0] addr;
    wire wren;
    wire [23:0] q;
    wire [7:0] VGA_X;
    wire [6:0] VGA_Y;
    wire [23:0] VGA_COLOR;
    reg [7:0] last_key_received;

    // Clock generation
    initial begin
        clock <= 1'b0;
    end
    always @ (*) begin
        #((CLOCK_PERIOD) / 2) clock <= ~clock;
    end

    // Instantiate game_state_control module
    // module fsm_game_state(clock, resetn, enable, data, addr, wren, q, VGA_X, VGA_Y, VGA_COLOR, last_key_received);

    fsm_game_state UUT (
        .clock(clock),
        .resetn(resetn),
        .enable(enable),
        .data(data),
        .addr(addr),
        .wren(wren),
        .q(q),
        .VGA_X(VGA_X),
        .VGA_Y(VGA_Y),
        .VGA_COLOR(VGA_COLOR),
        .last_key_received(last_key_received)
    );

    canvas canvas_inst(
        .address(addr),
        .clock(clock),
        .data(data),
        .wren(wren),
        .q(q)
    );

    // Test stimulus
    initial begin
        // Initialize signals
        resetn = 1'b0;
        enable = 1'b0;
        key3 = 1'b1;
        last_key_received = 8'h00;
        
        // Apply reset
        #20 resetn = 1'b1; // Release reset
        
        // Enable FSM
        #20 enable = 1'b1;
        
        // Test GREETING state transition
        #40 key3 = 1'b0; // Simulate key press to progress from GREETING to PLAYING
        #20 key3 = 1'b1;
        
    end

    initial begin
        #10200 last_key_received = 8'h29;
        #100 last_key_received = 8'h2a;
    end

endmodule
