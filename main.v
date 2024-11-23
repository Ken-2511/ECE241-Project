module main (
    input CLOCK_50,
    input [7:0] SW,
    input [3:0] KEY,
    output [6:0] HEX3, HEX2,
    output [7:0] VGA_R, VGA_G, VGA_B,
    output VGA_HS, VGA_VS, VGA_BLANK_N, VGA_SYNC_N, VGA_CLK,
    inout PS2_CLK, PS2_DAT,
    output [11:0] VGA_COLOR
);

    parameter cbit = 11;

    // PS2 Inputs
    wire [7:0] ps2_key_data;
    wire ps2_key_pressed;
    reg [7:0] _last_key_received;
    wire [7:0] last_key_received;

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

    // Latch the last key received
    always @(posedge CLOCK_50) begin
        if (!KEY[0])
            _last_key_received <= 8'b0;
        else if (ps2_key_pressed)
            _last_key_received <= ps2_key_data;
    end

    // Display the key data on HEX displays
    hex7seg H3 (_last_key_received[7:4], HEX3);
    hex7seg H2 (_last_key_received[3:0], HEX2);

    // Instantiate the game FSM
    fsm_game_state game_fsm (
        .clock(CLOCK_50),
        .resetn(KEY[0]),
        .enable(1'b1),
        .last_key_received(last_key_received),
        .VGA_X(VGA_X),
        .VGA_Y(VGA_Y),
        .VGA_COLOR(VGA_COLOR),
        .start_key(KEY[2])
    );

    // VGA Adapter
    vga_adapter VGA (
        .resetn(KEY[0]),
        .clock(CLOCK_50),
        .colour(VGA_COLOR),
        .x(VGA_X),
        .y(VGA_Y),
        .plot(1'b1),
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

    // debounce the key
    debounce_filter debounce (
        .clock(CLOCK_50),
        .resetn(KEY[0]),
        .A(_last_key_received),
        .B(last_key_received)
    );
    defparam debounce.n = 8;
    defparam debounce.THRESHOLD = 25000;

endmodule
