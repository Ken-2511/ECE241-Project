module fsm_game_state (
    input clock,
    input resetn,
    input enable,
    input [7:0] last_key_received,
    output reg [7:0] VGA_X,
    output reg [6:0] VGA_Y,
    output reg [11:0] VGA_COLOR,
    input start_key
);

    // State encoding
    parameter GREETING = 3'b000, 
              PLAYING_LOGIC = 3'b001, 
              PLAYING_RENDER = 3'b010, 
              GAME_OVER = 3'b011,
              YOU_WON = 3'b100;

    reg [2:0] state, next_state;

    // Signals for logic and rendering
    reg e_logic, e_render, e_greeting, e_game_over, e_you_won;
    wire game_over, you_won;
    assign game_over = e_game_over;
    assign you_won = e_you_won;

    // Completion signals
    wire greeting_done, logic_done, render_done, game_over_done;

    // Collision detection signal
    wire collision_detected;

    // Trigger for starting the game
    // wire start_game = (last_key_received == 8'h29); // SPACE key to start
    wire start_game;
    assign start_game = ~start_key;

    // Player and ghosts data
    wire [4:0] player_x, ghost1_x, ghost2_x, ghost3_x;
    wire [3:0] player_y, ghost1_y, ghost2_y, ghost3_y;

    // VGA signals from submodules
    wire [7:0] vga_x_greeting, vga_x_render, vga_x_game_over;
    wire [6:0] vga_y_greeting, vga_y_render, vga_y_game_over;
    wire [11:0] vga_color_greeting, vga_color_render, vga_color_game_over;
    wire [11:0] bg_color;

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
                next_state = render_done ? PLAYING_LOGIC : PLAYING_RENDER;

            GAME_OVER: 
                next_state = game_over_done ? GREETING : GAME_OVER;

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

        case (state)
            GREETING: begin
                e_greeting = 1; // Enable greeting screen
            end

            PLAYING_LOGIC: begin
                e_logic = 1; // Enable game logic
            end

            PLAYING_RENDER: begin
                e_render = 1; // Enable rendering for PLAYING screen
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
        .hs_enable(hs_enable),
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
        .game_over(game_over),
        .you_won(you_won),
        .last_key_received(last_key_received)
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
        .bg_color(bg_color),
        .pl_game_x(player_x),
        .pl_game_y(player_y),
        .g1_game_x(ghost1_x),
        .g1_game_y(ghost1_y),
        .g2_game_x(ghost2_x),
        .g2_game_y(ghost2_y),
        .g3_game_x(ghost3_x),
        .g3_game_y(ghost3_y)
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

    // Collision detection module
    m_ghost_collision collision_inst (
        .clock(clock),
        .resetn(resetn),
        .enable(e_logic), // Check for collision during logic update
        .player_x(player_x),
        .player_y(player_y),
        .ghost1_x(ghost1_x),
        .ghost1_y(ghost1_y),
        .ghost2_x(ghost2_x),
        .ghost2_y(ghost2_y),
        .ghost3_x(ghost3_x),
        .ghost3_y(ghost3_y),
        .collision_detected(collision_detected)
    );

    // the instance for the background color
    canvas u_canvas (
        .address(VGA_Y * 160 + VGA_X),
        .clock(clock),
        .data(12'h000),
        .wren(1'b0),
        .q(bg_color)
    );

    //you won module - TODO

endmodule
