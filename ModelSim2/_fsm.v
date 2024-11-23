// filename: _fsm.v

`timescale 1ns/1ps

module fsm_tb;

    // Testbench inputs
    reg clock;
    reg resetn;
    reg enable;
    reg [7:0] last_key_received;

    // Testbench outputs
    wire [7:0] VGA_X;
    wire [6:0] VGA_Y;
    wire [11:0] VGA_COLOR;

    // Instantiate the FSM
    fsm_game_state uut (
        .clock(clock),
        .resetn(resetn),
        .enable(enable),
        .last_key_received(last_key_received),
        .VGA_X(VGA_X),
        .VGA_Y(VGA_Y),
        .VGA_COLOR(VGA_COLOR)
    );

    // Clock generation
    initial begin
        clock = 0;
        forever #10 clock = ~clock; // 10 ns clock period
    end

    // Reset and stimulus
    initial begin
        // Initialize inputs
        resetn = 0;
        enable = 0;
        last_key_received = 8'h00;

        // Apply reset
        #20 resetn = 1;
        #20 enable = 1;

        // Test GREETING state
        #20 last_key_received = 8'h00; // No key pressed
        #20 last_key_received = 8'h29; // SPACE key to start game

        // Test PLAYING states
        #40 last_key_received = 8'h00; // No additional input

        // Simulate collision during PLAYING_LOGIC
        #40 last_key_received = 8'h00;

        // Game over
        #40 last_key_received = 8'h00;

    end

endmodule


// Mock submodules

// Mock greeting module
module m_greeting (
    input clock,
    input resetn,
    input enable,
    output reg finished,
    output reg [7:0] VGA_X,
    output reg [6:0] VGA_Y,
    output reg [11:0] VGA_COLOR
);
    always @(posedge clock or negedge resetn) begin
        if (!resetn)
            finished <= 0;
        else if (enable)
            finished <= 1;
    end
endmodule

// Mock game logic module
module m_game_logic (
    input clock,
    input resetn,
    input enable,
    output reg finished,
    output reg [4:0] player_x,
    output reg [3:0] player_y,
    output reg [4:0] ghost1_x, ghost2_x, ghost3_x,
    output reg [3:0] ghost1_y, ghost2_y, ghost3_y,
    input [7:0] last_key_received
);
    always @(posedge clock or negedge resetn) begin
        if (!resetn)
            finished <= 0;
        else if (enable)
            finished <= 1;
    end
endmodule

// Mock renderer module
module m_renderer (
    input clock,
    input resetn,
    input enable,
    output reg finished,
    output reg [7:0] VGA_X,
    output reg [6:0] VGA_Y,
    output reg [11:0] VGA_COLOR,
    input [4:0] player_x,
    input [3:0] player_y,
    input [4:0] ghost1_x, ghost2_x, ghost3_x,
    input [3:0] ghost1_y, ghost2_y, ghost3_y
);
    always @(posedge clock or negedge resetn) begin
        if (!resetn)
            finished <= 0;
        else if (enable)
            finished <= 1;
    end
endmodule

// Mock collision detection module
module m_collision (
    input clock,
    input resetn,
    input enable,
    input [4:0] player_x,
    input [3:0] player_y,
    input [4:0] ghost1_x, ghost2_x, ghost3_x,
    input [3:0] ghost1_y, ghost2_y, ghost3_y,
    output reg collision_detected
);
    always @(posedge clock or negedge resetn) begin
        if (!resetn)
            collision_detected <= 0;
        else if (enable)
            collision_detected <= 1; // Simulate collision detected
    end
endmodule

// Mock game over module
module m_game_over (
    input clock,
    input resetn,
    input enable,
    output reg finished,
    output reg [7:0] VGA_X,
    output reg [6:0] VGA_Y,
    output reg [11:0] VGA_COLOR
);
    always @(posedge clock or negedge resetn) begin
        if (!resetn)
            finished <= 0;
        else if (enable)
            finished <= 1;
    end
endmodule