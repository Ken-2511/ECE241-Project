module m_greeting(clock, resetn, enable, finished, data, addr, wren);

    parameter cbit = 11;

    // basic inputs
    input clock, resetn, enable;
    // finish signal
    output reg finished;
    // data and address control
    output reg [cbit:0] data;
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

    parameter cbit = 11;

    // basic inputs
    input clock, resetn, enable;
    // finish signal
    output reg finished;
    // data and address control
    output reg [cbit:0] data;
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

    parameter cbit = 11;

    // Basic inputs
    input clock, resetn, enable;
    
    // Output write enable signal
    output reg wren; // wren signal for controlling writes

    // Finish signal
    output reg finished;

    // Data and address control
    output reg [cbit:0] data;
    output reg [16:0] addr;

    always @ (posedge clock) begin
        if (!resetn) begin
            finished <= 0;  // Reset to initial state
            data <= 3'b000;
            addr <= 17'b0;
            wren <= 0; // Disable write
        end
        else if (enable) begin
            wren <= 0; // Enable write
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

    parameter cbit = 11;

    // Basic inputs
    input clock, resetn, enable;

    // Output write enable signal
    output reg wren; // wren signal for controlling writes

    // Finish signal
    output reg finished;

    // Data and address control
    output reg [cbit:0] data;
    output reg [16:0] addr;

    always @ (posedge clock) begin
        if (!resetn) begin
            finished <= 0;  // Reset to initial state
            data <= 3'b000;
            addr <= 17'b0;
            wren <= 0; // Disable write
        end
        else if (enable) begin
            wren <= 0; // Enable write
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

    parameter cbit = 11;

    // Basic inputs
    input clock, resetn, enable;

    // Output write enable signal
    output reg wren; // wren signal for controlling writes

    // Finish signal
    output reg finished;

    // Data and address control
    output reg [cbit:0] data;
    output reg [16:0] addr;

    always @ (posedge clock) begin
        if (!resetn) begin
            finished <= 0;  // Reset to initial state
            data <= 3'b000;
            addr <= 17'b0;
            wren <= 0; // Disable write
        end
        else if (enable) begin
            wren <= 0; // Enable write
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

    parameter cbit = 11;

    // Basic inputs
    input clock, resetn, enable;

    // Output write enable signal
    output reg wren; // wren signal for controlling writes

    // Finish signal
    output reg finished;

    // Data and address control
    output reg [cbit:0] data;
    output reg [16:0] addr;

    always @ (posedge clock) begin
        if (!resetn) begin
            finished <= 0;  // Reset to initial state
            data <= 3'b000;
            addr <= 17'b0;
            wren <= 0; // Disable write
        end
        else if (enable) begin
            wren <= 0; // Enable write
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

    parameter cbit = 11;

    // Basic inputs
    input clock, resetn, enable;

    // Output write enable signal
    output reg wren; // wren signal for controlling writes

    // Finish signal
    output reg finished;

    // Data and address control
    output reg [cbit:0] data;
    output reg [16:0] addr;

    always @ (posedge clock) begin
        if (!resetn) begin
            finished <= 0;  // Reset to initial state
            data <= 3'b000;
            addr <= 17'b0;
            wren <= 0; // Disable write
        end
        else if (enable) begin
            wren <= 0; // Enable write
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

    parameter cbit = 11;

    // Basic inputs
    input clock, resetn, enable;

    // Output write enable signal
    output reg wren; // wren signal for controlling writes

    // Finish signal
    output reg finished;

    // Data and address control
    output reg [cbit:0] data;
    output reg [16:0] addr;

    always @ (posedge clock) begin
        if (!resetn) begin
            finished <= 0;  // Reset to initial state
            data <= 3'b000;
            addr <= 17'b0;
            wren <= 0; // Disable write
        end
        else if (enable) begin
            wren <= 0; // Enable write
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

    parameter cbit = 11;

    // Basic inputs
    input clock, resetn, enable;

    // Output write enable signal
    output reg wren; // wren signal for controlling writes

    // Finish signal
    output reg finished;

    // Data and address control
    output reg [cbit:0] data;
    output reg [16:0] addr;

    always @ (posedge clock) begin
        if (!resetn) begin
            finished <= 0;  // Reset to initial state
            data <= 3'b000;
            addr <= 17'b0;
            wren <= 0; // Disable write
        end
        else if (enable) begin
            wren <= 0; // Enable write
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

    parameter cbit = 11;

    // Basic inputs
    input clock, resetn, enable;

    // Output write enable signal
    output reg wren; // wren signal for controlling writes

    // Finish signal
    output reg finished;

    // Data and address control
    output reg [cbit:0] data;
    output reg [16:0] addr;

    // VGA outputs
    output reg [8:0] VGA_X;
    output reg [7:0] VGA_Y;
    output reg [cbit:0] VGA_COLOR;

    // Player position and direction
    input [5:0] game_x;
    input [4:0] game_y;
    input [1:0] direct;
    wire [8:0] canvas_x;
    wire [7:0] canvas_y;
    reg [2:0] dx, dy;
    wire [cbit:0] color;

    game_coord_2_canvas_coord U1 (game_x, game_y, canvas_x, canvas_y);

    player U2 (
        .address({dy * 8 + dx}),
        .clock(clock),
        .q(color)
    );

    always @ (posedge clock) begin
        if (!resetn) begin
            finished <= 0;  // Reset to initial state
            data <= 12'b000;
            addr <= 17'b0;
            wren <= 0; // Disable write
            dx <= 0;
            dy <= 0;
        end
        else if (enable) begin
            wren <= 1; // Enable write
            data <= color;
            if (dx == 0 && dy == 0) begin
                addr <= canvas_y * 320 + canvas_x;
                dx <= dx + 1;
            end
            else if (dx < 7) begin
                VGA_X <= canvas_x + dx;
                VGA_Y <= canvas_y + dy;
                dx <= dx + 1;
                addr <= addr + 1;
            end
            else if (dy < 7) begin
                VGA_X <= canvas_x + dx;
                VGA_Y <= canvas_y + dy;
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

    parameter cbit = 11;

    // Basic inputs
    input clock, resetn, enable;

    // Output write enable signal
    output reg wren; // wren signal for controlling writes

    // Finish signal
    output reg finished;

    // Data and address control
    output reg [cbit:0] data;
    output reg [16:0] addr;

    // VGA outputs
    output reg [8:0] VGA_X;
    output reg [7:0] VGA_Y;
    output reg [cbit:0] VGA_COLOR;

    // Food position
    reg [5:0] game_x;
    reg [4:0] game_y;
    wire [8:0] canvas_x;
    wire [7:0] canvas_y;
    wire [cbit:0] color; assign color = 12'b111;
    wire food_exists;

    game_coord_2_canvas_coord U1 (game_x, game_y, canvas_x, canvas_y);

    food U2 (
        .address({game_y * 29 + game_x}),
        .clock(clock),
        .q(food_exists)
    );

    always @ (posedge clock) begin
        if (!resetn) begin
            finished <= 0;  // Reset to initial state
            data <= 3'b000;
            addr <= 17'b0;
            wren <= 0; // Disable write
            game_x <= 0;
            game_y <= 0;
        end
        else if (enable) begin
            // Check if food exists
            if (food_exists) begin
                wren <= 1; // Enable write
                data <= color;
                addr <= canvas_y * 320 + canvas_x;
            end
            else begin
                wren <= 0; // Disable write
            end
            // increment food position
            if (game_x < 29) begin
                game_x <= game_x + 1;
            end
            else if (game_y < 13) begin
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


