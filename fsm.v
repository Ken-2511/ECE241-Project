module fsm_game_state(clock, resetn, enable, key3, data, addr, wren);

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

    // Data control
    output reg [2:0] data;
    output reg [16:0] addr;
    output reg wren;

    wire [2:0] dt_greeting, dt_playing, dt_game_over;
    wire [16:0] ad_greeting, ad_playing, ad_game_over;
    wire wr_greeting, wr_playing, wr_game_over;

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
        case (game_state)
            GREETING: begin
                data = 3'b000;
                addr = 17'b0;
                wren = 1'b0;
            end
            PLAYING: begin
                data = 3'b001;
                addr = 17'b1;
                wren = 1'b1;
            end
            GAME_OVER: begin
                data = 3'b010;
                addr = 17'b10;
                wren = 1'b0;
            end
        endcase
    end

    m_greeting m_greeting(clock, resetn, e_greeting, f_greeting, dt_greeting, ad_greeting, wr_greeting);
    m_playing m_playing (clock, resetn, e_playing, f_playing, dt_playing, ad_playing, wr_playing);
    m_game_over m_game_over(clock, resetn, e_game_over, f_game_over, dt_game_over, ad_game_over, wr_game_over);

endmodule


module m_playing(clock, resetn, enable, finished, data, addr, wren);

    // Basic inputs
    input clock, resetn, enable;
    // input wren; // Added wren input

    // Finish signal
    output reg finished;

    // State encoding
    parameter IDLE = 4'b0000, CLEAR_SCREEN = 4'b0001, UPDATE_POSITION = 4'b0010, EAT_FOOD = 4'b0011;
    parameter UPDATE_GHOST_DIRECTIONS = 4'b0100, UPDATE_GHOST_POSITIONS = 4'b0101, FILL_SCREEN = 4'b0110;
    parameter RENDER_BLOCKS = 4'b0111, RENDER_PLAYER = 4'b1000, RENDER_FOOD = 4'b1001, RENDER_GHOSTS = 4'b1010;
    parameter GHOST_COLLISION = 4'b1011, UPDATE_VGA = 4'b1100, GAME_OVER = 4'b1101;

    // State register
    reg [3:0] game_state;
    reg [3:0] next_game_state;

    // Enable signals
    reg e_clear_screen, e_update_position, e_eat_food, e_update_ghost_directions, e_update_ghost_positions;
    reg e_fill_screen, e_render_blocks, e_render_player, e_render_food, e_render_ghosts, e_ghost_collision, e_update_vga;

    // Finish signals
    wire f_clear_screen, f_update_position, f_eat_food, f_update_ghost_directions, f_update_ghost_positions;
    wire f_fill_screen, f_render_blocks, f_render_player, f_render_food, f_render_ghosts, f_ghost_collision, f_update_vga;

    // Data control (always write, never read)
    output reg [2:0] data;
    output reg [16:0] addr;
    output reg wren;

    wire [2:0] dt_clear_screen, dt_update_position, dt_eat_food, dt_update_ghost_directions, dt_update_ghost_positions;
    wire [2:0] dt_fill_screen, dt_render_blocks, dt_render_player, dt_render_food, dt_render_ghosts, dt_ghost_collision, dt_update_vga;
    wire [16:0] ad_clear_screen, ad_update_position, ad_eat_food, ad_update_ghost_directions, ad_update_ghost_positions;
    wire [16:0] ad_fill_screen, ad_render_blocks, ad_render_player, ad_render_food, ad_render_ghosts, ad_ghost_collision, ad_update_vga;
    wire wr_clear_screen, wr_update_position, wr_eat_food, wr_update_ghost_directions, wr_update_ghost_positions;
    wire wr_fill_screen, wr_render_blocks, wr_render_player, wr_render_food, wr_render_ghosts, wr_ghost_collision, wr_update_vga;

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
                    next_game_state = UPDATE_POSITION;  // Move to UPDATE_POSITION when CLEAR_SCREEN is finished
                else
                    next_game_state = CLEAR_SCREEN; // Stay in CLEAR_SCREEN if not finished
            end
            UPDATE_POSITION: begin
                if (f_update_position)
                    next_game_state = EAT_FOOD;  // Move to EAT_FOOD when UPDATE_POSITION is finished
                else
                    next_game_state = UPDATE_POSITION; // Stay in UPDATE_POSITION if not finished
            end
            EAT_FOOD: begin
                if (f_eat_food)
                    next_game_state = UPDATE_GHOST_DIRECTIONS;  // Move to UPDATE_GHOST_DIRECTIONS when EAT_FOOD is finished
                else
                    next_game_state = EAT_FOOD; // Stay in EAT_FOOD if not finished
            end
            UPDATE_GHOST_DIRECTIONS: begin
                if (f_update_ghost_directions)
                    next_game_state = UPDATE_GHOST_POSITIONS;  // Move to UPDATE_GHOST_POSITIONS when UPDATE_GHOST_DIRECTIONS is finished
                else
                    next_game_state = UPDATE_GHOST_DIRECTIONS; // Stay in UPDATE_GHOST_DIRECTIONS if not finished
            end
            UPDATE_GHOST_POSITIONS: begin
                if (f_update_ghost_positions)
                    next_game_state = FILL_SCREEN;  // Move to FILL_SCREEN when UPDATE_GHOST_POSITIONS is finished
                else
                    next_game_state = UPDATE_GHOST_POSITIONS; // Stay in UPDATE_GHOST_POSITIONS if not finished
            end
            FILL_SCREEN: begin
                if (f_fill_screen)
                    next_game_state = RENDER_BLOCKS;  // Move to RENDER_BLOCKS when FILL_SCREEN is finished
                else
                    next_game_state = FILL_SCREEN; // Stay in FILL_SCREEN if not finished
            end
            RENDER_BLOCKS: begin
                if (f_render_blocks)
                    next_game_state = RENDER_PLAYER;  // Move to RENDER_PLAYER when RENDER_BLOCKS is finished
                else
                    next_game_state = RENDER_BLOCKS; // Stay in RENDER_BLOCKS if not finished
            end
            RENDER_PLAYER: begin
                if (f_render_player)
                    next_game_state = RENDER_FOOD;  // Move to RENDER_FOOD when RENDER_PLAYER is finished
                else
                    next_game_state = RENDER_PLAYER; // Stay in RENDER_PLAYER if not finished
            end
            RENDER_FOOD: begin
                if (f_render_food)
                    next_game_state = RENDER_GHOSTS;  // Move to RENDER_GHOSTS when RENDER_FOOD is finished
                else
                    next_game_state = RENDER_FOOD; // Stay in RENDER_FOOD if not finished
            end
            RENDER_GHOSTS: begin
                if (f_render_ghosts)
                    next_game_state = GHOST_COLLISION;  // Move to GHOST_COLLISION when RENDER_GHOSTS is finished
                else
                    next_game_state = RENDER_GHOSTS; // Stay in RENDER_GHOSTS if not finished
            end
            GHOST_COLLISION: begin
                if (f_ghost_collision)
                    next_game_state = UPDATE_VGA;  // Move to UPDATE_VGA when GHOST_COLLISION is finished
                else
                    next_game_state = GHOST_COLLISION; // Stay in GHOST_COLLISION if not finished
            end
            UPDATE_VGA: begin
                if (f_update_vga)
                    next_game_state = GAME_OVER;  // Move to GAME_OVER when UPDATE_VGA is finished
                else
                    next_game_state = UPDATE_VGA; // Stay in UPDATE_VGA if not finished
            end
            GAME_OVER: begin
                next_game_state = IDLE; // Move back to IDLE immediately
            end
            default: next_game_state = CLEAR_SCREEN; // Default state is CLEAR_SCREEN
        endcase
    end

    // Enable logic and finish logic
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
            end
            UPDATE_POSITION: begin
                data = dt_update_position;
                addr = ad_update_position;
                wren = wr_update_position;
            end
            EAT_FOOD: begin
                data = dt_eat_food;
                addr = ad_eat_food;
                wren = wr_eat_food;
            end
            UPDATE_GHOST_DIRECTIONS: begin
                data = dt_update_ghost_directions;
                addr = ad_update_ghost_directions;
                wren = wr_update_ghost_directions;
            end
            UPDATE_GHOST_POSITIONS: begin
                data = dt_update_ghost_positions;
                addr = ad_update_ghost_positions;
                wren = wr_update_ghost_positions;
            end
            FILL_SCREEN: begin
                data = dt_fill_screen;
                addr = ad_fill_screen;
                wren = wr_fill_screen;
            end
            RENDER_BLOCKS: begin
                data = dt_render_blocks;
                addr = ad_render_blocks;
                wren = wr_render_blocks;
            end
            RENDER_PLAYER: begin
                data = dt_render_player;
                addr = ad_render_player;
                wren = wr_render_player;
            end
            RENDER_FOOD: begin
                data = dt_render_food;
                addr = ad_render_food;
                wren = wr_render_food;
            end
            RENDER_GHOSTS: begin
                data = dt_render_ghosts;
                addr = ad_render_ghosts;
                wren = wr_render_ghosts;
            end
            GHOST_COLLISION: begin
                data = dt_ghost_collision;
                addr = ad_ghost_collision;
                wren = wr_ghost_collision;
            end
            UPDATE_VGA: begin
                data = dt_update_vga;
                addr = ad_update_vga;
                wren = wr_update_vga;
            end
        endcase
    end

    // Module instantiation with wren parameter
    m_clear_screen              m_clear_screen              (clock, resetn, e_clear_screen, wr_clear_screen, f_clear_screen, dt_clear_screen, ad_clear_screen);
    m_update_position           m_update_position           (clock, resetn, e_update_position, wr_update_position, f_update_position, dt_update_position, ad_update_position);
    m_eat_food                  m_eat_food                  (clock, resetn, e_eat_food, wr_eat_food, f_eat_food, dt_eat_food, ad_eat_food);
    m_update_ghost_directions   m_update_ghost_directions   (clock, resetn, e_update_ghost_directions, wr_update_ghost_directions, f_update_ghost_directions, dt_update_ghost_directions, ad_update_ghost_directions);
    m_update_ghost_positions    m_update_ghost_positions    (clock, resetn, e_update_ghost_positions, wr_update_ghost_positions, f_update_ghost_positions, dt_update_ghost_positions, ad_update_ghost_positions);
    m_fill_screen               m_fill_screen               (clock, resetn, e_fill_screen, wr_fill_screen, f_fill_screen, dt_fill_screen, ad_fill_screen);
    m_render_blocks             m_render_blocks             (clock, resetn, e_render_blocks, wr_render_blocks, f_render_blocks, dt_render_blocks, ad_render_blocks);
    m_render_player             m_render_player             (clock, resetn, e_render_player, wr_render_player, f_render_player, dt_render_player, ad_render_player);
    m_render_food               m_render_food               (clock, resetn, e_render_food, wr_render_food, f_render_food, dt_render_food, ad_render_food);
    m_render_ghosts             m_render_ghosts             (clock, resetn, e_render_ghosts, wr_render_ghosts, f_render_ghosts, dt_render_ghosts, ad_render_ghosts);
    m_ghost_collision           m_ghost_collision           (clock, resetn, e_ghost_collision, wr_ghost_collision, f_ghost_collision, dt_ghost_collision, ad_ghost_collision);
    m_update_vga                m_update_vga                (clock, resetn, e_update_vga, wr_update_vga, f_update_vga, dt_update_vga, ad_update_vga);

