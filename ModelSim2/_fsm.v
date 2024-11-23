// filename: _fsm.v

`timescale 1ns/1ps

module fsm_tb;

    // Testbench inputs
    reg clock;
    reg resetn;
    reg enable;
    reg [7:0] last_key_received;
    reg start_key;  // 添加 start_key 作为一个输入信号

    // Testbench outputs
    wire [7:0] VGA_X;
    wire [6:0] VGA_Y;
    wire [11:0] VGA_COLOR;
    reg collided;

    // Instantiate the FSM
    fsm_game_state uut (
        .clock(clock),
        .resetn(resetn),
        .enable(enable),
        .last_key_received(last_key_received),
        .VGA_X(VGA_X),
        .VGA_Y(VGA_Y),
        .VGA_COLOR(VGA_COLOR),
        .start_key(start_key),
        .collided(collided) // Mock collision detection signal
    );
    defparam uut.HS_COUNT = 2; // Set half-second counter to 2 for faster simulation

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
        start_key = 0; // 初始化 start_key 为 0
        collided = 0;

        // Apply reset
        #20 resetn = 1;
        #20 enable = 1;

        // Test GREETING state
        #20 start_key = 0; // No key pressed
        #20 start_key = 1; // 触发开始游戏

        // Test PLAYING states
        #40 start_key = 0; // Reset start_key after game starts
        last_key_received = 8'h00; // No additional input
        // collided = 1'b1; // Simulate collision during PLAYING_LOGIC

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
