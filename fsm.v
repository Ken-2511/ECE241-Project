module fsm_game_state(clock, resetn, enable, key3);

    // basic inputs
    input clock, resetn, enable;
    // inputs for state transitions
    input key3;
    // State encoding
    parameter GREETING = 2'b00, PLAYING = 2'b01, GAME_OVER = 2'b10;
    // State register
    reg [1:0] next_game_state, game_state;
    // enable signals
    reg e_greeting, e_playing, e_game_over;
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

    // Output logic
    always @ (*) begin
        e_greeting = (game_state == GREETING);
        e_playing = (game_state == PLAYING);
        e_game_over = (game_state == GAME_OVER);
    end

    m_greeting m_greeting(clock, resetn, e_greeting, f_greeting);
    m_playing m_playing (clock, resetn, e_playing, f_playing);
    m_game_over m_game_over(clock, resetn, e_game_over, f_game_over);

endmodule


module m_playing(clock, resetn, enable, finished);

    // basic inputs
    input clock, resetn, enable;
    // finish signal
    output reg finished;
    // State encoding
    parameter IDLE = 4'b0000, CLEAR_SCREEN = 4'b0001, UPDATE_POSITION = 4'b0010, EAT_FOOD = 4'b0011;
    parameter UPDATE_GHOST_DIRECTIONS = 4'b0100, UPDATE_GHOST_POSITIONS = 4'b0101, FILL_SCREEN = 4'b0110;
    parameter RENDER_BLOCKS = 4'b0111, RENDER_PLAYER = 4'b1000, RENDER_FOOD = 4'b1001, RENDER_GHOSTS = 4'b1010;
    parameter GHOST_COLLISION = 4'b1011, UPDATE_VGA = 4'b1100, GAME_OVER = 4'b1101;
    // State register
    reg [3:0] game_state;
    reg [3:0] next_game_state;
    //enable signals
    reg e_clear_screen, e_update_position, e_eat_food, e_update_ghost_directions, e_update_ghost_positions;
    reg e_fill_screen, e_render_blocks, e_render_player, e_render_food, e_render_ghosts, e_ghost_collision, e_update_vga;
    // finish signals
    wire f_clear_screen, f_update_position, f_eat_food, f_update_ghost_directions, f_update_ghost_positions;
    wire f_fill_screen, f_render_blocks, f_render_player, f_render_food, f_render_ghosts, f_ghost_collision, f_update_vga;

    // State transition logic
    always @ (posedge clock) begin
        if (!resetn)
            game_state <= IDLE;  // Reset to initial state
        else if (enable)
            game_state <= next_game_state;  // Move to the next state if enabled
    end

    // Next state logic
    always @ (*) begin
        case (game_state)
            IDLE: begin
                next_game_state = CLEAR_SCREEN; // Move to CLEAR_SCREEN immediately
            end
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
                    next_game_state = UPDATE_VGA;  // Move to UPDATE_VGA when GHOST_COLLISION is high
                else
                    next_game_state = GHOST_COLLISION; // Stay in GHOST_COLLISION if not finished
            end
            UPDATE_VGA: begin
                if (f_update_vga)
                    next_game_state = GAME_OVER;  // Move to GAME_OVER when UPDATE_VGA is high
                else
                    next_game_state = UPDATE_VGA; // Stay in UPDATE_VGA if not finished
            end
            GAME_OVER: begin
                next_game_state = IDLE; // Move back to IDLE immediately
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
    end

    // Modules
    m_clear_screen              m_clear_screen              (clock, resetn, e_clear_screen, f_clear_screen);
    m_update_position           m_update_position           (clock, resetn, e_update_position, f_update_position);
    m_eat_food                  m_eat_food                  (clock, resetn, e_eat_food, f_eat_food);
    m_update_ghost_directions   m_update_ghost_directions   (clock, resetn, e_update_ghost_directions, f_update_ghost_directions);
    m_update_ghost_positions    m_update_ghost_positions    (clock, resetn, e_update_ghost_positions, f_update_ghost_positions);
    m_fill_screen               m_fill_screen               (clock, resetn, e_fill_screen, f_fill_screen);
    m_render_blocks             m_render_blocks             (clock, resetn, e_render_blocks, f_render_blocks);
    m_render_player             m_render_player             (clock, resetn, e_render_player, f_render_player);
    m_render_food               m_render_food               (clock, resetn, e_render_food, f_render_food);
    m_render_ghosts             m_render_ghosts             (clock, resetn, e_render_ghosts, f_render_ghosts);
    m_ghost_collision           m_ghost_collision           (clock, resetn, e_ghost_collision, f_ghost_collision);
    m_update_vga                m_update_vga                (clock, resetn, e_update_vga, f_update_vga);

endmodule


module m_greeting(clock, resetn, enable, finished);

    // basic inputs
    input clock, resetn, enable;
    // finish signal
    output reg finished;

    always @ (posedge clock) begin
        if (!resetn)
            finished <= 0;  // Reset to initial state
        else if (enable)
            finished <= 1;  // Finish immediately when enabled, for testing
        else if (finished)
            finished <= 0;  // Reset to initial state when finished
    end

endmodule


