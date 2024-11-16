module game_state_control(clock, resetn, enable, key3);

    // basic inputs
    input clock, resetn, enable;
    // inputs for state transitions
    input key3;
    // State encoding
    parameter GREETING = 2'b00, PLAYING = 2'b01, GAME_OVER = 2'b10;
    // State register
    reg [1:0] next_game_state;
    // finish signals
    wire f_greeting, f_playing, f_game_over;

    // State transition logic
    always @ (posedge clock) begin
        if (!resetn)
            game_state <= GREETING;  // Reset to initial state
        else if (enable)
            game_state <= next_game_state;  // Move to the next state if enabled
    end

    // Next state logic
    always @ (*) begin
        case (game_state)
            GREETING: begin
                if (f_greeting)
                    next_game_state = PLAYING;  // Move to PLAYING when GREETING_FINISHED is high
                else
                    next_game_state = GREETING; // Stay in GREETING if not finished
            end
            PLAYING: begin
                if (f_playing)
                    next_game_state = GAME_OVER;  // Move to GAME_OVER when PLAYING_FINISHED is high
                else
                    next_game_state = PLAYING;   // Stay in PLAYING if not finished
            end
            GAME_OVER: begin
                if (f_game_over)
                    next_game_state = GREETING;  // Loop back to GREETING when GAME_OVER_FINISHED is high
                else
                    next_game_state = GAME_OVER; // Stay in GAME_OVER if not finished
            end
            default: next_game_state = GREETING; // Default state is GREETING
        endcase
    end

endmodule


