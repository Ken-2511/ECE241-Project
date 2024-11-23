module fsm_game_state (
    input clock,
    input resetn,
    input enable,
    input [7:0] last_key_received,
    output reg [11:0] data,
    output reg [14:0] addr,
    output reg wren,
    input [11:0] q,
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
    wire logic_done, render_done;

    // Collision detection signal
    wire collision_detected;

    // Trigger for starting the game
    wire start_game = (last_key_received == 8'h29); // SPACE key to start

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
                next_state = GREETING; // Game over returns to GREETING

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
        wren = 0;

        case (state)
            GREETING: begin
                data = 12'h000; // Default VGA color
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
                data = 12'hF00; // Example game over color
            end

            default: begin
                // Defaults
                data = 12'h000;
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
        .player_x(VGA_X),
        .player_y(VGA_Y),
        .data(data),
        .addr(addr),
        .wren(wren)
    );

    // Rendering module
    m_renderer renderer_inst (
        .clock(clock),
        .resetn(resetn),
        .enable(e_render),
        .VGA_X(VGA_X),
        .VGA_Y(VGA_Y),
        .VGA_COLOR(VGA_COLOR),
        .finished(render_done) // Render done signal
    );

    // Collision detection module
    m_ghost_collision collision_inst (
        .clock(clock),
        .resetn(resetn),
        .enable(e_logic), // Check for collision during logic update
        .player_x(VGA_X),
        .player_y(VGA_Y),
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
        .data(data),
        .addr(addr),
        .wren(wren)
    );

endmodule