endmodule


module m_greeting(clock, resetn, enable, finished, data, addr, wren);

    // basic inputs
    input clock, resetn, enable;
    // finish signal
    output reg finished;
    // data and address control
    output reg [2:0] data;
    output reg [16:0] addr;
    output reg wren;

    always @ (posedge clock) begin
        if (!resetn)
            finished <= 0;  // Reset to initial state
        else if (enable)
            finished <= 1;  // Finish immediately when enabled, for testing
        else if (finished)
            finished <= 0;  // Reset to initial state when finished
    end

endmodule


module m_game_over(clock, resetn, enable, finished, data, addr, wren);

    // basic inputs
    input clock, resetn, enable;
    // finish signal
    output reg finished;
    // data and address control
    output reg [2:0] data;
    output reg [16:0] addr;
    output reg wren;

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

module m_clear_screen(clock, resetn, enable, wren, finished, data, addr);

    // Basic inputs
    input clock, resetn, enable;
    
    // Output write enable signal
    output reg wren; // wren signal for controlling writes

    // Finish signal
    output reg finished;

    // Data and address control
    output reg [2:0] data;
    output reg [16:0] addr;

    always @ (posedge clock) begin
        if (!resetn) begin
            finished <= 0;  // Reset to initial state
            data <= 3'b000;
            addr <= 17'b0;
            wren <= 0; // Disable write
        end
        else if (enable) begin
            wren <= 1; // Enable write
            finished <= 1;  // Finish immediately when enabled, for testing
            data <= 3'b001; // Example data value
            addr <= addr + 1; // Increment address
        end
        else if (finished) begin
            wren <= 0; // Disable write when finished
            finished <= 0;  // Reset to initial state
        end
    end