module game_running(clock, resetn, enable, finished);

    // basic inputs
    input clock, resetn, enable;
    // finish signal
    input finished;
    // State encoding
    parameter CLEAR_SCREEN = 4'b0000;
    parameter UPDATE_POSITION = 4'b0001;
    parameter EAT_FOOD = 4'b0010;
    parameter UPDATE_GHOST_DIRECTIONS = 4'b0011;
    parameter UPDATE_GHOST_POSITIONS = 4'b0100;
    parameter FILL_SCREEN = 4'b0101;
    parameter RENDER_BLOCKS = 4'b0110;
    parameter RENDER_PLAYER = 4'b0111;
    parameter RENDER_FOOD = 4'b1000;
    parameter RENDER_GHOSTS = 4'b1001;
    parameter GHOST_COLLISION = 4'b1010;
    parameter GAME_OVER = 4'b1011;
    // State register
    reg [3:0] game_state;
    reg [3:0] next_game_state;
    //enable signals
    reg e_clear_screen;
    reg e_update_position;
    reg e_eat_food;
    reg e_update_ghost_directions;
    reg e_update_ghost_positions;
    reg e_fill_screen;
    reg e_render_blocks;
    reg e_render_player;
    reg e_render_food;
    reg e_render_ghosts;
    reg e_ghost_collision;
    // finish signals
    wire f_clear_screen;
    wire f_update_position;
    wire f_eat_food;
    wire f_update_ghost_directions;
    wire f_update_ghost_positions;
    wire f_fill_screen;
    wire f_render_blocks;
    wire f_render_player;
    wire f_render_food;
    wire f_render_ghosts;
    wire f_ghost_collision;

    initial begin
        game_state = CLEAR_SCREEN;
        f_clear_screen = 0;
        f_update_position = 0;
        f_eat_food = 0;
        f_update_ghost_directions = 0;
        f_update_ghost_positions = 0;
        f_fill_screen = 0;
        f_render_blocks = 0;
        f_render_player = 0;
        f_render_food = 0;
        f_render_ghosts = 0;
        f_ghost_collision = 0;
    end

    // State transition logic
    always @ (posedge clock) begin
        if (!resetn)
            game_state <= UPDATE_POSITION;  // Reset to initial state
        else if (enable)
            game_state <= next_game_state;  // Move to the next state if enabled
    end

    // Next state logic
    always @ (*) begin
        case (game_state)
            CLEAR_SCREEN: begin
                if (f_clear_screen)
                    next_game_state = UPDATE_POSITION;  // Move to UPDATE_POSITION when CLEAR_SCREEN is high
                else
                    next_game_state = CLEAR_SCREEN; // Stay in CLEAR_SCREEN if not finished
            end
            UPDATE_POSITION: begin
                if (f_update_position)
                    next_game_state = EAT_FOOD;  // Move to EAT_FOOD when UPDATE_POSITION is high
                else
                    next_game_state = UPDATE_POSITION; // Stay in UPDATE_POSITION if not finished
            end
            EAT_FOOD: begin
                if (f_eat_food)
                    next_game_state = UPDATE_GHOST_DIRECTIONS;  // Move to UPDATE_GHOST_DIRECTIONS when EAT_FOOD is high
                else
                    next_game_state = EAT_FOOD; // Stay in EAT_FOOD if not finished
            end
            UPDATE_GHOST_DIRECTIONS: begin
                if (f_update_ghost_directions)
                    next_game_state = UPDATE_GHOST_POSITIONS;  // Move to UPDATE_GHOST_POSITIONS when UPDATE_GHOST_DIRECTIONS is high
                else
                    next_game_state = UPDATE_GHOST_DIRECTIONS; // Stay in UPDATE_GHOST_DIRECTIONS if not finished
            end
            UPDATE_GHOST_POSITIONS: begin
                if (f_update_ghost_positions)
                    next_game_state = FILL_SCREEN;  // Move to FILL_SCREEN when UPDATE_GHOST_POSITIONS is high
                else
                    next_game_state = UPDATE_GHOST_POSITIONS; // Stay in UPDATE_GHOST_POSITIONS if not finished
            end
            FILL_SCREEN: begin
                if (f_fill_screen)
                    next_game_state = RENDER_BLOCKS;  // Move to RENDER_BLOCKS when FILL_SCREEN is high
                else
                    next_game_state = FILL_SCREEN; // Stay in FILL_SCREEN if not finished
            end
            RENDER_BLOCKS: begin
                if (f_render_blocks)
                    next_game_state = RENDER_PLAYER;  // Move to RENDER_PLAYER when RENDER_BLOCKS is high
                else
                    next_game_state = RENDER_BLOCKS; // Stay in RENDER_BLOCKS if not finished
            end
            RENDER_PLAYER: begin
                if (f_render_player)
                    next_game_state = RENDER_FOOD;  // Move to RENDER_FOOD when RENDER_PLAYER is high
                else
                    next_game_state = RENDER_PLAYER; // Stay in RENDER_PLAYER if not finished
            end
            RENDER_FOOD: begin
                if (f_render_food)
                    next_game_state = RENDER_GHOSTS;  // Move to RENDER_GHOSTS when RENDER_FOOD is high
                else
                    next_game_state = RENDER_FOOD; // Stay in RENDER_FOOD if not finished
            end
            RENDER_GHOSTS: begin
                if (f_render_ghosts)
                    next_game_state = GHOST_COLLISION;  // Move to GHOST_COLLISION when RENDER_GHOSTS is high
                else
                    next_game_state = RENDER_GHOSTS; // Stay in RENDER_GHOSTS if not finished
            end
            GHOST_COLLISION: begin
                if (f_ghost_collision)
                    next_game_state = GAME_OVER;  // Move to GAME_OVER when GHOST_COLLISION is high
                else
                    next_game_state = GHOST_COLLISION; // Stay in GHOST_COLLISION if not finished
            end
            GAME_OVER: begin
                next_game_state = GAME_OVER; // GAME_OVER is the final state, so stay in GAME_OVER until reset
            end
            default: next_game_state = CLEAR_SCREEN; // Default state is CLEAR_SCREEN
        endcase
    end

    // Output logic
    assign e_clear_screen = (game_state == CLEAR_SCREEN);
    assign e_update_position = (game_state == UPDATE_POSITION);
    assign e_eat_food = (game_state == EAT_FOOD);
    assign e_update_ghost_directions = (game_state == UPDATE_GHOST_DIRECTIONS);
    assign e_update_ghost_positions = (game_state == UPDATE_GHOST_POSITIONS);
    assign e_fill_screen = (game_state == FILL_SCREEN);
    assign e_render_blocks = (game_state == RENDER_BLOCKS);
    assign e_render_player = (game_state == RENDER_PLAYER);
    assign e_render_food = (game_state == RENDER_FOOD);
    assign e_render_ghosts = (game_state == RENDER_GHOSTS);
    assign e_ghost_collision = (game_state == GHOST_COLLISION);
    assign finished = (game_state == GAME_OVER);

