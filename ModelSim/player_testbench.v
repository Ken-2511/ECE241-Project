`timescale 1ns / 1ps

module player_testbench ();

    parameter CLOCK_PERIOD = 20;

    reg clock;
    reg resetn;
    reg enable;
    wire wren;
    wire finished;
    wire [11:0] data;
    wire [14:0] addr;
    wire [7:0] VGA_X;
    wire [6:0] VGA_Y;
    wire [11:0] VGA_COLOR;
    reg [5:0] game_x;
    reg [4:0] game_y;
    reg [1:0] direct;

    // Clock generation
    initial begin
        clock <= 1'b0;
    end
    always @ (*) begin
        #((CLOCK_PERIOD) / 2) clock <= ~clock;
    end

    // module m_render_player(clock, resetn, enable, wren, finished, data, addr, VGA_X, VGA_Y, VGA_COLOR, game_x, game_y, direct);
    m_render_player UUT (
        .clock(clock),
        .resetn(resetn),
        .enable(enable),
        .wren(wren),
        .finished(finished),
        .data(data),
        .addr(addr),
        .VGA_X(VGA_X),
        .VGA_Y(VGA_Y),
        .VGA_COLOR(VGA_COLOR),
        .game_x(game_x),
        .game_y(game_y),
        .direct(direct)
    );

    // Test stimulus
    initial begin
        // Initialize signals
        resetn = 1'b0;
        enable = 1'b0;
        game_x = 8'h01;
        game_y = 7'h01;
        direct = 2'b00;
        
        // Release reset
        #20 resetn = 1'b1;
        
        // Enable module
        #20 enable = 1'b1;
        
    end

    always @(posedge clock) begin
        if (finished) begin
            enable = 1'b0;
        end
    end

endmodule