endmodule


module m_update_position(clock, resetn, enable, wren, finished, data, addr);

    // Basic inputs
    input clock, resetn, enable;

    // Output write enable signal
    output reg wren; // wren signal for controlling writes

    // Finish signal
    output reg finished;

    // Data and address control
    output reg [2:0] data;
    output reg [16:0] addr;

    always @ (posedge clock) begin
        if (!resetn) begin
            finished <= 0;  // Reset to initial state
            data <= 3'b000;
            addr <= 17'b0;
            wren <= 0; // Disable write
        end
        else if (enable) begin
            wren <= 1; // Enable write
            finished <= 1;  // Finish immediately when enabled, for testing
            data <= 3'b010; // Example data value
            addr <= addr + 1; // Increment address
        end
        else if (finished) begin
            wren <= 0; // Disable write when finished
            finished <= 0;  // Reset to initial state
        end
    end

endmodule


module m_eat_food(clock, resetn, enable, wren, finished, data, addr);

    // Basic inputs
    input clock, resetn, enable;

    // Output write enable signal
    output reg wren; // wren signal for controlling writes

    // Finish signal
    output reg finished;

    // Data and address control
    output reg [2:0] data;
    output reg [16:0] addr;

    always @ (posedge clock) begin
        if (!resetn) begin
            finished <= 0;  // Reset to initial state
            data <= 3'b000;
            addr <= 17'b0;
            wren <= 0; // Disable write
        end
        else if (enable) begin
            wren <= 1; // Enable write
            finished <= 1;  // Finish immediately when enabled, for testing
            data <= 3'b011; // Example data value
            addr <= addr + 1; // Increment address
        end
        else if (finished) begin
            wren <= 0; // Disable write when finished
            finished <= 0;  // Reset to initial state
        end
    end