endmodule

module m_clear_screen(clock, resetn, enable, finished);

    // basic inputs
    input clock, resetn, enable;
    // finish signal
    output reg finished;

    always @ (posedge clock) begin
        if (!resetn)
            finished <= 0;  // Reset to initial state
        else if (enable)
            finished <= 1;  // Finish immediately when enabled, for testing
    end

endmodule

module m_update_position(clock, resetn, enable, finished);

    // basic inputs
    input clock, resetn, enable;
    // finish signal
    output reg finished;

    always @ (posedge clock) begin
        if (!resetn)
            finished <= 0;  // Reset to initial state
        else if (enable)
            finished <= 1;  // Finish immediately when enabled, for testing
    end

endmodule

module m_eat_food(clock, resetn, enable, finished);

    // basic inputs
    input clock, resetn, enable;
    // finish signal
    output reg finished;

    always @ (posedge clock) begin
        if (!resetn)
            finished <= 0;  // Reset to initial state
        else if (enable)
            finished <= 1;  // Finish immediately when enabled, for testing
    end

endmodule

module m_update_ghost_directions(clock, resetn, enable, finished);

    // basic inputs
    input clock, resetn, enable;
    // finish signal
    output reg finished;

    always @ (posedge clock) begin
        if (!resetn)
            finished <= 0;  // Reset to initial state
        else if (enable)
            finished <= 1;  // Finish immediately when enabled, for testing
    end

endmodule

module m_update_ghost_positions(clock, resetn, enable, finished);

    // basic inputs
    input clock, resetn, enable;
    // finish signal
    output reg finished;

    always @ (posedge clock) begin
        if (!resetn)
            finished <= 0;  // Reset to initial state
        else if (enable)
            finished <= 1;  // Finish immediately when enabled, for testing
    end

endmodule

module m_fill_screen(clock, resetn, enable, finished);

    // basic inputs
    input clock, resetn, enable;
    // finish signal
    output reg finished;

    always @ (posedge clock) begin
        if (!resetn)
            finished <= 0;  // Reset to initial state
        else if (enable)
            finished <= 1;  // Finish immediately when enabled, for testing
    end

endmodule

module m_render_blocks(clock, resetn, enable, finished);

    // basic inputs
    input clock, resetn, enable;
    // finish signal
    output reg finished;

    always @ (posedge clock) begin
        if (!resetn)
            finished <= 0;  // Reset to initial state
        else if (enable)
            finished <= 1;  // Finish immediately when enabled, for testing
    end

endmodule

module m_render_player(clock, resetn, enable, finished);

    // basic inputs
    input clock, resetn, enable;
    // finish signal
    output reg finished;

    always @ (posedge clock) begin
        if (!resetn)
            finished <= 0;  // Reset to initial state
        else if (enable)
            finished <= 1;  // Finish immediately when enabled, for testing
    end

endmodule

module m_render_food(clock, resetn, enable, finished);

    // basic inputs
    input clock, resetn, enable;
    // finish signal
    output reg finished;

    always @ (posedge clock) begin
        if (!resetn)
            finished <= 0;  // Reset to initial state
        else if (enable)
            finished <= 1;  // Finish immediately when enabled, for testing
    end

endmodule

module m_render_ghosts(clock, resetn, enable, finished);

    // basic inputs
    input clock, resetn, enable;
    // finish signal
    output reg finished;

    always @ (posedge clock) begin
        if (!resetn)
            finished <= 0;  // Reset to initial state
        else if (enable)
            finished <= 1;  // Finish immediately when enabled, for testing
    end

endmodule

module m_ghost_collision(clock, resetn, enable, finished);

    // basic inputs
    input clock, resetn, enable;
    // finish signal
    output reg finished;

    always @ (posedge clock) begin
        if (!resetn)
            finished <= 0;  // Reset to initial state
        else if (enable)
            finished <= 1;  // Finish immediately when enabled, for testing
    end

endmodule