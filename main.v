module main (
    input CLOCK_50,
    input [7:0] SW,
    input [3:0] KEY,
    output [6:0] HEX3, HEX2, HEX1, HEX0,
    output [7:0] VGA_R, VGA_G, VGA_B,
    output VGA_HS, VGA_VS, VGA_BLANK_N, VGA_SYNC_N, VGA_CLK,
    inout PS2_CLK, PS2_DAT,
    output [6:0] HEX4, HEX5,
    output [9:0] LEDR,
    output [7:0] VGA_X_D,
    output [6:0] VGA_Y_D,
    output [11:0] VGA_COLOR,
    output plot
);

    parameter cbit = 11;

    // PS2 Inputs
    wire [7:0] ps2_key_data;
    wire ps2_key_pressed;
    reg [7:0] last_key_received;

    // Memory Signals
    wire [cbit:0] data;
    wire [14:0] addr;
    wire wren;
    wire [cbit:0] q;

    // VGA Positioning
    wire [7:0] VGA_X;
    wire [6:0] VGA_Y;

    // Instantiate PS2 Controller
    PS2_Controller PS2 (
        .CLOCK_50(CLOCK_50),
        .reset(~KEY[0]),
        .PS2_CLK(PS2_CLK),
        .PS2_DAT(PS2_DAT),
        .received_data(ps2_key_data),
        .received_data_en(ps2_key_pressed)
    );

    always @(posedge CLOCK_50) begin
        if (!KEY[0])
            last_key_received <= 8'b0;
        else if (ps2_key_pressed)
            last_key_received <= ps2_key_data;
    end

    hex7seg H3 (last_key_received[7:4], HEX3);
    hex7seg H2 (last_key_received[3:0], HEX2);

    // Instantiate m_playing FSM
    m_playing m_playing_inst (
        .clock(CLOCK_50),
        .resetn(KEY[0]),
        .enable(~KEY[3]),
        .finished(LEDR[0]), // Game status indicator
        .data(data),
        .addr(addr),
        .wren(wren),
        .q(q),
        .VGA_X(VGA_X),
        .VGA_Y(VGA_Y),
        .VGA_COLOR(VGA_COLOR),
        .last_key_received(last_key_received)
    );

    delay_one_cycle delay_x (
        .clock(CLOCK_50),
        .resetn(KEY[0]),
        .in(VGA_X),
        .out(VGA_X_D)
    );
    defparam delay_x.n = 8;
    defparam delay_x.n_cycles = 1;

    delay_one_cycle delay_y (
        .clock(CLOCK_50),
        .resetn(KEY[0]),
        .in(VGA_Y),
        .out(VGA_Y_D)
    );
    defparam delay_y.n = 7;
    defparam delay_y.n_cycles = 1;

    // VGA Adapter
    vga_adapter VGA (
        .resetn(KEY[0]),
        .clock(CLOCK_50),
        .colour(VGA_COLOR),
        .x(VGA_X_D),
        .y(VGA_Y_D),
        .plot(~KEY[3]),
        .VGA_R(VGA_R),
        .VGA_G(VGA_G),
        .VGA_B(VGA_B),
        .VGA_HS(VGA_HS),
        .VGA_VS(VGA_VS),
        .VGA_BLANK_N(VGA_BLANK_N),
        .VGA_SYNC_N(VGA_SYNC_N),
        .VGA_CLK(VGA_CLK)
    );
    defparam VGA.RESOLUTION = "160x120";
    defparam VGA.MONOCHROME = "FALSE";
    defparam VGA.BITS_PER_COLOUR_CHANNEL = 4;
    defparam VGA.BACKGROUND_IMAGE = "canvas.mif";

endmodule
