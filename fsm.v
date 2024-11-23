module fsm_game_state (
    input clock,
    input resetn,
    input enable,
    input [7:0] last_key_received,
    output reg [7:0] VGA_X,
    output reg [6:0] VGA_Y,
    output reg [11:0] VGA_COLOR,
    input start_key,
    input collided // for testing
);

    // State encoding
    parameter GREETING = 3'b000, 
              PLAYING_LOGIC = 3'b001, 
              PLAYING_RENDER = 3'b010, 
              WAITING = 3'b011,
              GAME_OVER = 3'b100;

    reg [2:0] state, next_state;

    // Signals for logic and rendering
    reg e_logic, e_render, e_game_over, e_greeting;

    // Completion signals
    wire greeting_done, logic_done, render_done, game_over_done;

    // Collision detection signal
    wire collision_detected = collided;

    // Trigger for starting the game
    wire start_game;
    assign start_game = ~start_key;

    // Player and ghosts data
    wire [4:0] player_x, ghost1_x, ghost2_x, ghost3_x;
    wire [3:0] player_y, ghost1_y, ghost2_y, ghost3_y;

    // VGA signals from submodules
    wire [7:0] vga_x_greeting, vga_x_render, vga_x_game_over;
    wire [6:0] vga_y_greeting, vga_y_render, vga_y_game_over;
    wire [11:0] vga_color_greeting, vga_color_render, vga_color_game_over;

    // Background signals
    wire [4:0] bg_x;
    wire [3:0] bg_y;
    reg bg_wren;
    reg [11:0] bg_write_data;
    wire [11:0] bg_color;
    wire [14:0] bg_address;

    // Calculate background memory address
    assign bg_address = bg_y * 5'd20 + bg_x; // Adjust for your background width

    // signals for eating food
    wire food_eaten;

    // Half second enable signal to slow down the FPS
    parameter HS_COUNT = 25000000; // 50MHz / 2 = 25MHz
    reg [25:0] hs_counter = 0;
    reg hs_enable = 0;
    always @(posedge clock or negedge resetn) begin
        if (!resetn)
            hs_counter <= 0;
        else if (hs_counter == HS_COUNT)
            hs_counter <= 0;
        else
            hs_counter <= hs_counter + 1;
    end
    always @(posedge clock or negedge resetn) begin
        if (!resetn)
            hs_enable <= 0;
        else if (hs_counter == HS_COUNT)
            hs_enable <= 1;
        else
            hs_enable <= 0;
    end

    // State transition
    always @(posedge clock or negedge resetn) begin
        if (!resetn)
            state <= GREETING; // Reset to GREETING state
        else if (enable)
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (state)
            GREETING: 
                next_state = start_game ? PLAYING_LOGIC : GREETING;

            PLAYING_LOGIC: 
                next_state = collision_detected ? GAME_OVER : PLAYING_RENDER;

            PLAYING_RENDER:
                next_state = render_done ? WAITING : PLAYING_RENDER;

            WAITING: 
                next_state = (hs_enable == 1) ? PLAYING_LOGIC : WAITING;

            GAME_OVER: 
                next_state = GAME_OVER;

            default: 
                next_state = GREETING;
        endcase
    end

    // Output logic
    always @(*) begin
        // Default values
        e_logic = 0;
        e_render = 0;
        e_game_over = 0;
        e_greeting = 0;
        bg_wren = 0;
        bg_write_data = 12'h000;

        case (state)
            GREETING: begin
                e_greeting = 1; // Enable greeting screen
            end

            PLAYING_LOGIC: begin
                e_logic = 1; // Enable game logic
                // Example: Update background when food is eaten
                if (food_eaten) begin
                    bg_wren = 1; // Enable writing to background
                    bg_write_data = 12'hF00; // Example: Change color to red
                end
            end

            PLAYING_RENDER: begin
                e_render = 1; // Enable rendering for PLAYING screen
            end

            WAITING: begin
                // Do nothing
            end

            GAME_OVER: begin
                e_game_over = 1; // Trigger game over behavior
            end
        endcase
    end

    // Arbitration logic for VGA signals
    always @(*) begin
        case (state)
            GREETING: begin
                VGA_X = vga_x_greeting;
                VGA_Y = vga_y_greeting;
                VGA_COLOR = vga_color_greeting;
            end
            PLAYING_RENDER: begin
                VGA_X = vga_x_render;
                VGA_Y = vga_y_render;
                VGA_COLOR = vga_color_render;
            end
            GAME_OVER: begin
                VGA_X = vga_x_game_over;
                VGA_Y = vga_y_game_over;
                VGA_COLOR = vga_color_game_over;
            end
            default: begin
                VGA_X = 8'd0;
                VGA_Y = 7'd0;
                VGA_COLOR = 12'h000; // Default background color
            end
        endcase
    end

    // Instantiate submodules

    // Greeting rendering module
    m_greeting greeting_inst (
        .clock(clock),
        .resetn(resetn),
        .enable(e_greeting),
        .finished(greeting_done), // Greeting done signal
        .VGA_X(vga_x_greeting),
        .VGA_Y(vga_y_greeting),
        .VGA_COLOR(vga_color_greeting)
    );

    // Game logic module
    m_game_logic game_logic_inst (
        .clock(clock),
        .resetn(resetn),
        .enable(e_logic),
        .finished(logic_done), // Logic done signal
        .player_x(player_x),
        .player_y(player_y),
        .ghost1_x(ghost1_x),
        .ghost1_y(ghost1_y),
        .ghost2_x(ghost2_x),
        .ghost2_y(ghost2_y),
        .ghost3_x(ghost3_x),
        .ghost3_y(ghost3_y),
        .last_key_received(last_key_received),
        .bg_x(bg_x),
        .bg_y(bg_y),
        .bg_color(bg_color),
        .food_eaten(food_eaten)
    );

    // Rendering module
    m_renderer renderer_inst (
        .clock(clock),
        .resetn(resetn),
        .enable(e_render),
        .finished(render_done), // Render done signal
        .VGA_X(vga_x_render),
        .VGA_Y(vga_y_render),
        .VGA_COLOR(vga_color_render),
        .pl_game_x(player_x),
        .pl_game_y(player_y),
        .g1_game_x(ghost1_x),
        .g1_game_y(ghost1_y),
        .g2_game_x(ghost2_x),
        .g2_game_y(ghost2_y),
        .g3_game_x(ghost3_x),
        .g3_game_y(ghost3_y),
        .bg_x(bg_x),
        .bg_y(bg_y),
        .bg_color(bg_color)
    );

    // Game over module
    m_game_over game_over_inst (
        .clock(clock),
        .resetn(resetn),
        .enable(e_game_over),
        .finished(game_over_done), // Game over done signal
        .VGA_X(vga_x_game_over),
        .VGA_Y(vga_y_game_over),
        .VGA_COLOR(vga_color_game_over)
    );

    // Background module
    background u_background (
        .address(bg_address),
        .clock(clock),
        .data(bg_write_data),
        .wren(bg_wren),
        .q(bg_color)
    );

endmodule
