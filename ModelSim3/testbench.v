//test testbench

`timescale 1ns/1ps

module testbench();
    
    reg CLOCK_50, resetn, enable;
    reg [7:0] last_key_received;

    wire finished;
    wire [4:0] player_x, ghost1_x, ghost2_x, ghost3_x;
    wire [3:0] player_y, ghost1_y, ghost2_y, ghost3_y;
    wire [7:0] score;
    
    always
        #10 CLOCK_50 <= !CLOCK_50;

    always @(posedge CLOCK_50) begin
        if(finished) begin
            enable <= 1'b0;
        end
        else if (!enable) begin
            enable <= 1'b1;
        end
    end

    initial begin
        resetn <=1'b0 ; enable <= 1'b1;
        CLOCK_50 <= 1'b1;

        #50 resetn <= 1'b1;

        #20 last_key_received <= 8'b00100011;
    end 

    m_game_logic logic (
        .clock(CLOCK_50),
        .resetn(resetn),
        .enable(enable),
        .finished(finished),
        .player_x(player_x),
        .player_y(player_y),
        .ghost1_x(ghost1_x),
        .ghost1_y(ghost1_y),
        .ghost2_x(ghost2_x),
        .ghost2_y(ghost2_y),
        .ghost3_x(ghost3_x),
        .ghost3_y(ghost3_y),
        .score(score),
        .last_key_received(last_key_received),
        .food_eaten(food_eaten)
    );

endmodule 