module m_game_over(clock, resetn, enable, finished);

    // basic inputs
    input clock, resetn, enable;
    // finish signal
    output reg finished;

    always @ (posedge clock) begin
        if (!resetn)
            finished <= 0;  // Reset to initial state
        else if (enable)
            finished <= 0;  // Never finish, for testing
        else if (finished)
            finished <= 0;  // Reset to initial state when finished
    end

endmodule

// This file contains the modules for the game logic and rendering of the game.

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
        else if (finished)
            finished <= 0;  // Reset to initial state when finished
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
        else if (finished)
            finished <= 0;  // Reset to initial state when finished
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
        else if (finished)
            finished <= 0;  // Reset to initial state when finished
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
        else if (finished)
            finished <= 0;  // Reset to initial state when finished
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
        else if (finished)
            finished <= 0;  // Reset to initial state when finished
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
        else if (finished)
            finished <= 0;  // Reset to initial state when finished
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
        else if (finished)
            finished <= 0;  // Reset to initial state when finished
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
        else if (finished)
            finished <= 0;  // Reset to initial state when finished
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
        else if (finished)
            finished <= 0;  // Reset to initial state when finished
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
        else if (finished)
            finished <= 0;  // Reset to initial state when finished
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
        else if (finished)
            finished <= 0;  // Reset to initial state when finished
    end

endmodule


module m_update_vga(clock, resetn, enable, finished);

    // basic inputs
    input clock, resetn, enable;
    // finish signal
    output reg finished;

    always @ (posedge clock) begin
        if (!resetn)
            finished <= 0;  // Reset to initial state
        else if (enable)
            finished <= 1;  // Finish immediately when enabled, for testing
        else if (finished)
            finished <= 0;  // Reset to initial state when finished
    end

endmodule


module arbiter(clock, resetn, enable, requests, grant);

    // basic inputs
    input clock, resetn, enable;
    // inputs for arbitration
    input [3:0] requests;
    // output of the arbiter
    output reg [3:0] grant;

    // State encoding
    parameter IDLE = 4'b0000, CLEAR_SCREEN = 4'b0001, UPDATE_POSITION = 4'b0010, EAT_FOOD = 4'b0011;
    parameter UPDATE_GHOST_DIRECTIONS = 4'b0100, UPDATE_GHOST_POSITIONS = 4'b0101, FILL_SCREEN = 4'b0110;
    parameter RENDER_BLOCKS = 4'b0111, RENDER_PLAYER = 4'b1000, RENDER_FOOD = 4'b1001, RENDER_GHOSTS = 4'b1010;
    parameter GHOST_COLLISION = 4'b1011, GAME_OVER = 4'b1100;
    // State register
    reg [3:0] next_grant;

    // State transition logic
    always @ (posedge clock) begin
        if (!resetn)
            grant <= IDLE;  // Reset to initial state
        else if (enable)
            grant <= next_grant;  // Move to the next state if enabled
    end

    // Next state logic
    always @ (*) begin
        case (grant)
            IDLE: begin
                if (requests[0])
                    next_grant = CLEAR_SCREEN;  // Grant CLEAR_SCREEN if requested
                else if (requests[1])
                    next_grant = UPDATE_POSITION;  // Grant UPDATE_POSITION if requested
                else if (requests[2])
                    next_grant = EAT_FOOD;  // Grant EAT_FOOD if requested
                else if (requests[3])
                    next_grant = UPDATE_GHOST_DIRECTIONS;  // Grant UPDATE_GHOST_DIRECTIONS if requested
                else
                    next_grant = IDLE; // Stay in IDLE if no requests
            end
            CLEAR_SCREEN: begin
                next_grant = IDLE; // CLEAR_SCREEN is a one-time grant, so move back to IDLE
            end
            UPDATE_POSITION: begin
                next_grant = IDLE; // UPDATE_POSITION is a one-time grant, so move back to IDLE
            end
            EAT_FOOD: begin
                next_grant = IDLE; // EAT_FOOD is a one-time grant, so move back to IDLE
            end
            UPDATE_GHOST_DIRECTIONS: begin
                next_grant = IDLE; // UPDATE_GHOST_DIRECTIONS is a one-time grant, so move back to IDLE
            end
            UPDATE_GHOST_POSITIONS: begin
                next_grant = IDLE; // UPDATE_GHOST_POSITIONS is a one-time grant, so move back to IDLE
            end
            FILL_SCREEN: begin
                next_grant = IDLE; // FILL_SCREEN is a one-time grant, so move back to IDLE
            end
            RENDER_BLOCKS: begin
                next_grant = IDLE; // RENDER_BLOCKS is a one-time grant, so move back to IDLE
            end
            RENDER_PLAYER: begin
                next_grant = IDLE; // RENDER_PLAYER is a one-time grant, so move back to IDLE
            end
            RENDER_FOOD: begin
                next_grant = IDLE; // RENDER_FOOD is a one-time grant, so move back to IDLE
            end
            RENDER_GHOSTS: begin
                next_grant = IDLE; // RENDER_GHOSTS is a one-time grant, so move back to IDLE
            end
            GHOST_COLLISION: begin
                next_grant = IDLE; // GHOST_COLLISION is a one-time grant, so move back to IDLE
            end
            GAME_OVER: begin
                next_grant = IDLE; // GAME_OVER is a one-time grant, so move back to IDLE
            end
            default: next_grant = IDLE; // Default state is IDLE
        endcase
    end

endmodule