module fsm_game_state (
    input clock,
    input resetn,
    input enable,
    input [7:0] last_key_received,
    output reg [7:0] VGA_X,
    output reg [6:0] VGA_Y,
    output reg [11:0] VGA_COLOR
);

    // State encoding
    parameter GREETING = 3'b000, 
              PLAYING_LOGIC = 3'b001, 
              PLAYING_RENDER = 3'b010, 
              GAME_OVER = 3'b011;

    reg [2:0] state, next_state;

    // Signals for logic and rendering
    reg e_logic, e_render, e_game_over;

    // Completion signals
    wire logic_done, render_done, game_over_done;

    // Collision detection signal
    wire collision_detected;

    // Trigger for starting the game
    wire start_game = (last_key_received == 8'h29); // SPACE key to start

    // Player and ghosts data
    wire [4:0] player_x, ghost1_x, ghost2_x, ghost3_x;
    wire [3:0] player_y, ghost1_y, ghost2_y, ghost3_y;

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

        case (state)
            GREETING: begin
                VGA_X = 0;
                VGA_Y = 0;
                VGA_COLOR = 12'h000; // Background color
            end

            PLAYING_LOGIC: begin
                e_logic = 1; // Enable game logic
            end

            PLAYING_RENDER: begin
                e_render = 1; // Enable rendering
            end

            GAME_OVER: begin
                e_game_over = 1; // Trigger game over behavior
            end

            default: begin
                // Defaults
                VGA_X = 0;
                VGA_Y = 0;
                VGA_COLOR = 12'h000;
            end
        endcase
    end

    // Instantiate submodules

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
        .last_key_received(last_key_received)
    );

    // Rendering module
    m_renderer renderer_inst (
        .clock(clock),
        .resetn(resetn),
        .enable(e_render),
        .finished(render_done) // Render done signal
        .VGA_X(VGA_X),
        .VGA_Y(VGA_Y),
        .VGA_COLOR(VGA_COLOR),
        .player_x(player_x),
        .player_y(player_y),
        .ghost1_x(ghost1_x),
        .ghost1_y(ghost1_y),
        .ghost2_x(ghost2_x),
        .ghost2_y(ghost2_y),
        .ghost3_x(ghost3_x),
        .ghost3_y(ghost3_y)
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
        .collided(collision_detected) // High when collision detected
    );

    // Game over module
    m_game_over game_over_inst (
        .clock(clock),
        .resetn(resetn),
        .enable(e_game_over),
        .finished(game_over_done), // Game over done signal
        .VGA_X(VGA_X),
        .VGA_Y(VGA_Y),
        .VGA_COLOR(VGA_COLOR)
    );

endmodule
