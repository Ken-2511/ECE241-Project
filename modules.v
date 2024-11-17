module m_greeting(clock, resetn, enable, finished, data, addr, wren);

    parameter cbit = 23;

    // Basic inputs
    input clock, resetn, enable;
    // Finish signal
    output reg finished;
    // Data and address control
    output reg [cbit:0] data;
    output reg [14:0] addr;
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

    parameter cbit = 23;

    // Basic inputs
    input clock, resetn, enable;
    // Finish signal
    output reg finished;
    // Data and address control
    output reg [cbit:0] data;
    output reg [14:0] addr;
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

module m_clear_screen(clock, resetn, enable, wren, finished, data, addr, last_key_received);

    parameter cbit = 23;

    // Basic inputs
    input clock, resetn, enable;
    
    // Output write enable signal
    output reg wren; // wren signal for controlling writes

    // Finish signal
    output reg finished;

    // Data and address control
    output reg [cbit:0] data;
    output reg [14:0] addr;

    // Last key received
    input [7:0] last_key_received;

    always @ (posedge clock) begin
        if (!resetn) begin
            finished <= 0;  // Reset to initial state
            data <= 3'b000;
            addr <= 15'b0;
            wren <= 0; // Disable write
        end
        else if (enable) begin
            // 8'h29 <- this is for the SPACE key
            // wait for the SPACE key to be pressed
            // if (last_key_received == 8'h29) begin
                finished <= 1;  // Finish immediately when enabled, for testing
            // end
        end
        else if (finished) begin
            wren <= 0; // Disable write when finished
            finished <= 0;  // Reset to initial state
        end
    end

endmodule


module m_update_position(clock, resetn, enable, wren, finished, data, addr);

    parameter cbit = 23;

    // Basic inputs
    input clock, resetn, enable;

    // Output write enable signal
    output reg wren; // wren signal for controlling writes

    // Finish signal
    output reg finished;

    // Data and address control
    output reg [cbit:0] data;
    output reg [14:0] addr;

    always @ (posedge clock) begin
        if (!resetn) begin
            finished <= 0;  // Reset to initial state
            data <= 3'b000;
            addr <= 15'b0;
            wren <= 0; // Disable write
        end
        else if (enable) begin
            wren <= 0; // Disable write
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

    parameter cbit = 23;

    // Basic inputs
    input clock, resetn, enable;

    // Output write enable signal
    output reg wren; // wren signal for controlling writes

    // Finish signal
    output reg finished;

    // Data and address control
    output reg [cbit:0] data;
    output reg [14:0] addr;

    always @ (posedge clock) begin
        if (!resetn) begin
            finished <= 0;  // Reset to initial state
            data <= 3'b000;
            addr <= 15'b0;
            wren <= 0; // Disable write
        end
        else if (enable) begin
            wren <= 0; // Disable write
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

    parameter cbit = 23;

    // Basic inputs
    input clock, resetn, enable;

    // Output write enable signal
    output reg wren; // wren signal for controlling writes

    // Finish signal
    output reg finished;

    // Data and address control
    output reg [cbit:0] data;
    output reg [14:0] addr;

    always @ (posedge clock) begin
        if (!resetn) begin
            finished <= 0;  // Reset to initial state
            data <= 3'b000;
            addr <= 15'b0;
            wren <= 0; // Disable write
        end
        else if (enable) begin
            wren <= 0; // Disable write
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

    parameter cbit = 23;

    // Basic inputs
    input clock, resetn, enable;

    // Output write enable signal
    output reg wren; // wren signal for controlling writes

    // Finish signal
    output reg finished;

    // Data and address control
    output reg [cbit:0] data;
    output reg [14:0] addr;

    always @ (posedge clock) begin
        if (!resetn) begin
            finished <= 0;  // Reset to initial state
            data <= 3'b000;
            addr <= 15'b0;
            wren <= 0; // Disable write
        end
        else if (enable) begin
            wren <= 0; // Disable write
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

    parameter cbit = 23;

    // Basic inputs
    input clock, resetn, enable;

    // Output write enable signal
    output reg wren; // wren signal for controlling writes

    // Finish signal
    output reg finished;

    // Data and address control
    output reg [cbit:0] data;
    output reg [14:0] addr;

    always @ (posedge clock) begin
        if (!resetn) begin
            finished <= 0;  // Reset to initial state
            data <= 3'b000;
            addr <= 17'b0;
            wren <= 0; // Disable write
        end
        else if (enable) begin
            wren <= 0; // Disable write
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

    parameter cbit = 23;

    // Basic inputs
    input clock, resetn, enable;

    // Output write enable signal
    output reg wren; // wren signal for controlling writes

    // Finish signal
    output reg finished;

    // Data and address control
    output reg [cbit:0] data;
    output reg [14:0] addr;

    always @ (posedge clock) begin
        if (!resetn) begin
            finished <= 0;  // Reset to initial state
            data <= 3'b000;
            addr <= 15'b0;
            wren <= 0; // Disable write
        end
        else if (enable) begin
            wren <= 0; // Disable write
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


