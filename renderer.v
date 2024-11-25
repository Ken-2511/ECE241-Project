module m_renderer (
    input wire clock,               // Clock signal
    input wire resetn,              // Active-low reset
    input wire enable,              // Enable rendering
    output reg finished,            // Rendering finished flag

    // VGA outputs
    output reg [7:0] VGA_X,         // VGA x-coordinate
    output reg [6:0] VGA_Y,         // VGA y-coordinate
    output reg [11:0] VGA_COLOR,    // VGA color output (12-bit: R,G,B each 4-bit)

    // Player
    input wire [4:0] pl_game_x,
    input wire [3:0] pl_game_y,

    // Ghosts
    input wire [4:0] g1_game_x,
    input wire [3:0] g1_game_y,
    input wire [4:0] g2_game_x,
    input wire [3:0] g2_game_y,
    input wire [4:0] g3_game_x,
    input wire [3:0] g3_game_y,

    // Background
    output reg [7:0] bg_x,
    output reg [6:0] bg_y,
    input wire [11:0] bg_color
);

    // flag for first time rendering
    reg first_time_rendering;

    // player and ghost data
    wire [11:0] selected_data;
    wire is_ghost;
    // last game x and y
    reg [4:0] pl_game_x_, g1_game_x_, g2_game_x_, g3_game_x_;
    reg [3:0] pl_game_y_, g1_game_y_, g2_game_y_, g3_game_y_;

    // Rendering variables
    reg [4:0] curr_x;       // Current rendering logical coordinates
    reg [3:0] curr_y;
    reg [3:0] dx, dy;       // Offsets within the block
    reg [11:0] curr_color;  // Current rendering color (12-bit: R,G,B each 4-bit)

    // Done counter for making sure the delay is correct
    reg [3:0] done_counter;
    reg [3:0] erase_counter;

    // State encoding
    parameter IDLE = 4'b0000, 
              ERASE_PLAYER = 4'b0001, 
              DRAW_PLAYER = 4'b0010, 
              DRAW_GHOST1 = 4'b0011, 
              DRAW_GHOST2 = 4'b0100, 
              DRAW_GHOST3 = 4'b0101, 
              DONE = 4'b0110, 
              DRAW_BG = 4'b0111,
              ERASE_GHOST1 = 4'b1000,
              ERASE_GHOST2 = 4'b1001,
              ERASE_GHOST3 = 4'b1010;
    
    reg [3:0] state, next_state;

    assign is_ghost = state == DRAW_GHOST1 || state == DRAW_GHOST2 || state == DRAW_GHOST3;

    // State transition logic
    always @(posedge clock or negedge resetn) begin
        if (!resetn) begin
            state <= IDLE;
        end
        else if (enable) begin
            state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: 
                next_state = (first_time_rendering) ? DRAW_BG : ERASE_PLAYER;
            DRAW_BG:
                // next_state = ERASE_PLAYER; // for testing
                next_state = (VGA_X == 159 && VGA_Y == 119) ? ERASE_PLAYER : DRAW_BG;
            ERASE_PLAYER:
                next_state = (dx == 4 && dy == 4) ? ERASE_GHOST1 : ERASE_PLAYER;
            ERASE_GHOST1:
                next_state = (dx == 4 && dy == 4) ? ERASE_GHOST2 : ERASE_GHOST1;
            ERASE_GHOST2:
                next_state = (dx == 4 && dy == 4) ? ERASE_GHOST3 : ERASE_GHOST2;
            ERASE_GHOST3:
                next_state = (dx == 4 && dy == 4 && erase_counter == 2) ? DRAW_PLAYER : ERASE_GHOST3;
            DRAW_PLAYER:
                next_state = (dx == 4 && dy == 4) ? DRAW_GHOST1 : DRAW_PLAYER;
            DRAW_GHOST1:
                next_state = (dx == 4 && dy == 4) ? DRAW_GHOST2 : DRAW_GHOST1;
            DRAW_GHOST2:
                next_state = (dx == 4 && dy == 4) ? DRAW_GHOST3 : DRAW_GHOST2;
            DRAW_GHOST3:
                next_state = (dx == 4 && dy == 4) ? DONE : DRAW_GHOST3;
            DONE: 
                next_state = (done_counter == 2) ? IDLE : DONE;
            default: 
                next_state = IDLE;
        endcase
    end

    // VGA rendering logic
    reg [7:0] VGA_X___, VGA_X__, VGA_X_; // for delaying the VGA signals
    reg [6:0] VGA_Y___, VGA_Y__, VGA_Y_;
    reg [11:0] VGA_COLOR___, VGA_COLOR__, VGA_COLOR_;
    always @(posedge clock) begin
        if (!resetn) begin
            // Initialize
            bg_x <= 8'b0;
            bg_y <= 7'b0;
            VGA_X___ <= 8'b0; VGA_X__ <= 8'b0; VGA_X_ <= 8'b0; VGA_X <= 8'b0;
            VGA_Y___ <= 7'b0; VGA_Y__ <= 7'b0; VGA_Y_ <= 7'b0; VGA_Y <= 7'b0;
            VGA_COLOR___ <= 12'hFFF; VGA_COLOR__ <= 12'hFFF; VGA_COLOR_ <= 12'hFFF; VGA_COLOR <= 12'hFFF;
            dx <= 4'b0;
            dy <= 4'b0;
            curr_x <= 5'b0;
            curr_y <= 4'b0;
            curr_color <= bg_color;
            finished <= 1'b0;
            first_time_rendering <= 1;
            pl_game_x_ <= 5'b0;
            pl_game_y_ <= 4'b0;
            g1_game_x_ <= 5'b00001;
            g1_game_y_ <= 4'b0001;
            g2_game_x_ <= 5'b00001;
            g2_game_y_ <= 4'b0001;
            g3_game_x_ <= 5'b00001;
            g3_game_y_ <= 4'b0001;
            done_counter <= 4'b0;
            erase_counter <= 4'b0;
        end
        else if (enable) begin
            case (state)
                IDLE: begin
                    // Prepare for rendering
                    dx <= 0;
                    dy <= 0;
                    curr_x <= pl_game_x;
                    curr_y <= pl_game_y;
                    curr_color <= bg_color;
                    finished <= 0;
                end

                DRAW_BG: begin
                    // Draw the background
                    if (bg_x < 159) begin
                        bg_x <= bg_x + 1;
                    end
                    else if (bg_y < 119) begin
                        bg_x <= 0;
                        bg_y <= bg_y + 1;
                    end
                    else begin
                        first_time_rendering <= 0;
                        bg_x <= 0;
                        bg_y <= 0;
                    end
                    VGA_X_ <= bg_x;
                    VGA_Y_ <= bg_y;
                    VGA_X <= VGA_X_;
                    VGA_Y <= VGA_Y_;
                    VGA_COLOR <= bg_color;
                end

                ERASE_PLAYER: begin
                    // Erase the player's previous position
                    if (dx < 4) begin
                        dx <= dx + 1;
                    end
                    else if (dy < 4) begin
                        dx <= 0;
                        dy <= dy + 1;
                    end else begin
                        dx <= 0;
                        dy <= 0;
                        curr_x <= pl_game_x;
                        curr_y <= pl_game_y;
                    end
                    bg_x <= pl_game_x_ * 5 + dx;
                    bg_y <= pl_game_y_ * 5 + dy;
                    VGA_X_ <= bg_x;
                    VGA_Y_ <= bg_y;
                    VGA_X <= VGA_X_;
                    VGA_Y <= VGA_Y_;
                    VGA_COLOR <= bg_color;
                end

                ERASE_GHOST1: begin
                    // Erase ghost 1's previous position
                    if (dx < 4) begin
                        dx <= dx + 1;
                    end
                    else if (dy < 4) begin
                        dx <= 0;
                        dy <= dy + 1;
                    end else begin
                        dx <= 0;
                        dy <= 0;
                    end
                    bg_x <= g1_game_x_ * 5 + dx;
                    bg_y <= g1_game_y_ * 5 + dy;
                    VGA_X_ <= bg_x;
                    VGA_Y_ <= bg_y;
                    VGA_X <= VGA_X_;
                    VGA_Y <= VGA_Y_;
                    VGA_COLOR <= bg_color;
                end

                ERASE_GHOST2: begin
                    // Erase ghost 2's previous position
                    if (dx < 4) begin
                        dx <= dx + 1;
                    end
                    else if (dy < 4) begin
                        dx <= 0;
                        dy <= dy + 1;
                    end else begin
                        dx <= 0;
                        dy <= 0;
                    end
                    bg_x <= g2_game_x_ * 5 + dx;
                    bg_y <= g2_game_y_ * 5 + dy;
                    VGA_X_ <= bg_x;
                    VGA_Y_ <= bg_y;
                    VGA_X <= VGA_X_;
                    VGA_Y <= VGA_Y_;
                    VGA_COLOR <= bg_color;
                end

                ERASE_GHOST3: begin
                    // Erase ghost 3's previous position
                    if (dx < 4) begin
                        dx <= dx + 1;
                    end
                    else if (dy < 4) begin
                        dx <= 0;
                        dy <= dy + 1;
                    end else if (erase_counter < 2) begin
                        erase_counter <= erase_counter + 1;
                        // VGA_X__ <= VGA_X_;
                        // VGA_Y__ <= VGA_Y_;
                        // VGA_COLOR__ <= VGA_COLOR_;
                        VGA_X_ <= VGA_X__;
                        VGA_Y_ <= VGA_Y__;
                        // VGA_COLOR_ <= VGA_COLOR__;
                        VGA_X <= VGA_X_;
                        VGA_Y <= VGA_Y_;
                        VGA_COLOR <= bg_color;
                    end
                    else begin
                        erase_counter <= 0;
                        dx <= 0;
                        dy <= 0;
                    end
                    bg_x <= g3_game_x_ * 5 + dx;
                    bg_y <= g3_game_y_ * 5 + dy;
                    VGA_X_ <= bg_x;
                    VGA_Y_ <= bg_y;
                    VGA_X <= VGA_X_;
                    VGA_Y <= VGA_Y_;
                    VGA_COLOR_ <= bg_color;
                    VGA_COLOR <= bg_color;
                end

                DRAW_PLAYER: begin
                    // Draw player
                    if (dx < 4) begin
                        dx <= dx + 1;
                    end
                    else if (dy < 4) begin
                        dx <= 0;
                        dy <= dy + 1;
                    end
                    else begin
                        dx <= 0;
                        dy <= 0;
                        pl_game_x_ <= pl_game_x;
                        pl_game_y_ <= pl_game_y;
                    end
                    VGA_X_ <= pl_game_x * 5 + dx;
                    VGA_Y_ <= pl_game_y * 5 + dy;
                    VGA_X <= VGA_X_;
                    VGA_Y <= VGA_Y_;
                    VGA_COLOR_ <= selected_data;
                    VGA_COLOR <= VGA_COLOR_;  // Assuming player data is directly accessible
                end

                DRAW_GHOST1: begin
                    // Draw ghost 1
                    if (dx < 4) begin
                        dx <= dx + 1;
                    end
                    else if (dy < 4) begin
                        dx <= 0;
                        dy <= dy + 1;
                    end
                    else begin
                        dx <= 0;
                        dy <= 0;
                        g1_game_x_ <= g1_game_x;
                        g1_game_y_ <= g1_game_y;
                    end
                    VGA_X_ <= g1_game_x * 5 + dx;
                    VGA_Y_ <= g1_game_y * 5 + dy;
                    VGA_X <= VGA_X_;
                    VGA_Y <= VGA_Y_;
                    VGA_COLOR_ <= selected_data;
                    VGA_COLOR <= VGA_COLOR_;  // Assuming ghost data is directly accessible
                end

                DRAW_GHOST2: begin
                    // Draw ghost 2
                    if (dx < 4) begin
                        dx <= dx + 1;
                    end
                    else if (dy < 4) begin
                        dx <= 0;
                        dy <= dy + 1;
                    end
                    else begin
                        dx <= 0;
                        dy <= 0;
                        g2_game_x_ <= g2_game_x;
                        g2_game_y_ <= g2_game_y;
                    end
                    VGA_X_ <= g2_game_x * 5 + dx;
                    VGA_Y_ <= g2_game_y * 5 + dy;
                    VGA_X <= VGA_X_;
                    VGA_Y <= VGA_Y_;
                    VGA_COLOR_ <= selected_data;
                    VGA_COLOR <= VGA_COLOR_;  // Assuming ghost data is directly accessible
                end

                DRAW_GHOST3: begin
                    // Draw ghost 3
                    if (dx < 4) begin
                        dx <= dx + 1;
                    end
                    else if (dy < 4) begin
                        dx <= 0;
                        dy <= dy + 1;
                    end
                    else begin
                        dx <= 0;
                        dy <= 0;
                        g3_game_x_ <= g3_game_x;
                        g3_game_y_ <= g3_game_y;
                    end
                    VGA_X_ <= g3_game_x * 5 + dx;
                    VGA_Y_ <= g3_game_y * 5 + dy;
                    VGA_X <= VGA_X_;
                    VGA_Y <= VGA_Y_;
                    VGA_COLOR_ <= selected_data;
                    VGA_COLOR <= VGA_COLOR_;  // Assuming ghost data is directly accessible
                end

                DONE: begin
                    // Done state
                    if (done_counter < 2) begin
                        done_counter <= done_counter + 1;
                        // VGA_X__ <= VGA_X___;
                        // VGA_Y__ <= VGA_Y___;
                        // VGA_COLOR__ <= VGA_COLOR___;
                        VGA_X_ <= VGA_X__;
                        VGA_Y_ <= VGA_Y__;
                        VGA_COLOR_ <= VGA_COLOR__;
                        VGA_X <= VGA_X_;
                        VGA_Y <= VGA_Y_;
                        VGA_COLOR <= VGA_COLOR_;
                    end
                    else begin
                        done_counter <= 0;
                        finished <= 1;
                    end
                end
            endcase
        end else begin
            finished <= 0;
        end
    end

    // select the player or ghost data
    m_player_ghost_data player_ghost_data (
        .x(dx),
        .y(dy),
        .is_ghost(is_ghost),
        .data(selected_data)
    );

