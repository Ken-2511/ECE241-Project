module game_state_control(
    input clock, 
    input resetn, 
    input enable,
    input GREETING_FINISHED, 
    input PLAYING_FINISHED, 
    input GAME_OVER_FINISHED,
    output reg [1:0] game_state
);

    // State encoding
    parameter GREETING = 2'b00, PLAYING = 2'b01, GAME_OVER = 2'b10;

    reg [1:0] next_game_state;

    // State transition based on inputs and current state
    always @ (posedge clock or negedge resetn) begin
        if (!resetn) 
            game_state <= GREETING;  // Reset to initial state
        else if (enable) 
            game_state <= next_game_state;  // Move to the next state if enabled
    end

    // Next state logic
    always @ (*) begin
        case (game_state)
            GREETING: begin
                if (GREETING_FINISHED)
                    next_game_state = PLAYING;  // Move to PLAYING when GREETING_FINISHED is high
                else
                    next_game_state = GREETING; // Stay in GREETING if not finished
            end
            PLAYING: begin
                if (PLAYING_FINISHED)
                    next_game_state = GAME_OVER;  // Move to GAME_OVER when PLAYING_FINISHED is high
                else
                    next_game_state = PLAYING;   // Stay in PLAYING if not finished
            end
            GAME_OVER: begin
                if (GAME_OVER_FINISHED)
                    next_game_state = GREETING;  // Loop back to GREETING when GAME_OVER_FINISHED is high
                else
                    next_game_state = GAME_OVER; // Stay in GAME_OVER if not finished
            end
            default: next_game_state = GREETING; // Default state is GREETING
        endcase
    end

endmodule