module m_render_ghosts(clock, resetn, enable, wren, finished, data, addr);

    parameter cbit = 11;

    // Basic inputs
    input clock, resetn, enable;

    // Output write enable signal
    output reg wren; // wren signal for controlling writes

    // Finish signal
    output reg finished;

    // Data and address control
    output reg [cbit:0] data;
    output reg [16:0] addr;

    always @ (posedge clock) begin
        if (!resetn) begin
            finished <= 0;  // Reset to initial state
            data <= 3'b000;
            addr <= 17'b0;
            wren <= 0; // Disable write
        end
        else if (enable) begin
            wren <= 0; // Enable write
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

    parameter cbit = 11;

    // Basic inputs
    input clock, resetn, enable;

    // Output write enable signal
    output reg wren; // wren signal for controlling writes

    // Finish signal
    output reg finished;

    // Data and address control
    output reg [cbit:0] data;
    output reg [16:0] addr;

    always @ (posedge clock) begin
        if (!resetn) begin
            finished <= 0;  // Reset to initial state
            data <= 3'b000;
            addr <= 17'b0;
            wren <= 0; // Disable write
        end
        else if (enable) begin
            wren <= 0; // Enable write
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
    VGA_X,      // 新增输出
    VGA_Y,      // 新增输出
    VGA_COLOR   // 新增输出
);

    parameter cbit = 11;

    // 基本输入
    input clock, resetn, enable;

    // 输出
    output reg wren;
    output reg finished;
    output reg [cbit:0] data;
    output reg [16:0] addr;
    // 输入
    input [cbit:0] q;

    // 新增输出用于VGA
    output reg [8:0] VGA_X;
    output reg [7:0] VGA_Y;
    output reg [cbit:0] VGA_COLOR;

    // 内部计数器
    reg [8:0] x_counter;
    reg [7:0] y_counter;

    // 假设RAM的数据输出连接到data线（wren=0时读取）
    // 如果有专门的RAM数据输出信号，请根据实际情况调整

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
                wren <= 0; // 读取模式，不写入RAM
                if (x_counter < 320) begin
                    VGA_X <= x_counter;
                    VGA_Y <= y_counter;
                    addr <= y_counter * 320 + x_counter; // 假设屏幕分辨率为320x240
                    VGA_COLOR <= q; // 从RAM读取的颜色数据
                    x_counter <= x_counter + 1;
                end else if (y_counter < 240) begin
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
                finished <= 0; // 重置完成标志
            end
        end else begin
            wren <= 0;
        end
    end

endmodule