module m_render_player(clock, resetn, enable, wren, finished, data, addr, VGA_X, VGA_Y, VGA_COLOR, game_x, game_y, direct);

    parameter cbit = 23;

    // Basic inputs
    input clock, resetn, enable;

    // Output write enable signal
    output reg wren; // wren signal for controlling writes

    // Finish signal
    output reg finished;

    // Data and address control
    output reg [cbit:0] data;
    output reg [14:0] addr;

    // VGA outputs
    output reg [7:0] VGA_X;
    output reg [6:0] VGA_Y;
    output reg [cbit:0] VGA_COLOR;

    // Player position and direction
    input [5:0] game_x;
    input [4:0] game_y;
    input [1:0] direct;
    wire [7:0] canvas_x;
    wire [6:0] canvas_y;
    reg [2:0] dx, dy;
    wire [cbit:0] color;
    wire [4:0] temp_player_addr;
    assign temp_player_addr = dy * 5 + dx;

    game_coord_2_canvas_coord U1 (game_x, game_y, canvas_x, canvas_y);

    player U2 (
        .address(temp_player_addr),
        .clock(clock),
        .q(color)
    );

    always @ (posedge clock) begin
        if (!resetn) begin
            finished <= 0;  // Reset to initial state
            data <= 24'b000;
            addr <= 15'b0;
            wren <= 0; // Disable write
            dx <= 0;
            dy <= 0;
        end
        else if (enable) begin
            wren <= 1; // Enable write
            data <= color;
            if (dx == 0 && dy == 0) begin
                addr <= canvas_y * 160 + canvas_x;
                dx <= dx + 1;
            end
            else if (dx < 4) begin
                dx <= dx + 1;
                addr <= addr + 1;
            end
            else if (dy < 4) begin
                dy <= dy + 1;
                dx <= 0;
                addr <= addr + 1;
            end
            else begin
                finished <= 1;  // Finish immediately when enabled, for testing
                wren <= 0;
                addr <= 0;
                dx <= 0;
                dy <= 0;
            end
        end
        else if (finished) begin
            finished <= 0;  // Reset to initial state
        end
    end

endmodule


