// Filename: blocks_testbench.v

`timescale 1ns / 1ps

module blocks_testbench ();

    parameter CLOCK_PERIOD = 20;

    reg clock;
    reg resetn;
    reg enable;
    wire wren;
    wire finished;
    wire [11:0] data;
    wire [14:0] addr;
    wire [8:0] blk_addr;
    wire blk_q;
    wire blk_wren;

    // Clock generation
    initial begin
        clock <= 1'b0;
    end
    always @ (*) begin
        #((CLOCK_PERIOD) / 2) clock <= ~clock;
    end

    // Module under test
    // module m_render_blocks(clock, resetn, enable, wren, finished, data, addr, blk_addr, blk_q, blk_wren);
    m_render_blocks UUT (
        .clock(clock),
        .resetn(resetn),
        .enable(enable),
        .wren(wren),
        .finished(finished),
        .data(data),
        .addr(addr),
        .blk_addr(blk_addr),
        .blk_q(blk_q),
        .blk_wren(blk_wren)
    );

    // Instantiate the blocks module
    blocks BLOCKS (
        .address(blk_addr),
        .clock(clock),
        .data(blk_data),
        .wren(blk_wren),
        .q(blk_q)
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