endmodule


module m_update_ghost_directions(clock, resetn, enable, wren, finished, data, addr);

    // Basic inputs
    input clock, resetn, enable;

    // Output write enable signal
    output reg wren; // wren signal for controlling writes

    // Finish signal
    output reg finished;

    // Data and address control
    output reg [2:0] data;
    output reg [16:0] addr;

    always @ (posedge clock) begin
        if (!resetn) begin
            finished <= 0;  // Reset to initial state
            data <= 3'b000;
            addr <= 17'b0;
            wren <= 0; // Disable write
        end
        else if (enable) begin
            wren <= 1; // Enable write
            finished <= 1;  // Finish immediately when enabled, for testing
            data <= 3'b100; // Example data value
            addr <= addr + 1; // Increment address
        end
        else if (finished) begin
            wren <= 0; // Disable write when finished
            finished <= 0;  // Reset to initial state
        end
    end

endmodule


module m_update_ghost_positions(clock, resetn, enable, wren, finished, data, addr);

    // Basic inputs
    input clock, resetn, enable;

    // Output write enable signal
    output reg wren; // wren signal for controlling writes

    // Finish signal
    output reg finished;

    // Data and address control
    output reg [2:0] data;
    output reg [16:0] addr;

    always @ (posedge clock) begin
        if (!resetn) begin
            finished <= 0;  // Reset to initial state
            data <= 3'b000;
            addr <= 17'b0;
            wren <= 0; // Disable write
        end
        else if (enable) begin
            wren <= 1; // Enable write
            finished <= 1;  // Finish immediately when enabled, for testing
            data <= 3'b101; // Example data value
            addr <= addr + 1; // Increment address
        end
        else if (finished) begin
            wren <= 0; // Disable write when finished
            finished <= 0;  // Reset to initial state
        end
    end