module m_render_food(clock, resetn, enable, wren, finished, data, addr, VGA_X, VGA_Y, VGA_COLOR);

    parameter cbit = 23;

    // Basic inputs
    input clock, resetn, enable;

    // Output write enable signal
    output reg wren; // wren signal for controlling writes

    // Finish signal
    output reg finished;

    // Data and address control
    output reg [cbit:0] data;
    output reg [14:0] addr;

    // VGA outputs
    output reg [7:0] VGA_X;  // @ chatgpt: change from 8 to 7
    output reg [6:0] VGA_Y;
    output reg [cbit:0] VGA_COLOR;

    // Food position
    reg [5:0] game_x;
    reg [4:0] game_y;
    wire [7:0] canvas_x;
    wire [6:0] canvas_y;
    wire [cbit:0] color;
    wire food_exists;
    wire [8:0] temp_food_addr;
    assign temp_food_addr = game_y * 29 + game_x;

    assign color = 24'hffffff;

    game_coord_2_canvas_coord U1 (game_x, game_y, canvas_x, canvas_y);

    food U2 (
        .address(temp_food_addr),
        .clock(clock),
        .q(food_exists),
        .wren(1'b0),
        .data(1'b0)
    );

    always @ (posedge clock) begin
        if (!resetn) begin
            finished <= 0;  // Reset to initial state
            data <= 23'b000;
            addr <= 15'b0;
            wren <= 0; // Disable write
            game_x <= 0;
            game_y <= 0;
        end
        else if (enable) begin
            // Check if food exists
            if (food_exists) begin
                wren <= 1; // Enable write
                data <= color;
                addr <= canvas_y * 160 + canvas_x;
            end
            else begin
                wren <= 0; // Disable write
            end
            // Increment food position
            if (game_x < 28) begin
                game_x <= game_x + 1;
            end
            else if (game_y < 12) begin
                game_x <= 0;
                game_y <= game_y + 1;
            end
            else begin
                finished <= 1;
            end
        end
        else if (finished) begin
            wren <= 0; // Disable write when finished
            finished <= 0;  // Reset to initial state
        end
    end

endmodule


module m_render_ghosts(clock, resetn, enable, wren, finished, data, addr, VGA_X, VGA_Y, VGA_COLOR, ghost_x, ghost_y, direct, last_key_received);

    parameter cbit = 23;
    parameter num_ghosts = 4;

    // Basic inputs
    input clock, resetn, enable;

    // Output write enable signal
    output reg wren; // wren signal for controlling writes

    // Finish signal
    output reg finished;

    // Data and address control
    output reg [cbit:0] data;
    output reg [14:0] addr;

    // VGA outputs
    output reg [7:0] VGA_X;
    output reg [6:0] VGA_Y;
    output reg [cbit:0] VGA_COLOR;

    // Ghost position and direction
    input [5:0] ghost_x;
    input [4:0] ghost_y;
    input [1:0] direct;

    // PS2 inputs
    input [7:0] last_key_received;

    // // Ghost position and direction
    // input [5:0] ghost_x [0:num_ghosts-1];
    // input [4:0] ghost_y [0:num_ghosts-1];
    // input [1:0] direct [0:num_ghosts-1];

    // // Intermediate variables
    reg [2:0] dx, dy; // Offset within the ghost's sprite
    reg [1:0] ghost_index; // Track which ghost we are rendering
    wire [7:0] canvas_x;
    wire [6:0] canvas_y;
    wire [cbit:0] color;

    // // Convert game coordinates to canvas coordinates
    // game_coord_2_canvas_coord coord_converter (
    //     .game_x(ghost_x[ghost_index]), 
    //     .game_y(ghost_y[ghost_index]), 
    //     .canvas_x(canvas_x),
    //     .canvas_y(canvas_y)
    // );

    // // Ghost sprite memory read (each ghost has an 8x8 sprite)
    // ghost_sprite ghost_sprite_memory (
    //     .address({dy, dx}), 
    //     .clock(clock), 
    //     .q(color)
    // );

    always @(posedge clock) begin
        if (!resetn) begin
            // Reset state
            finished <= 0;
            data <= 24'b000;
            addr <= 15'b0;
            wren <= 0;
            VGA_X <= 0;
            VGA_Y <= 0;
            VGA_COLOR <= 0;
            dx <= 0;
            dy <= 0;
            ghost_index <= 0;
        end 
        else if (enable) begin
    //         wren <= 1; // Enable write
    //         data <= color;
    //         VGA_X <= canvas_x + dx;
    //         VGA_Y <= canvas_y + dy;
    //         VGA_COLOR <= color;
    //         addr <= (canvas_y + dy) * 320 + (canvas_x + dx);

    //         // Update sprite coordinates
    //         if (dx < 7) begin
    //             dx <= dx + 1;
    //         end
    //         else if (dy < 7) begin
    //             dx <= 0;
    //             dy <= dy + 1;
    //         end
    //         else begin
    //             // Finished rendering current ghost, move to the next one
    //             if (ghost_index < num_ghosts - 1) begin
    //                 ghost_index <= ghost_index + 1;
    //                 dx <= 0;
    //                 dy <= 0;
    //             end
    //             else begin
    //                 // All ghosts rendered
                //  if (last_key_received == 8'h29) begin
                    finished <= 1;
                //  end
    //                 wren <= 0;
    //                 ghost_index <= 0;
    //                 dx <= 0;
    //                 dy <= 0;
    //             end
    //         end
        end
        else if (finished) begin
            wren <= 0; // Disable write when finished
            finished <= 0; // Reset to initial state
        end
    end

endmodule


module m_ghost_collision(clock, resetn, enable, wren, finished, data, addr);

    parameter cbit = 23;

    // Basic inputs
    input clock, resetn, enable;

    // Output write enable signal
    output reg wren; // wren signal for controlling writes

    // Finish signal
    output reg finished;

    // Data and address control
    output reg [cbit:0] data;
    output reg [14:0] addr;

    always @ (posedge clock) begin
        if (!resetn) begin
            finished <= 0;  // Reset to initial state
            data <= 3'b000;
            addr <= 15'b0;
            wren <= 0; // Disable write
        end
        else if (enable) begin
            wren <= 0; // Disable write
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


module m_update_vga(
    clock,
    resetn,
    enable,
    wren,
    finished,
    data,
    addr,
    q,
    VGA_X,      // Additional output
    VGA_Y,      // Additional output
    VGA_COLOR   // Additional output
);

    parameter cbit = 23;

    // Basic inputs
    input clock, resetn, enable;

    // Outputs
    output reg wren;
    output reg finished;
    output reg [cbit:0] data;
    output reg [14:0] addr;
    // Input
    input [cbit:0] q;

    // Additional outputs for VGA
    output reg [7:0] VGA_X;
    output reg [6:0] VGA_Y;
    output reg [cbit:0] VGA_COLOR;

    // Internal counters
    reg [7:0] x_counter;
    reg [6:0] y_counter;

    // Assume RAM data output is connected to the data line (read when wren=0)
    // If there is a dedicated RAM data output signal, adjust accordingly

    always @ (posedge clock) begin
        if (!resetn) begin
            finished <= 0;
            x_counter <= 0;
            y_counter <= 0;
            wren <= 0;
            VGA_X <= 0;
            VGA_Y <= 0;
            VGA_COLOR <= 0;
            addr <= 0;
        end else if (enable) begin
            if (!finished) begin
                wren <= 0; // Read mode, do not write to RAM
                if (x_counter < 160) begin
                    VGA_X <= x_counter;
                    VGA_Y <= y_counter;
                    addr <= y_counter * 160 + x_counter; // Assume screen resolution is 320x240
                    VGA_COLOR <= q; // Color data read from RAM
                    x_counter <= x_counter + 1;
                end else if (y_counter < 120) begin
                    x_counter <= 0;
                    y_counter <= y_counter + 1;
                end else begin
                    finished <= 1;
                    x_counter <= 0;
                    y_counter <= 0;
                    VGA_X <= 0;
                    VGA_Y <= 0;
                    VGA_COLOR <= 0;
                end
            end else begin
                finished <= 0; // Reset finished flag
            end
        end else begin
            wren <= 0;
        end
    end

endmodule
