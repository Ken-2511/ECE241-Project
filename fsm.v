module fsm_game_state(clock, resetn, enable, data, addr, wren, q, VGA_X, VGA_Y, VGA_COLOR, last_key_received);

    parameter cbit = 11;

    // Basic inputs
    input clock, resetn, enable;

    // Outputs for RAM control
    output reg [cbit:0] data;
    output reg [14:0] addr;
    output reg wren;
    input [cbit:0] q;

    // Additional outputs for VGA
    output reg [7:0] VGA_X;
    output reg [6:0] VGA_Y;
    output reg [cbit:0] VGA_COLOR;

    // State encoding
    parameter GREETING = 2'b00, PLAYING = 2'b01, GAME_OVER = 2'b10;

    // State registers
    reg [1:0] next_game_state, game_state;

    // Enable signals
    reg e_greeting, e_playing, e_game_over;

    // Finished signals
    wire f_greeting, f_playing, f_game_over;

    // Data control lines from submodules
    wire [cbit:0] dt_greeting, dt_playing, dt_game_over;
    wire [14:0] ad_greeting, ad_playing, ad_game_over;
    wire wr_greeting, wr_playing, wr_game_over;

    // VGA control lines from submodules
    wire [7:0] vga_x_greeting, vga_x_playing, vga_x_game_over;
    wire [6:0] vga_y_greeting, vga_y_playing, vga_y_game_over;
    wire [cbit:0] vga_color_greeting, vga_color_playing, vga_color_game_over;

    //half sec counter
    wire hs_enable;
    half_sec_counter(CLOCK_50, enable, hs_enable); 

    // PS2 controller input
    input [7:0] last_key_received;

    // State transition logic
    always @ (posedge clock) begin
        if (!resetn)
            game_state <= GREETING;  // Reset to initial state
        else if (enable)
            game_state <= next_game_state;  // If enabled, transition to the next state
    end

    // Next state logic
    always @ (*) begin
        case (game_state)
            GREETING: begin
                if (f_greeting)
                    next_game_state = PLAYING;  // When GREETING is finished, transition to PLAYING
                else
                    next_game_state = GREETING; // Otherwise, stay in GREETING
            end
            PLAYING: begin
                if (f_playing)
                    next_game_state = GAME_OVER;  // When PLAYING is finished, transition to GAME_OVER
                else
                    next_game_state = PLAYING;   // Otherwise, stay in PLAYING
            end
            GAME_OVER: begin
                if (f_game_over)
                    next_game_state = GREETING;  // When GAME_OVER is finished, loop back to GREETING
                else
                    next_game_state = GAME_OVER; // Otherwise, stay in GAME_OVER
            end
            default: next_game_state = GREETING; // Default state is GREETING
        endcase
    end

    // Output logic
    always @ (*) begin
        e_greeting = (game_state == GREETING);
        e_playing = (game_state == PLAYING);
        e_game_over = (game_state == GAME_OVER);
        case (game_state)
            GREETING: begin
                data = dt_greeting;
                addr = ad_greeting;
                wren = wr_greeting;
                VGA_X = vga_x_greeting;
                VGA_Y = vga_y_greeting;
                VGA_COLOR = vga_color_greeting;
            end
            PLAYING: begin
                data = dt_playing;
                addr = ad_playing;
                wren = wr_playing;
                VGA_X = vga_x_playing;
                VGA_Y = vga_y_playing;
                VGA_COLOR = vga_color_playing;
            end
            GAME_OVER: begin
                data = dt_game_over;
                addr = ad_game_over;
                wren = wr_game_over;
                VGA_X = vga_x_game_over;
                VGA_Y = vga_y_game_over;
                VGA_COLOR = vga_color_game_over;
            end
            default: begin
                data = 12'h000;
                addr = 17'b0;
                wren = 1'b0;
                VGA_X = 8'b0;
                VGA_Y = 7'b0;
                VGA_COLOR = 12'h000; // cbit is related to the parameter
            end
        endcase
    end

    // Instantiate submodules and connect VGA signals
    m_greeting m_greeting_inst(
        .clock(clock),
        .resetn(resetn),
        .enable(e_greeting),
        .finished(f_greeting),
        .data(dt_greeting),
        .addr(ad_greeting),
        .wren(wr_greeting)
    );

    m_playing m_playing_inst(
        .clock(clock),
        .resetn(resetn),
        .enable(e_playing),
        .finished(f_playing),
        .data(dt_playing),
        .addr(ad_playing),
        .wren(wr_playing),
        .q(q),
        .VGA_X(vga_x_playing),
        .VGA_Y(vga_y_playing),
        .VGA_COLOR(vga_color_playing),
        .last_key_received(last_key_received)
    );

    m_game_over m_game_over_inst(
        .clock(clock),
        .resetn(resetn),
        .enable(e_game_over),
        .finished(f_game_over),
        .data(dt_game_over),
        .addr(ad_game_over),
        .wren(wr_game_over)
    );

endmodule

