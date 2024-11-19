// Filename: food_testbench.v

`timescale 1ns / 1ps

module food_testbench ();

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

    // Clock generation
    initial begin
        clock <= 1'b0;
    end
    always @ (*) begin
        #((CLOCK_PERIOD) / 2) clock <= ~clock;
    end

    // Module under test
    // m_render_food(clock, resetn, enable, wren, finished, data, addr, VGA_X, VGA_Y, VGA_COLOR);
    m_render_food UUT (
        .clock(clock),
        .resetn(resetn),
        .enable(enable),
        .wren(wren),
        .finished(finished),
        .data(data),
        .addr(addr),
        .VGA_X(VGA_X),
        .VGA_Y(VGA_Y),
        .VGA_COLOR(VGA_COLOR)
    );

    // Test stimulus
    initial begin
        // Initialize signals
        resetn = 1'b0;
        enable = 1'b0;
        
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