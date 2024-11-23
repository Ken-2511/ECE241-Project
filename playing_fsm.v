module m_playing(
    clock,
    resetn,
    enable,
    finished,
    data,
    addr,
    wren,
    q,
    VGA_X,
    VGA_Y,
    VGA_COLOR,
    last_key_received
);

    parameter cbit = 11;

    // Basic inputs
    input clock, resetn, enable;

    // Outputs
    output reg finished;
    output reg [cbit:0] data;
    output reg [14:0] addr;
    output reg wren;
    input [cbit:0] q;

    // Additional outputs for VGA
    output reg [7:0] VGA_X;
    output reg [6:0] VGA_Y;
    output reg [cbit:0] VGA_COLOR;

    // State encoding
    parameter IDLE = 4'b0000, CLEAR_SCREEN = 4'b0001, UPDATE_POSITION = 4'b0010, EAT_FOOD = 4'b0011;
    parameter UPDATE_GHOST_DIRECTIONS = 4'b0100, UPDATE_GHOST_POSITIONS = 4'b0101, FILL_SCREEN = 4'b0110;
    parameter RENDER_BLOCKS = 4'b0111, RENDER_PLAYER = 4'b1000, RENDER_FOOD = 4'b1001, RENDER_GHOSTS = 4'b1010;
    parameter GHOST_COLLISION = 4'b1011, UPDATE_VGA = 4'b1100, GAME_OVER = 4'b1101;

    // State registers
    reg [3:0] game_state;
    reg [3:0] next_game_state;

    // Enable signals
    reg e_clear_screen, e_update_position, e_eat_food, e_update_ghost_directions, e_update_ghost_positions;
    reg e_fill_screen, e_render_blocks, e_render_player, e_render_food, e_render_ghosts, e_ghost_collision, e_update_vga;

    // Finished signals
    wire f_clear_screen, f_update_position, f_eat_food, f_update_ghost_directions, f_update_ghost_positions;
    wire f_fill_screen, f_render_blocks, f_render_player, f_render_food, f_render_ghosts, f_ghost_collision, f_update_vga;

    // Data control lines from submodules
    wire [cbit:0] dt_clear_screen, dt_update_position, dt_eat_food, dt_update_ghost_directions, dt_update_ghost_positions;
    wire [cbit:0] dt_fill_screen, dt_render_blocks, dt_render_player, dt_render_food, dt_render_ghosts, dt_ghost_collision, dt_update_vga;
    wire [14:0] ad_clear_screen, ad_update_position, ad_eat_food, ad_update_ghost_directions, ad_update_ghost_positions;
    wire [14:0] ad_fill_screen, ad_render_blocks, ad_render_player, ad_render_food, ad_render_ghosts, ad_ghost_collision, ad_update_vga;
    wire wr_clear_screen, wr_update_position, wr_eat_food, wr_update_ghost_directions, wr_update_ghost_positions;
    wire wr_fill_screen, wr_render_blocks, wr_render_player, wr_render_food, wr_render_ghosts, wr_ghost_collision, wr_update_vga;

    // VGA control lines from submodules
    wire [7:0] vga_x_clear_screen, vga_x_update_position, vga_x_eat_food, vga_x_update_ghost_directions, vga_x_update_ghost_positions;
    wire [7:0] vga_x_fill_screen, vga_x_render_blocks, vga_x_render_player, vga_x_render_food, vga_x_render_ghosts, vga_x_ghost_collision, vga_x_update_vga;
    wire [6:0] vga_y_clear_screen, vga_y_update_position, vga_y_eat_food, vga_y_update_ghost_directions, vga_y_update_ghost_positions;
    wire [6:0] vga_y_fill_screen, vga_y_render_blocks, vga_y_render_player, vga_y_render_food, vga_y_render_ghosts, vga_y_ghost_collision, vga_y_update_vga;
    wire [cbit:0] vga_color_clear_screen, vga_color_update_position, vga_color_eat_food, vga_color_update_ghost_directions, vga_color_update_ghost_positions;
    wire [cbit:0] vga_color_fill_screen, vga_color_render_blocks, vga_color_render_player, vga_color_render_food, vga_color_render_ghosts, vga_color_ghost_collision, vga_color_update_vga;

    //Player
    wire [4:0] player_x; //may need to put the x and y back if error 
    wire [3:0] player_y;
    wire [3:0] w; //internal carry to deal with the movement FSM
    wire [2:0] direction;
    parameter up = 3'b001, left = 3'b010, down = 3'b011, right = 3'b100;
    get_direction find_direction(last_key_received, hs_enable, w);
    movement_FSM track_movement(clock, resetn, hs_enable, w, direction);

    // Ghost coordinates
    wire [4:0] ghost1_x, ghost2_x, ghost3_x;
    wire [3:0] ghost1_y, ghost2_y, ghost3_y;

    // Game over and win flags
    wire game_over, you_won; //score must be 188 to win
    wire [8:0] score;

    // PS2 controller input
    input [7:0] last_key_received;

    // The blocks onchip memory
    wire [8:0] blk_addr;
    wire blk_data;
    wire blk_wren;
    wire blk_q;
    blocks BLOCKS (
        .address(blk_addr),
        .clock(clock),
        .data(blk_data),
        .wren(blk_wren),
        .q(blk_q)
    );

    // State transition logic
    always @ (posedge clock) begin
        if (!resetn)
            game_state <= IDLE;  // Reset to initial state
        else if (enable)
            game_state <= next_game_state;  // If enabled, transition to the next state
    end

    // Next state logic
    always @ (*) begin
        case (game_state)
            IDLE: begin
                next_game_state = CLEAR_SCREEN; // Immediately transition to CLEAR_SCREEN
            end
            CLEAR_SCREEN: begin
                if (f_clear_screen)
                    next_game_state = UPDATE_POSITION;  // When CLEAR_SCREEN is finished, transition to UPDATE_POSITION
                else
                    next_game_state = CLEAR_SCREEN; // Otherwise, stay in CLEAR_SCREEN
            end
            UPDATE_POSITION: begin
                if (f_update_position)
                    next_game_state = EAT_FOOD;  // When UPDATE_POSITION is finished, transition to EAT_FOOD
                else
                    next_game_state = UPDATE_POSITION; // Otherwise, stay in UPDATE_POSITION
            end
            EAT_FOOD: begin
                if (f_eat_food)
                    next_game_state = UPDATE_GHOST_DIRECTIONS;  // When EAT_FOOD is finished, transition to UPDATE_GHOST_DIRECTIONS
                else
                    next_game_state = EAT_FOOD; // Otherwise, stay in EAT_FOOD
            end
            UPDATE_GHOST_DIRECTIONS: begin
                if (f_update_ghost_directions)
                    next_game_state = UPDATE_GHOST_POSITIONS;  // When UPDATE_GHOST_DIRECTIONS is finished, transition to UPDATE_GHOST_POSITIONS
                else
                    next_game_state = UPDATE_GHOST_DIRECTIONS; // Otherwise, stay in UPDATE_GHOST_DIRECTIONS
            end
            UPDATE_GHOST_POSITIONS: begin
                if (f_update_ghost_positions)
                    next_game_state = FILL_SCREEN;  // When UPDATE_GHOST_POSITIONS is finished, transition to FILL_SCREEN
                else
                    next_game_state = UPDATE_GHOST_POSITIONS; // Otherwise, stay in UPDATE_GHOST_POSITIONS
            end
            FILL_SCREEN: begin
                if (f_fill_screen)
                    next_game_state = RENDER_BLOCKS;  // When FILL_SCREEN is finished, transition to RENDER_BLOCKS
                else
                    next_game_state = FILL_SCREEN; // Otherwise, stay in FILL_SCREEN
            end
            RENDER_BLOCKS: begin
                if (f_render_blocks)
                    next_game_state = RENDER_PLAYER;  // When RENDER_BLOCKS is finished, transition to RENDER_PLAYER
                else
                    next_game_state = RENDER_BLOCKS; // Otherwise, stay in RENDER_BLOCKS
            end
            RENDER_PLAYER: begin
                if (f_render_player)
                    next_game_state = RENDER_FOOD;  // When RENDER_PLAYER is finished, transition to RENDER_FOOD
                else
                    next_game_state = RENDER_PLAYER; // Otherwise, stay in RENDER_PLAYER
            end
            RENDER_FOOD: begin
                if (f_render_food)
                    next_game_state = RENDER_GHOSTS;  // When RENDER_FOOD is finished, transition to RENDER_GHOSTS
                else
                    next_game_state = RENDER_FOOD; // Otherwise, stay in RENDER_FOOD
            end
            RENDER_GHOSTS: begin
                if (f_render_ghosts)
                    next_game_state = GHOST_COLLISION;  // When RENDER_GHOSTS is finished, transition to GHOST_COLLISION
                else
                    next_game_state = RENDER_GHOSTS; // Otherwise, stay in RENDER_GHOSTS
            end
            GHOST_COLLISION: begin
                if (f_ghost_collision)
                    next_game_state = UPDATE_VGA;  // When GHOST_COLLISION is finished, transition to UPDATE_VGA
                else
                    next_game_state = GHOST_COLLISION; // Otherwise, stay in GHOST_COLLISION
            end
            UPDATE_VGA: begin
                if (f_update_vga)
                    next_game_state = GAME_OVER;  // When UPDATE_VGA is finished, transition to GAME_OVER
                else
                    next_game_state = UPDATE_VGA; // Otherwise, stay in UPDATE_VGA
            end
            GAME_OVER: begin
                next_game_state = IDLE; // Immediately transition back to IDLE
            end
            default: next_game_state = CLEAR_SCREEN; // Default state is CLEAR_SCREEN
        endcase
    end

    // Output logic
    always @ (*) begin
        e_clear_screen = (game_state == CLEAR_SCREEN);
        e_update_position = (game_state == UPDATE_POSITION);
        e_eat_food = (game_state == EAT_FOOD);
        e_update_ghost_directions = (game_state == UPDATE_GHOST_DIRECTIONS);
        e_update_ghost_positions = (game_state == UPDATE_GHOST_POSITIONS);
        e_fill_screen = (game_state == FILL_SCREEN);
        e_render_blocks = (game_state == RENDER_BLOCKS);
        e_render_player = (game_state == RENDER_PLAYER);
        e_render_food = (game_state == RENDER_FOOD);
        e_render_ghosts = (game_state == RENDER_GHOSTS);
        e_ghost_collision = (game_state == GHOST_COLLISION);
        e_update_vga = (game_state == UPDATE_VGA);
        finished = (game_state == GAME_OVER);  // Set finished flag when in GAME_OVER state

        case (game_state)
            CLEAR_SCREEN: begin
                data = dt_clear_screen;
                addr = ad_clear_screen;
                wren = wr_clear_screen;
                VGA_X = vga_x_clear_screen;
                VGA_Y = vga_y_clear_screen;
                VGA_COLOR = vga_color_clear_screen;
            end
            UPDATE_POSITION: begin
                data = dt_update_position;
                addr = ad_update_position;
                wren = wr_update_position;
                VGA_X = vga_x_update_position;
                VGA_Y = vga_y_update_position;
                VGA_COLOR = vga_color_update_position;
            end
            EAT_FOOD: begin
                data = dt_eat_food;
                addr = ad_eat_food;
                wren = wr_eat_food;
                VGA_X = vga_x_eat_food;
                VGA_Y = vga_y_eat_food;
                VGA_COLOR = vga_color_eat_food;
            end
            UPDATE_GHOST_DIRECTIONS: begin
                data = dt_update_ghost_directions;
                addr = ad_update_ghost_directions;
                wren = wr_update_ghost_directions;
                VGA_X = vga_x_update_ghost_directions;
                VGA_Y = vga_y_update_ghost_directions;
                VGA_COLOR = vga_color_update_ghost_directions;
            end
            UPDATE_GHOST_POSITIONS: begin
                data = dt_update_ghost_positions;
                addr = ad_update_ghost_positions;
                wren = wr_update_ghost_positions;
                VGA_X = vga_x_update_ghost_positions;
                VGA_Y = vga_y_update_ghost_positions;
                VGA_COLOR = vga_color_update_ghost_positions;
            end
            FILL_SCREEN: begin
                data = dt_fill_screen;
                addr = ad_fill_screen;
                wren = wr_fill_screen;
                VGA_X = vga_x_fill_screen;
                VGA_Y = vga_y_fill_screen;
                VGA_COLOR = vga_color_fill_screen;
            end
            RENDER_BLOCKS: begin
                data = dt_render_blocks;
                addr = ad_render_blocks;
                wren = wr_render_blocks;
                VGA_X = vga_x_render_blocks;
                VGA_Y = vga_y_render_blocks;
                VGA_COLOR = vga_color_render_blocks;
            end
            RENDER_PLAYER: begin
                data = dt_render_player;
                addr = ad_render_player;
                wren = wr_render_player;
                VGA_X = vga_x_render_player;
                VGA_Y = vga_y_render_player;
                VGA_COLOR = vga_color_render_player;
            end
            RENDER_FOOD: begin
                data = dt_render_food;
                addr = ad_render_food;
                wren = wr_render_food;
                VGA_X = vga_x_render_food;
                VGA_Y = vga_y_render_food;
                VGA_COLOR = vga_color_render_food;
            end
            RENDER_GHOSTS: begin
                data = dt_render_ghosts;
                addr = ad_render_ghosts;
                wren = wr_render_ghosts;
                VGA_X = vga_x_render_ghosts;
                VGA_Y = vga_y_render_ghosts;
                VGA_COLOR = vga_color_render_ghosts;
            end
            GHOST_COLLISION: begin
                data = dt_ghost_collision;
                addr = ad_ghost_collision;
                wren = wr_ghost_collision;
                VGA_X = vga_x_ghost_collision;
                VGA_Y = vga_y_ghost_collision;
                VGA_COLOR = vga_color_ghost_collision;
            end
            UPDATE_VGA: begin
                data = dt_update_vga;
                addr = ad_update_vga;
                wren = wr_update_vga;
                VGA_X = vga_x_update_vga;
                VGA_Y = vga_y_update_vga;
                VGA_COLOR = vga_color_update_vga;
            end
            default: begin
                data = 3'b000;
                addr = 15'b0;
                wren = 1'b0;
                VGA_X = 8'b0;
                VGA_Y = 7'b0;
                VGA_COLOR = 3'b0;
            end
        endcase
    end

    // Instantiate submodules and connect VGA signals
    m_clear_screen m_clear_screen_inst(
        .clock(clock),
        .resetn(resetn),
        .enable(e_clear_screen),
        .wren(wr_clear_screen),
        .finished(f_clear_screen),
        .data(dt_clear_screen),
        .addr(ad_clear_screen),
        .last_key_received(last_key_received)
    );

    m_update_position m_update_position_inst(
        .clock(clock),
        .resetn(resetn),
        .enable(e_update_position),
        .wren(wr_update_position),
        .finished(f_update_position),
        .data(dt_update_position),
        .addr(ad_update_position),
        .direction(direction),
        .player_x(player_x),
        .player_y(player_y),
        .hs_enable(hs_enable)
    );

    m_eat_food m_eat_food_inst(
        .clock(clock),
        .resetn(resetn),
        .enable(e_eat_food),
        .wren(wr_eat_food),
        .finished(f_eat_food),
        .data(dt_eat_food),
        .addr(ad_eat_food)
    );

    m_update_ghost_directions m_update_ghost_directions_inst(
        .clock(clock),
        .resetn(resetn),
        .enable(e_update_ghost_directions),
        .wren(wr_update_ghost_directions),
        .finished(f_update_ghost_directions),
        .data(dt_update_ghost_directions),
        .addr(ad_update_ghost_directions),
        .ghost1_x(ghost1_x),
        .ghost1_y(ghost1_y),
        .ghost2_x(ghost2_x),
        .ghost2_y(ghost2_y),
        .ghost3_x(ghost3_x),
        .ghost3_y(ghost3_y)
    );

    m_update_ghost_positions m_update_ghost_positions_inst(
        .clock(clock),
        .resetn(resetn),
        .enable(e_update_ghost_positions),
        .wren(wr_update_ghost_positions),
        .finished(f_update_ghost_positions),
        .data(dt_update_ghost_positions),
        .addr(ad_update_ghost_positions)
    );

    m_fill_screen m_fill_screen_inst(
        .clock(clock),
        .resetn(resetn),
        .enable(e_fill_screen),
        .wren(wr_fill_screen),
        .finished(f_fill_screen),
        .data(dt_fill_screen),
        .addr(ad_fill_screen)
    );

    m_render_blocks m_render_blocks_inst(
        .clock(clock),
        .resetn(resetn),
        .enable(e_render_blocks),
        .wren(wr_render_blocks),
        .finished(f_render_blocks),
        .data(dt_render_blocks),
        .addr(ad_render_blocks),
        .blk_addr(blk_addr),
        .blk_q(blk_q),
        .blk_wren(blk_wren)
    );

    // m_render_player(clock, resetn, enable, wren, finished, data, addr, VGA_X, VGA_Y, VGA_COLOR, game_x, game_y, direct);
    m_render_player m_render_player_inst(
        .clock(clock),
        .resetn(resetn),
        .enable(e_render_player),
        .wren(wr_render_player),
        .finished(f_render_player),
        .data(dt_render_player),
        .addr(ad_render_player),
        .VGA_X(vga_x_render_player),
        .VGA_Y(vga_y_render_player),
        .VGA_COLOR(vga_color_render_player),
        .game_x(player_x),
        .game_y(player_y),
        .direct(2'b0)
    );

// module m_render_food(clock, resetn, enable, wren, finished, data, addr, VGA_X, VGA_Y, VGA_COLOR);
    m_render_food m_render_food_inst(
        .clock(clock),
        .resetn(resetn),
        .enable(e_render_food),
        .wren(wr_render_food),
        .finished(f_render_food),
        .data(dt_render_food),
        .addr(ad_render_food),
        .VGA_X(vga_x_render_food),
        .VGA_Y(vga_y_render_food),
        .VGA_COLOR(vga_color_render_food)
    );
    // module m_render_ghosts(clock, resetn, enable, wren, finished, data, addr, VGA_X, VGA_Y, VGA_COLOR, ghost_x, ghost_y, direct);
    // // Ghost position and direction
    // input [5:0] ghost_x [0:num_ghosts-1];
    // input [4:0] ghost_y [0:num_ghosts-1];
    // input [1:0] direct [0:num_ghosts-1];

    m_render_ghosts m_render_ghosts_inst(
        .clock(clock),
        .resetn(resetn),
        .enable(e_render_ghosts),
        .wren(wr_render_ghosts),
        .finished(f_render_ghosts),
        .data(dt_render_ghosts),
        .addr(ad_render_ghosts),
        .VGA_X(vga_x_render_ghosts),
        .VGA_Y(vga_y_render_ghosts),
        .VGA_COLOR(vga_color_render_ghosts),
        .ghost1_x(ghost1_x),
        .ghost1_y(ghost1_y),
        .ghost2_x(ghost2_x),
        .ghost2_y(ghost2_y),
        .ghost3_x(ghost3_x),
        .ghost3_y(ghost3_y),
        .direct(2'b0),
        .last_key_received(last_key_received)
    );
    defparam m_render_ghosts_inst.num_ghosts = 1;

    m_ghost_collision m_ghost_collision_inst(
        .clock(clock),
        .resetn(resetn),
        .enable(e_ghost_collision),
        .wren(wr_ghost_collision),
        .finished(f_ghost_collision),
        .data(dt_ghost_collision),
        .addr(ad_ghost_collision),
        .player_x(player_x),
        .player_y(player_y),
        .ghost1_x(ghost1_x),
        .ghost1_y(ghost1_y),
        .ghost2_x(ghost2_x),
        .ghost2_y(ghost2_y),
        .ghost3_x(ghost3_x),
        .ghost3_y(ghost3_y),
        .collided(game_over)
    );

    m_update_vga m_update_vga_inst(
        .clock(clock),
        .resetn(resetn),
        .enable(e_update_vga),
        .wren(wr_update_vga),
        .finished(f_update_vga),
        .data(dt_update_vga),
        .addr(ad_update_vga),
        .q(q),
        .VGA_X(vga_x_update_vga),      // Additional output
        .VGA_Y(vga_y_update_vga),      // Additional output
        .VGA_COLOR(vga_color_update_vga) // Additional output
    );

endmodule