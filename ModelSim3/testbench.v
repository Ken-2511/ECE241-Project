//test testbench

'timescale 1ns/1ps

module testbench();
    
    reg CLOCK_50, resetn, hs_enable, enable;
    reg [7:0] last_key_received;

    wire finished;
    wire [4:0] player_x, ghost1_x, ghost2_x, ghost3_x;
    wire [3:0] player_y, ghost1_y, ghost2_y, ghost3_y;
    wire game_over, you_won;
    
    always
        #10 CLOCK_50 <= CLOCK_50;
    
    initial begin
        hs_enable <= 1; resetn <=1 ; enable <= 1;
        CLOCK_50 <= 0;
        #10 last_key_received <= 8'b00100011;
    end 

    m_game_logic logic(CLOCK_50, resetn, hs_enable, enable, finished, player_x, player_y, ghost1_x, ghost1_y, ghost2_x, ghost2_y, ghost3_x, ghost3_y, game_over, you_won, last_key_received);

endmodule 