endmodule


module m_fill_screen(clock, resetn, enable, wren, finished, data, addr);

    // Basic inputs
    input clock, resetn, enable;

    // Output write enable signal
    output reg wren; // wren signal for controlling writes

    // Finish signal
    output reg finished;

    // Data and address control
    output reg [2:0] data;
    output reg [16:0] addr;

    always @ (posedge clock) begin
        if (!resetn) begin
            finished <= 0;  // Reset to initial state
            data <= 3'b000;
            addr <= 17'b0;
            wren <= 0; // Disable write
        end
        else if (enable) begin
            wren <= 1; // Enable write
            finished <= 1;  // Finish immediately when enabled, for testing
            data <= 3'b110; // Example data value
            addr <= addr + 1; // Increment address
        end
        else if (finished) begin
            wren <= 0; // Disable write when finished
            finished <= 0;  // Reset to initial state
        end
    end

endmodule


module m_render_blocks(clock, resetn, enable, wren, finished, data, addr);

    // Basic inputs
    input clock, resetn, enable;

    // Output write enable signal
    output reg wren; // wren signal for controlling writes

    // Finish signal
    output reg finished;

    // Data and address control
    output reg [2:0] data;
    output reg [16:0] addr;

    always @ (posedge clock) begin
        if (!resetn) begin
            finished <= 0;  // Reset to initial state
            data <= 3'b000;
            addr <= 17'b0;
            wren <= 0; // Disable write
        end
        else if (enable) begin
            wren <= 1; // Enable write
            finished <= 1;  // Finish immediately when enabled, for testing
            data <= 3'b111; // Example data value
            addr <= addr + 1; // Increment address
        end
        else if (finished) begin
            wren <= 0; // Disable write when finished
            finished <= 0;  // Reset to initial state
        end
    end

endmodule


module m_render_player(clock, resetn, enable, wren, finished, data, addr);

    // Basic inputs
    input clock, resetn, enable;

    // Output write enable signal
    output reg wren; // wren signal for controlling writes

    // Finish signal
    output reg finished;

    // Data and address control
    output reg [2:0] data;
    output reg [16:0] addr;

    always @ (posedge clock) begin
        if (!resetn) begin
            finished <= 0;  // Reset to initial state
            data <= 3'b000;
            addr <= 17'b0;
            wren <= 0; // Disable write
        end
        else if (enable) begin
            wren <= 1; // Enable write
            finished <= 1;  // Finish immediately when enabled, for testing
            data <= 3'b001; // Example data value
            addr <= addr + 1; // Increment address
        end
        else if (finished) begin
            wren <= 0; // Disable write when finished
            finished <= 0;  // Reset to initial state
        end
    end

