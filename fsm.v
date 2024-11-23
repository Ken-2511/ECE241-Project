module fsm_game_state (
    input clock,
    input resetn,
    input enable,
    output reg [cbit:0] data,
    output reg [14:0] addr,
    output reg wren,
    input [cbit:0] q,
    output reg [7:0] VGA_X,
    output reg [6:0] VGA_Y,
    output reg [cbit:0] VGA_COLOR,
    input [7:0] last_key_received,
    output reg finished
);

    parameter cbit = 11;

    // Higher-Level Game States
    parameter GREETING = 3'b000, 
              PLAYING = 3'b001, 
              GAME_OVER = 3'b010;

    // Playing Sub-States
    parameter GAME_LOGIC = 3'b011,
              RENDER = 3'b100;

    // State Register
    reg [2:0] state, next_state;

    // Render Counter
    reg [2:0] render_counter;

    // Game Logic Outputs
    wire [4:0] player_x, ghost1_x, ghost2_x, ghost3_x;
    wire [3:0] player_y, ghost1_y, ghost2_y, ghost3_y;
    wire [8:0] food_address;
    wire food_exists;

    // Collision Detection
    wire collision_detected;

    // Submodule Enables
    reg e_game_logic, e_render, e_collision;

    // State Transition Logic
    always @(posedge clock or negedge resetn) begin
        if (!resetn)
            state <= GREETING;
        else if (enable)
            state <= next_state;
    end

    // Next State Logic
    always @(*) begin
        case (state)
            GREETING:
                next_state = enable ? PLAYING : GREETING;

            PLAYING: begin
                if (e_game_logic && collision_detected)
                    next_state = GAME_OVER;
                else if (e_render && render_counter == 3'b100)
                    next_state = GAME_LOGIC; // Complete rendering, return to logic
                else
                    next_state = PLAYING; // Stay in PLAYING while rendering or logic is ongoing
            end

            GAME_OVER:
                next_state = GREETING;

            default:
                next_state = GREETING;
        endcase
    end

    // Output Logic
    always @(*) begin
        // Default values
        e_game_logic = 0;
        e_render = 0;
        e_collision = 0;
        wren = 0;
        finished = 0;

        case (state)
            GREETING: begin
                data = 0;
                addr = 0;
                VGA_X = 0;
                VGA_Y = 0;
                VGA_COLOR = 0;
            end

            PLAYING: begin
                if (e_game_logic) begin
                    e_collision = 1;
                    wren = 1; // Enable memory writes for logic updates
                end else if (e_render) begin
                    e_render = 1;
                    wren = 0; // Render is read-only
                end
            end

            GAME_OVER: begin
                finished = 1;
                data = 0;
                addr = 0;
                wren = 0;
                VGA_X = 0;
                VGA_Y = 0;
                VGA_COLOR = 0;
            end
        endcase
    end

    // Render Counter
    always @(posedge clock or negedge resetn) begin
        if (!resetn)
            render_counter <= 3'b000;
        else if (state == RENDER)
            render_counter <= render_counter + 1;
        else
            render_counter <= 3'b000;
    end

    // Submodules

    // Game Logic
    m_game_logic game_logic_inst (
        .clock(clock),
        .resetn(resetn),
        .enable(e_game_logic),
        .player_x(player_x),
        .player_y(player_y),
        .ghost1_x(ghost1_x),
        .ghost1_y(ghost1_y),
        .ghost2_x(ghost2_x),
        .ghost2_y(ghost2_y),
        .ghost3_x(ghost3_x),
        .ghost3_y(ghost3_y),
        .food_address(food_address),
        .food_exists(food_exists),
        .last_key_received(last_key_received)
    );

    // Collision Detection
    m_ghost_collision ghost_collision_inst (
        .clock(clock),
        .resetn(resetn),
        .enable(e_collision),
        .player_x(player_x),
        .player_y(player_y),
        .ghost1_x(ghost1_x),
        .ghost1_y(ghost1_y),
        .ghost2_x(ghost2_x),
        .ghost2_y(ghost2_y),
        .ghost3_x(ghost3_x),
        .ghost3_y(ghost3_y),
        .collided(collision_detected)
    );

    // Renderer
    m_renderer renderer_inst (
        .clock(clock),
        .resetn(resetn),
        .enable(e_render),
        .component(render_counter), // Which component to render
        .player_x(player_x),
        .player_y(player_y),
        .ghost1_x(ghost1_x),
        .ghost1_y(ghost1_y),
        .ghost2_x(ghost2_x),
        .ghost2_y(ghost2_y),
        .ghost3_x(ghost3_x),
        .ghost3_y(ghost3_y),
        .food_address(food_address),
        .food_exists(food_exists),
        .VGA_X(VGA_X),
        .VGA_Y(VGA_Y),
        .VGA_COLOR(VGA_COLOR)
    );

endmodule
