module renderer (
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
    input wire [2:0] g1_color,
    input wire [4:0] g2_game_x,
    input wire [3:0] g2_game_y,
    input wire [2:0] g2_color,
    input wire [4:0] g3_game_x,
    input wire [3:0] g3_game_y,
    input wire [2:0] g3_color
);

    // State encoding
    parameter IDLE = 3'b000, ERASE_PLAYER = 3'b001, ERASE_GHOSTS = 3'b010,
              DRAW_PLAYER = 3'b011, DRAW_GHOSTS = 3'b100, DONE = 3'b101;
    reg [2:0] state, next_state;

    // Previous positions for erasing
    reg [4:0] prev_pl_game_x, prev_g1_game_x, prev_g2_game_x, prev_g3_game_x;
    reg [3:0] prev_pl_game_y, prev_g1_game_y, prev_g2_game_y, prev_g3_game_y;

    // Ghost index for sequential updates
    reg [1:0] ghost_index; // 0: Ghost 1, 1: Ghost 2, 2: Ghost 3

    // Pixel rendering variables
    reg [3:0] dx, dy; // Offset within the 5x5 block

    // Ghost current and previous positions based on ghost_index
    wire [7:0] curr_ghost_canvas_x, prev_ghost_canvas_x;
    wire [6:0] curr_ghost_canvas_y, prev_ghost_canvas_y;
    wire [2:0] curr_ghost_color;

    assign curr_ghost_canvas_x = (ghost_index == 0) ? g1_game_x * 5 :
                                 (ghost_index == 1) ? g2_game_x * 5 :
                                 g3_game_x * 5;

    assign curr_ghost_canvas_y = (ghost_index == 0) ? g1_game_y * 5 :
                                 (ghost_index == 1) ? g2_game_y * 5 :
                                 g3_game_y * 5;

    assign curr_ghost_color = (ghost_index == 0) ? g1_color :
                              (ghost_index == 1) ? g2_color :
                              g3_color;

    assign prev_ghost_canvas_x = (ghost_index == 0) ? prev_g1_game_x * 5 :
                                 (ghost_index == 1) ? prev_g2_game_x * 5 :
                                 prev_g3_game_x * 5;

    assign prev_ghost_canvas_y = (ghost_index == 0) ? prev_g1_game_y * 5 :
                                 (ghost_index == 1) ? prev_g2_game_y * 5 :
                                 prev_g3_game_y * 5;

    // State transition logic
    always @ (posedge clock or negedge resetn) begin
        if (!resetn)
            state <= IDLE;
        else if (enable)
            state <= next_state;
    end

    always @ (*) begin
        case (state)
            IDLE: next_state = ERASE_PLAYER;
            ERASE_PLAYER: next_state = (dx == 4 && dy == 4) ? ERASE_GHOSTS : ERASE_PLAYER;
            ERASE_GHOSTS: next_state = (dx == 4 && dy == 4 && ghost_index == 2) ? DRAW_PLAYER : ERASE_GHOSTS;
            DRAW_PLAYER: next_state = (dx == 4 && dy == 4) ? DRAW_GHOSTS : DRAW_PLAYER;
            DRAW_GHOSTS: next_state = (dx == 4 && dy == 4 && ghost_index == 2) ? DONE : DRAW_GHOSTS;
            DONE: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Rendering logic
    always @ (posedge clock or negedge resetn) begin
        if (!resetn) begin
            // Reset state and variables
            VGA_X <= 0;
            VGA_Y <= 0;
            VGA_COLOR <= 3'b0;
            dx <= 0;
            dy <= 0;
            ghost_index <= 0;
            finished <= 0;

            // Reset previous positions
            prev_pl_game_x <= 0;
            prev_pl_game_y <= 0;
            prev_g1_game_x <= 0;
            prev_g1_game_y <= 0;
            prev_g2_game_x <= 0;
            prev_g2_game_y <= 0;
            prev_g3_game_x <= 0;
            prev_g3_game_y <= 0;
        end
        else if (enable) begin
            case (state)
                // Erase previous player position
                ERASE_PLAYER: begin
                    VGA_X <= prev_pl_game_x * 5 + dx;
                    VGA_Y <= prev_pl_game_y * 5 + dy;
                    VGA_COLOR <= bg_color;

                    if (dx < 4)
                        dx <= dx + 1;
                    else if (dy < 4) begin
                        dx <= 0;
                        dy <= dy + 1;
                    end
                    else begin
                        dx <= 0;
                        dy <= 0;
                    end
                end

                // Erase previous ghost positions
                ERASE_GHOSTS: begin
                    VGA_X <= prev_ghost_canvas_x + dx;
                    VGA_Y <= prev_ghost_canvas_y + dy;
                    VGA_COLOR <= bg_color;

                    if (dx < 4)
                        dx <= dx + 1;
                    else if (dy < 4) begin
                        dx <= 0;
                        dy <= dy + 1;
                    end
                    else if (ghost_index < 2) begin
                        dx <= 0;
                        dy <= 0;
                        ghost_index <= ghost_index + 1;
                    end
                    else begin
                        dx <= 0;
                        dy <= 0;
                        ghost_index <= 0;
                    end
                end

                // Draw current player position
                DRAW_PLAYER: begin
                    VGA_X <= pl_game_x * 5 + dx;
                    VGA_Y <= pl_game_y * 5 + dy;
                    VGA_COLOR <= pl_color;

                    if (dx < 4)
                        dx <= dx + 1;
                    else if (dy < 4) begin
                        dx <= 0;
                        dy <= dy + 1;
                    end
                    else begin
                        dx <= 0;
                        dy <= 0;
                    end
                end

                // Draw current ghost positions
                DRAW_GHOSTS: begin
                    VGA_X <= curr_ghost_canvas_x + dx;
                    VGA_Y <= curr_ghost_canvas_y + dy;
                    VGA_COLOR <= curr_ghost_color;

                    if (dx < 4)
                        dx <= dx + 1;
                    else if (dy < 4) begin
                        dx <= 0;
                        dy <= dy + 1;
                    end
                    else if (ghost_index < 2) begin
                        dx <= 0;
                        dy <= 0;
                        ghost_index <= ghost_index + 1;
                    end
                    else begin
                        dx <= 0;
                        dy <= 0;
                        ghost_index <= 0;
                    end
                end

                // Mark rendering as finished
                DONE: begin
                    finished <= 1;

                    // Update previous positions
                    prev_pl_game_x <= pl_game_x;
                    prev_pl_game_y <= pl_game_y;
                    prev_g1_game_x <= g1_game_x;
                    prev_g1_game_y <= g1_game_y;
                    prev_g2_game_x <= g2_game_x;
                    prev_g2_game_y <= g2_game_y;
                    prev_g3_game_x <= g3_game_x;
                    prev_g3_game_y <= g3_game_y;
                end
            endcase
        end
        else begin
            finished <= 0;
        end
    end

endmodule
