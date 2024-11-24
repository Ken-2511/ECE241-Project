module m_greeting (
    input clock,
    input resetn,
    input enable,
    output reg finished,
    output reg [7:0] VGA_X,
    output reg [6:0] VGA_Y,
    output reg [11:0] VGA_COLOR
);

    // Internal signals for managing rendering
    reg [14:0] pixel_counter; // Counts up to 19200 (160x120)
    wire [11:0] color_data;   // Color data from greeting_screen
    reg [7:0] x_pos;          // Current X position
    reg [6:0] y_pos;          // Current Y position

    // Instantiate the greeting_screen module
    wire q; // Output from greeting_screen memory
    greeting_screen U1 (
        .address(pixel_counter),
        .clock(clock),
        .q(q)
    );

    // Calculate X and Y positions based on pixel_counter
    always @(*) begin
        x_pos = pixel_counter % 160;  // X position (0-159)
        y_pos = pixel_counter / 160;  // Y position (0-119)
    end

    // Main sequential logic
    always @(posedge clock or negedge resetn) begin
        if (!resetn) begin
            finished <= 0;
            pixel_counter <= 0;
            VGA_X <= 0;
            VGA_Y <= 0;
            VGA_COLOR <= 12'h000;
        end
        else if (enable) begin
            if (pixel_counter < 19200) begin
                VGA_X <= x_pos;
                VGA_Y <= y_pos;
                VGA_COLOR <= (q == 1'b1) ? 12'hFA8 : 12'h611; // Choose color based on screen data
                pixel_counter <= pixel_counter + 1;
            end
            else begin
                finished <= 1; // Indicate completion
                pixel_counter <= 0; // Reset for next use
            end
        end
        else if (finished) begin
            finished <= 0; // Clear finished signal if disabled
        end
    end

endmodule


module m_game_over (
    input clock,
    input resetn,
    input enable,
    output reg finished,
    output reg [7:0] VGA_X,
    output reg [6:0] VGA_Y,
    output reg [11:0] VGA_COLOR
);

    // Internal signals for managing rendering
    reg [14:0] pixel_counter; // Counts up to 19200 (160x120)
    wire [11:0] color_data;   // Color data from greeting_screen
    reg [7:0] x_pos;          // Current X position
    reg [6:0] y_pos;          // Current Y position

    // Instantiate the greeting_screen module
    wire q; // Output from greeting_screen memory
    game_over_screen U1 (
        .address(pixel_counter),
        .clock(clock),
        .q(q)
    );

    // Calculate X and Y positions based on pixel_counter
    always @(*) begin
        x_pos = pixel_counter % 160;  // X position (0-159)
        y_pos = pixel_counter / 160;  // Y position (0-119)
    end

    // Main sequential logic
    always @(posedge clock or negedge resetn) begin
        if (!resetn) begin
            finished <= 0;
            pixel_counter <= 0;
            VGA_X <= 0;
            VGA_Y <= 0;
            VGA_COLOR <= 12'h000;
        end
        else if (enable) begin
            if (pixel_counter < 19200) begin
                VGA_X <= x_pos;
                VGA_Y <= y_pos;
                VGA_COLOR <= (q == 1'b1) ? 12'hFA8 : 12'h611; // Choose color based on screen data
                pixel_counter <= pixel_counter + 1;
            end
            else begin
                finished <= 1; // Indicate completion
                pixel_counter <= 0; // Reset for next use
            end
        end
        else if (finished) begin
            finished <= 0; // Clear finished signal if disabled
        end
    end

endmodule