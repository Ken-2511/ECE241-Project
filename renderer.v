module m_renderer (
    input wire clock,               // Clock signal
    input wire resetn,              // Active-low reset
    input wire enable,              // Enable rendering
    output reg finished,            // Rendering finished flag

    // VGA outputs
    output reg [7:0] VGA_X,         // VGA x-coordinate
    output reg [6:0] VGA_Y,         // VGA y-coordinate
    output reg [2:0] VGA_COLOR,     // VGA color output

    // Background
    input wire [2:0] bg_color,

    // Player
    input wire [4:0] pl_game_x,
    input wire [3:0] pl_game_y,
    input wire [2:0] pl_color,

    // Ghosts
    input wire [4:0] g1_game_x,
    input wire [3:0] g1_game_y,
    input wire [4:0] g2_game_x,
    input wire [3:0] g2_game_y,
    input wire [4:0] g3_game_x,
    input wire [3:0] g3_game_y
);

    // State encoding
    parameter IDLE = 3'b000, ERASE = 3'b001, DRAW = 3'b010, DONE = 3'b011;
    reg [2:0] state, next_state;

    // Rendering variables
    reg [4:0] curr_x, curr_y;       // Current rendering logical coordinates
    reg [3:0] dx, dy;               // Offsets within the block

    // Rendering target index
    reg [1:0] render_index;         // 0: Player, 1: Ghost 1, 2: Ghost 2, 3: Ghost 3

    // State transition logic
    always @(posedge clock or negedge resetn) begin
        if (!resetn)
            state <= IDLE;
        else if (enable)
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: 
                next_state = ERASE;
            ERASE: 
                next_state = (render_index == 3 && dx == 4 && dy == 4) ? DRAW : ERASE;
            DRAW: 
                next_state = (render_index == 3 && dx == 4 && dy == 4) ? DONE : DRAW;
            DONE: 
                next_state = IDLE;
            default: 
                next_state = IDLE;
        endcase
    end

    // VGA rendering logic
    always @(posedge clock or negedge resetn) begin
        if (!resetn) begin
            // Initialize
            VGA_X <= 0;
            VGA_Y <= 0;
            VGA_COLOR <= 0;
            dx <= 0;
            dy <= 0;
            render_index <= 0;
            finished <= 0;
        end else if (enable) begin
            case (state)
                ERASE: begin
                    // Determine current object's coordinates based on render_index
                    {curr_x, curr_y} <= (render_index == 0) ? {pl_game_x, pl_game_y} :
                                        (render_index == 1) ? {g1_game_x, g1_game_y} :
                                        (render_index == 2) ? {g2_game_x, g2_game_y} : {g3_game_x, g3_game_y};

                    // Output background color
                    VGA_X <= curr_x * 5 + dx;
                    VGA_Y <= curr_y * 5 + dy;
                    VGA_COLOR <= bg_color;

                    if (dx < 4)
                        dx <= dx + 1'b1;
                    else if (dy < 4) begin
                        dx <= 0;
                        dy <= dy + 1'b1;
                    end else begin
                        dx <= 0;
                        dy <= 0;
                        if (render_index < 3)
                            render_index <= render_index + 1;
                        else
                            render_index <= 0;
                    end
                end

                DRAW: begin
                    // Draw player or ghost
                    VGA_X <= curr_x * 5 + dx;
                    VGA_Y <= curr_y * 5 + dy;
                    VGA_COLOR <= (render_index == 0) ? pl_color : 3'b110; // Assuming ghosts have a fixed color

                    if (dx < 4)
                        dx <= dx + 1'b1;
                    else if (dy < 4) begin
                        dx <= 0;
                        dy <= dy + 1'b1;
                    end else begin
                        dx <= 0;
                        dy <= 0;
                        if (render_index < 3)
                            render_index <= render_index + 1'b1;
                        else
                            render_index <= 0;
                    end
                end

                DONE: begin
                    finished <= 1'b1;
                end
            endcase
        end else begin
            finished <= 1'b0;
        end
    end

endmodule
