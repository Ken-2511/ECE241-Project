module m_renderer (
    input wire clock,               // Clock signal
    input wire resetn,              // Active-low reset
    input wire enable,              // Enable rendering
    output reg finished,            // Rendering finished flag

    // VGA outputs
    output reg [7:0] VGA_X,         // VGA x-coordinate
    output reg [6:0] VGA_Y,         // VGA y-coordinate
    output reg [11:0] VGA_COLOR,    // VGA color output (12-bit: R,G,B each 4-bit)

    // Background
    input wire [11:0] bg_color,     // 12-bit background color

    // Player
    input wire [4:0] pl_game_x,
    input wire [3:0] pl_game_y,

    // Ghosts
    input wire [4:0] g1_game_x,
    input wire [3:0] g1_game_y,
    input wire [4:0] g2_game_x,
    input wire [3:0] g2_game_y,
    input wire [4:0] g3_game_x,
    input wire [3:0] g3_game_y
);

    // State encoding
    parameter IDLE = 3'b000, ERASE = 3'b001, DRAW = 3'b010, DONE = 3'b011;
    reg [2:0] state, next_state;

    // Rendering variables
    reg [4:0] curr_x;       // Current rendering logical coordinates
    reg [3:0] curr_y;
    reg [3:0] dx, dy;               // Offsets within the block
    reg [11:0] curr_color;          // Current rendering color (12-bit: R,G,B each 4-bit)
    wire [11:0] pl_color;           // Player color

    // Rendering target index
    reg [1:0] render_index;         // 0: Player, 1: Ghost 1, 2: Ghost 2, 3: Ghost 3

    // State transition logic
    always @(posedge clock or negedge resetn) begin
        if (!resetn)
            state <= IDLE;
        else if (enable)
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: 
                next_state = ERASE;
            ERASE: 
                next_state = (render_index == 3 && dx == 4 && dy == 4) ? DRAW : ERASE;
            DRAW: 
                next_state = (render_index == 3 && dx == 4 && dy == 4) ? DONE : DRAW;
            DONE: 
                next_state = IDLE;
            default: 
                next_state = IDLE;
        endcase
    end

    // VGA rendering logic
    always @(posedge clock or negedge resetn) begin
        if (!resetn) begin
            // Initialize
            VGA_X <= 0;
            VGA_Y <= 0;
            VGA_COLOR <= 0;
            dx <= 0;
            dy <= 0;
            render_index <= 0;
            curr_x <= 0;
            curr_y <= 0;
            curr_color <= bg_color;
            finished <= 0;
        end else if (enable) begin
            case (state)
                IDLE: begin
                    // Prepare for rendering
                    render_index <= 0;
                    dx <= 0;
                    dy <= 0;
                    curr_x <= pl_game_x;
                    curr_y <= pl_game_y;
                    curr_color <= bg_color;
                    finished <= 0;
                end

                ERASE: begin
                    // Erase the current object's previous position
                    VGA_X <= curr_x * 5 + dx;
                    VGA_Y <= curr_y * 5 + dy;
                    VGA_COLOR <= bg_color;

                    if (dx < 4)
                        dx <= dx + 1;
                    else if (dy < 4) begin
                        dx <= 0;
                        dy <= dy + 1;
                    end else begin
                        dx <= 0;
                        dy <= 0;
                        if (render_index < 3) begin
                            render_index <= render_index + 1;
                            case (render_index + 1)
                                1: {curr_x, curr_y} <= {g1_game_x, g1_game_y};
                                2: {curr_x, curr_y} <= {g2_game_x, g2_game_y};
                                3: {curr_x, curr_y} <= {g3_game_x, g3_game_y};
                            endcase
                        end else begin
                            render_index <= 0;
                            curr_x <= pl_game_x;
                            curr_y <= pl_game_y;
                        end
                    end
                end

                DRAW: begin
                    // Draw the current object's current position
                    VGA_X <= curr_x * 5 + dx;
                    VGA_Y <= curr_y * 5 + dy;
                    VGA_COLOR <= (render_index == 0) ? pl_color : 12'hFFF; // Assume ghosts are white

                    if (dx < 4)
                        dx <= dx + 1;
                    else if (dy < 4) begin
                        dx <= 0;
                        dy <= dy + 1;
                    end
                    else begin
                        dx <= 0;
                        dy <= 0;
                        if (render_index < 3) begin
                            render_index <= render_index + 1;
                            case (render_index)
                                1: {curr_x, curr_y, curr_color} <= {g1_game_x, g1_game_y, 12'hFFF}; // Ghost 1
                                2: {curr_x, curr_y, curr_color} <= {g2_game_x, g2_game_y, 12'hFFF}; // Ghost 2
                                3: {curr_x, curr_y, curr_color} <= {g3_game_x, g3_game_y, 12'hFFF}; // Ghost 3
                            endcase
                        end else begin
                            render_index <= 0;
                        end
                    end
                end

                DONE: begin
                    finished <= 1;
                end
            endcase
        end else begin
            finished <= 0;
        end
    end

    // Player
    player u_player (
        .address(dy * 5'd5 + dx),
        .clock(clock),
        .q(pl_color)
    );

endmodule