endmodule


// helper module (mux) for selecting the player or ghost data
module m_player_ghost_data (
    input wire [3:0] x, y, // the x and y coordinate of the player or ghost
    input wire is_ghost, // Signal to indicate if selecting ghost or player data
    output reg [11:0] data // the data of the player or ghost
);

    // for convenience, we just define the player and ghost picture here
    // they are 5x5 blocks
    // player_data
    wire [11:0] player_data [4:0][4:0];
    // line 1
    assign player_data[0][0] = 12'h531;
    assign player_data[0][1] = 12'h531;
    assign player_data[0][2] = 12'hFF3;
    assign player_data[0][3] = 12'h531;
    assign player_data[0][4] = 12'h531;
    // line 2
    assign player_data[1][0] = 12'h531;
    assign player_data[1][1] = 12'hFF3;
    assign player_data[1][2] = 12'hFF3;
    assign player_data[1][3] = 12'hFF3;
    assign player_data[1][4] = 12'h531;
    // line 3
    assign player_data[2][0] = 12'hFF3;
    assign player_data[2][1] = 12'hFF3;
    assign player_data[2][2] = 12'hFF3;
    assign player_data[2][3] = 12'hFF3;
    assign player_data[2][4] = 12'hFF3;
    // line 4
    assign player_data[3][0] = 12'h531;
    assign player_data[3][1] = 12'hFF3;
    assign player_data[3][2] = 12'hFF3;
    assign player_data[3][3] = 12'hFF3;
    assign player_data[3][4] = 12'h531;
    // line 5
    assign player_data[4][0] = 12'h531;
    assign player_data[4][1] = 12'h531;
    assign player_data[4][2] = 12'hFF3;
    assign player_data[4][3] = 12'h531;
    assign player_data[4][4] = 12'h531;

    // ghost_data
    wire [11:0] ghost_data [4:0][4:0];
    //line 1
    assign ghost_data[0][0] = 12'h531;
    assign ghost_data[0][1] = 12'hFFF;
    assign ghost_data[0][2] = 12'hFFF;
    assign ghost_data[0][3] = 12'hFFF;
    assign ghost_data[0][4] = 12'h531;
    // line 2
    assign ghost_data[1][0] = 12'h531;
    assign ghost_data[1][1] = 12'hFFF;
    assign ghost_data[1][2] = 12'hFFF;
    assign ghost_data[1][3] = 12'hFFF;
    assign ghost_data[1][4] = 12'h531;
    // line 3
    assign ghost_data[2][0] = 12'hFFF;
    assign ghost_data[2][1] = 12'hFFF;
    assign ghost_data[2][2] = 12'hF88; // the red eye
    assign ghost_data[2][3] = 12'hFFF;
    assign ghost_data[2][4] = 12'hFFF;
    // line 4
    assign ghost_data[3][0] = 12'hFFF;
    assign ghost_data[3][1] = 12'hFFF;
    assign ghost_data[3][2] = 12'hFFF;
    assign ghost_data[3][3] = 12'hFFF;
    assign ghost_data[3][4] = 12'hFFF;
    // line 5
    assign ghost_data[4][0] = 12'hFFF;
    assign ghost_data[4][1] = 12'h531;
    assign ghost_data[4][2] = 12'hFFF;
    assign ghost_data[4][3] = 12'h531;
    assign ghost_data[4][4] = 12'hFFF;

    always @(*) begin
        if (is_ghost) begin
            data = ghost_data[y][x];
        end else begin
            data = player_data[y][x];
        end
    end
endmodule
