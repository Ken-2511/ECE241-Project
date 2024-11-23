`timescale 1ns / 1ps

module renderer_tb;

    // Testbench signals
    reg clock;
    reg resetn;
    reg enable;
    wire finished;

    // VGA outputs
    wire [7:0] VGA_X;
    wire [6:0] VGA_Y;
    wire [11:0] VGA_COLOR;

    // Player
    reg [4:0] pl_game_x;
    reg [3:0] pl_game_y;
    reg [11:0] pl_color;

    // Ghosts
    reg [4:0] g1_game_x;
    reg [3:0] g1_game_y;
    reg [11:0] g1_color;
    reg [4:0] g2_game_x;
    reg [3:0] g2_game_y;
    reg [11:0] g2_color;
    reg [4:0] g3_game_x;
    reg [3:0] g3_game_y;
    reg [11:0] g3_color;

    // Background
    reg [11:0] bg_color;
    wire [7:0] bg_x;
    wire [6:0] bg_y;

    // Instantiate the renderer module
    m_renderer uut (
        .clock(clock),
        .resetn(resetn),
        .enable(enable),
        .finished(finished),
        .VGA_X(VGA_X),
        .VGA_Y(VGA_Y),
        .VGA_COLOR(VGA_COLOR),
        .pl_game_x(pl_game_x),
        .pl_game_y(pl_game_y),
        .g1_game_x(g1_game_x),
        .g1_game_y(g1_game_y),
        .g2_game_x(g2_game_x),
        .g2_game_y(g2_game_y),
        .g3_game_x(g3_game_x),
        .g3_game_y(g3_game_y),
        .bg_x(bg_x),
        .bg_y(bg_y),
        .bg_color(bg_color)
    );

    // Clock generation
    always #5 clock = ~clock;

    initial begin
        // Initialize signals
        clock = 0;
        resetn = 0;
        enable = 0;

        bg_color = 3'b010;      // Background color: Green
        pl_game_x = 5'b00100;  // Player initial position (x = 4)
        pl_game_y = 4'b0010;   // Player initial position (y = 2)
        pl_color = 3'b111;     // Player color: White

        g1_game_x = 5'b00010;  // Ghost 1 initial position (x = 2)
        g1_game_y = 4'b0011;   // Ghost 1 initial position (y = 3)
        g1_color = 3'b100;     // Ghost 1 color: Red

        g2_game_x = 5'b00101;  // Ghost 2 initial position (x = 5)
        g2_game_y = 4'b0100;   // Ghost 2 initial position (y = 4)
        g2_color = 3'b011;     // Ghost 2 color: Cyan

        g3_game_x = 5'b00110;  // Ghost 3 initial position (x = 6)
        g3_game_y = 4'b0101;   // Ghost 3 initial position (y = 5)
        g3_color = 3'b001;     // Ghost 3 color: Blue

        // Reset the module
        #10 resetn = 1;

        // Start rendering
        #10 enable = 1;

        // Wait for rendering to finish
        wait(finished);

        // Update positions to simulate movement
        #10;
        pl_game_x = 5'b00101;  // Player moves to (x = 5)
        pl_game_y = 4'b0011;   // Player moves to (y = 3)

        g1_game_x = 5'b00011;  // Ghost 1 moves to (x = 3)
        g1_game_y = 4'b0010;   // Ghost 1 moves to (y = 2)

        g2_game_x = 5'b00110;  // Ghost 2 moves to (x = 6)
        g2_game_y = 4'b0101;   // Ghost 2 moves to (y = 5)

        g3_game_x = 5'b00111;  // Ghost 3 moves to (x = 7)
        g3_game_y = 4'b0110;   // Ghost 3 moves to (y = 6)

        // Enable rendering again
        enable = 0;
        #10 enable = 1;

        // Wait for rendering to finish
        wait(finished);

        // Stop the simulation
        enable = 0;
    end

endmodule
