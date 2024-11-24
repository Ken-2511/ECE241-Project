// Mock game logic module
module m_game_logic (
    input clock,
    input resetn,
    input enable,
    output reg finished,
    output reg [4:0] player_x,
    output reg [3:0] player_y,
    output wire [4:0] ghost1_x, ghost2_x, ghost3_x,
    output wire [3:0] ghost1_y, ghost2_y, ghost3_y,
    output reg [7:0] score,
    input [7:0] last_key_received,
    output reg food_eaten
);
    
    reg [3:0] state, next_state;

    parameter wall_collision = 3'b000, update_player_position = 3'b001, update_ghost_positions = 3'b010, eat_food = 3'b011;

    //player movement
    reg [3:0] collision; // wall collision: 3 is up, 2 is left, 1 is down, 0 is right
    wire [2:0] w;
    wire [1:0] direction;
    get_direction GD(last_key_received, w); //in player_movement.v
    movement_FSM MF(clock, resetn, w, direction); //in player_movement.v

    parameter up = 2'b00, left = 2'b01, down = 2'b10, right = 2'b11;

    //calculating stuff for wall collision
    wire [4:0] columns = 5'b11101;
    wire [3:0] directly_up = player_y - 1;
    wire [4:0] directly_left = player_x - 1;
    wire [3:0] directly_down = player_y + 1;
    wire [4:0] directly_right = player_x + 1;

    reg [8:0] address_wall;
    wire wall;
   // wire [8:0] address_wall;
   // assign address_wall = address_temp_wall;
    blocks B(address_wall, clock, 1'b0, 1'b0, wall);

    //stuff for updating ghost positions
    reg [6:0] address1, address2, address3;
    wire [12:0] g1, g2, g3;

    ghost1 G1(address1, clock, g1);
    ghost2 G2(address2, clock, g2);
    ghost3 G3(address3, clock, g3);

    assign ghost1_x = g1[12:8];
    assign ghost1_y = g1[7:4];
    assign ghost2_x = g2[12:8];
    assign ghost2_y = g2[7:4];
    assign ghost3_x = g3[12:8];
    assign ghost3_y = g3[7:4];

    //stuff for eating food
    wire [8:0] address_food;
    assign address_food = player_y * columns + player_x;
    wire food_dot;

    reg wr;

    food F(address_food, clock, 1'b0, wr, food_dot);

    reg f_update_player_position, f_wall_collision, f_update_ghost_positions, f_eat_food; //finished flags

    //move to next state
    always @(posedge clock or negedge resetn) begin
        if (!resetn) begin
            state <= wall_collision;
        end
        else if (enable) begin 
            state <= next_state;
        end 
        else if(finished) begin 
            state <= wall_collision;
        end
    end

    //state logic
    always @(*) begin 
        case(state)
            wall_collision: begin 
                if(f_wall_collision) next_state = update_player_position;
                else next_state = wall_collision;
            end
                
            update_player_position: begin 
                if(f_update_player_position) next_state = update_ghost_positions;
                else next_state = update_player_position;
            end 
                
            update_ghost_positions: begin
                if(f_update_ghost_positions) next_state = eat_food;
                else next_state = update_ghost_positions;
            end 
                
            eat_food: begin
                next_state = eat_food;
            end 
                
            default: next_state = wall_collision;
        endcase 
    end

    //FSM outputs
    always @(posedge clock) begin 
        //defaults
        f_wall_collision = 1'b0;
        f_update_player_position = 1'b0;
        f_update_ghost_positions = 1'b0;
        f_eat_food = 1'b0;
        finished = 1'b0;

        case(state)
            //for checking wall collision
            wall_collision: begin 
                case(direction)
                    up: address_wall = directly_up * columns + player_x;
                    left: address_wall = player_y * columns + directly_left;
                    down: address_wall = directly_down * columns + player_x;
                    right: address_wall = player_y * columns + directly_right;
                endcase

                if (!resetn) begin
                    collision <= 4'b0; 
                    finished = 1'b0;
                    food_eaten = 1'b0;
                    player_x = 5'b00001;
                    player_y = 4'b0001;
                    address1 = 7'b0;
                    address2 = 7'b0;
                    address3 = 7'b0;
                    score <= 8'b0;
                    wr <= 1'b0;
                end
                else if(enable) begin
                    if(direction == up && wall) collision[3] <= 1'b1;
                    else collision[3] <= 1'b0;

                    if(direction == left && wall) collision[2] <= 1'b1;
                    else collision[2] <= 1'b0;

                    if(direction == down && wall) collision[1] <= 1'b1;
                    else collision[1] <= 1'b0;

                    if(direction == right && wall) collision[0] <= 1'b1;
                    else collision[0] <= 1'b0;
            
                end 
                

                f_wall_collision <= 1'b1;
            end 

            //for updating player position
            update_player_position: begin 
                if (enable) begin
                    case(direction)
                        up: begin 
                            if(!collision[3]) begin
                                player_y <= player_y - 1;
                                player_x <= player_x;
                            end
                            else begin 
                                player_y <= player_y; 
                                player_x <= player_x;
                            end
                        end
                        left: begin 
                            if(!collision[2]) begin 
                                player_x <= player_x - 1;
                                player_y <= player_y;
                            end 
                            else begin
                                player_x <= player_x;
                                player_y <= player_y;
                            end
                        end
                        down: begin 
                            if(!collision[1]) begin
                                player_y <= player_y + 1;
                                player_x <= player_x;
                            end
                            else begin
                                player_y <= player_y;
                                player_x <= player_x;
                            end
                        end
                        right: begin 
                            if(!collision[0]) begin
                                player_x <= player_x + 1;
                                player_y <= player_y;
                            end
                            else begin
                                player_x <= player_x;
                                player_y <= player_y;
                            end
                        end
                    endcase

                    f_update_player_position <= 1'b1;
                end
            end 

            //for updating ghost positions
            update_ghost_positions: begin
                if (enable) begin
                    //update positions, set addresses to 0 if they reach the end of the path
                    if(address1 == 63)
                        address1 <= 7'b0;
                    else
                        address1 <= address1 + 1;
        
                    if(address2 == 78)
                        address2 <= 7'b0;
                    else
                        address2 <= address2 + 1;
        
                    if(address3 == 50)
                        address3 <= 7'b0;
                    else
                        address3 <= address3 + 1;
                end
                f_update_ghost_positions <= 1'b1;
            end 

            //for eating food and incrementing the score
            eat_food: begin
                if(enable) begin
                    wr <= 1'b0;
                    if(food_dot) begin
                        score <= score + 1;
                        wr <= 1'b1;
                    end
                end 
                f_eat_food <= 1'b1;
                finished = 1'b1;
            end 
        endcase
    end 

endmodule

// ghost collision detection module
module m_ghost_collision (
    clock,
    resetn,
    enable,
    player_x,
    player_y,
    ghost1_x,
    ghost1_y,
    ghost2_x,
    ghost2_y,
    ghost3_x,
    ghost3_y,
    ghost_collision
);
    input clock, resetn, enable;
    input [4:0] player_x;
    input [3:0] player_y;
    input [4:0] ghost1_x, ghost2_x, ghost3_x;
    input [3:0] ghost1_y, ghost2_y, ghost3_y;
    // output reg finished;
    output reg ghost_collision;

    always @(*) begin
        if (!resetn) begin
            ghost_collision <= 1'b0;
            // finished <= 1'b0;
        end
        else if (enable) begin 
            //check collisions with ghosts
            if( (player_x == ghost1_x && player_y == ghost1_y) || (player_x == ghost2_x && player_y == ghost2_y) || (player_x == ghost3_x && player_y == ghost3_y) ) begin
                ghost_collision <= 1'b1;
            end
            else begin
                ghost_collision <= 1'b0;
            end 

            // finished <= 1'b1;
        end 
    end
endmodule