endmodule


module m_render_food(clock, resetn, enable, wren, finished, data, addr);

    // Basic inputs
    input clock, resetn, enable;

    // Output write enable signal
    output reg wren; // wren signal for controlling writes

    // Finish signal
    output reg finished;

    // Data and address control
    output reg [2:0] data;
    output reg [16:0] addr;

    always @ (posedge clock) begin
        if (!resetn) begin
            finished <= 0;  // Reset to initial state
            data <= 3'b000;
            addr <= 17'b0;
            wren <= 0; // Disable write
        end
        else if (enable) begin
            wren <= 1; // Enable write
            finished <= 1;  // Finish immediately when enabled, for testing
            data <= 3'b010; // Example data value
            addr <= addr + 1; // Increment address
        end
        else if (finished) begin
            wren <= 0; // Disable write when finished
            finished <= 0;  // Reset to initial state
        end
    end

endmodule


module m_render_ghosts(clock, resetn, enable, wren, finished, data, addr);

    // Basic inputs
    input clock, resetn, enable;

    // Output write enable signal
    output reg wren; // wren signal for controlling writes

    // Finish signal
    output reg finished;

    // Data and address control
    output reg [2:0] data;
    output reg [16:0] addr;

    always @ (posedge clock) begin
        if (!resetn) begin
            finished <= 0;  // Reset to initial state
            data <= 3'b000;
            addr <= 17'b0;
            wren <= 0; // Disable write
        end
        else if (enable) begin
            wren <= 1; // Enable write
            finished <= 1;  // Finish immediately when enabled, for testing
            data <= 3'b011; // Example data value
            addr <= addr + 1; // Increment address
        end
        else if (finished) begin
            wren <= 0; // Disable write when finished
            finished <= 0;  // Reset to initial state
        end
    end

endmodule


module m_ghost_collision(clock, resetn, enable, wren, finished, data, addr);

    // Basic inputs
    input clock, resetn, enable;

    // Output write enable signal
    output reg wren; // wren signal for controlling writes

    // Finish signal
    output reg finished;

    // Data and address control
    output reg [2:0] data;
    output reg [16:0] addr;

    always @ (posedge clock) begin
        if (!resetn) begin
            finished <= 0;  // Reset to initial state
            data <= 3'b000;
            addr <= 17'b0;
            wren <= 0; // Disable write
        end
        else if (enable) begin
            wren <= 1; // Enable write
            finished <= 1;  // Finish immediately when enabled, for testing
            data <= 3'b100; // Example data value
            addr <= addr + 1; // Increment address
        end
        else if (finished) begin
            wren <= 0; // Disable write when finished
            finished <= 0;  // Reset to initial state
        end
    end

endmodule


module m_update_vga(clock, resetn, enable, wren, finished, data, addr);

    // Basic inputs
    input clock, resetn, enable;

    // Output write enable signal
    output reg wren; // wren signal for controlling writes

    // Finish signal
    output reg finished;

    // Data and address control
    output reg [2:0] data;
    output reg [16:0] addr;

    always @ (posedge clock) begin
        if (!resetn) begin
            finished <= 0;  // Reset to initial state
            data <= 3'b000;
            addr <= 17'b0;
            wren <= 0; // Disable write
        end
        else if (enable) begin
            wren <= 1; // Enable write
            finished <= 1;  // Finish immediately when enabled, for testing
            data <= 3'b101; // Example data value
            addr <= addr + 1; // Increment address
        end
        else if (finished) begin
            wren <= 0; // Disable write when finished
            finished <= 0;  // Reset to initial state
        end
    end

endmodule
