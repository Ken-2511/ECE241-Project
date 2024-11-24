//test testbench

`timescale 1ns/1ps

module testbench();
    
    reg CLOCK_50, resetn, hs_enable, enable;
    reg [7:0] last_key_received;

    wire finished;
    wire [4:0] player_x, ghost1_x, ghost2_x, ghost3_x;
    wire [3:0] player_y, ghost1_y, ghost2_y, ghost3_y;
    wire game_over, you_won;
    wire [7:0] score;
    
    always
        #10 CLOCK_50 <= !CLOCK_50;
    
    initial begin
        hs_enable <= 1'b1; resetn <=1'b0 ; enable <= 1'b1;
        CLOCK_50 <= 1'b1;

        #30 resetn <= 1'b1;

        #20 last_key_received <= 8'b00100011;
    end 

    // module m_game_logic (
    //     input clock,
    //     input resetn,
    //     input hs_enable,
    //     input enable,
    //     output reg finished,
    //     output reg [4:0] player_x,
    //     output reg [3:0] player_y,
    //     output wire [4:0] ghost1_x, ghost2_x, ghost3_x,
    //     output wire [3:0] ghost1_y, ghost2_y, ghost3_y,
    //     output reg [7:0] score,
    //     input [7:0] last_key_received,
    //     output reg food_eaten
    // );
    // m_game_logic logic(CLOCK_50, resetn, hs_enable, enable, finished, player_x, player_y, ghost1_x, ghost1_y, ghost2_x, ghost2_y, ghost3_x, ghost3_y, game_over, you_won, last_key_received);
    m_game_logic logic (
        .clock(CLOCK_50),
        .resetn(resetn),
        .hs_enable(hs_enable),
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