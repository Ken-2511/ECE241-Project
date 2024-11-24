// Mock game logic module
module m_game_logic (
    input clock,
    input resetn,
    input hs_enable,
    input enable,
    output reg finished,
    output reg [4:0] player_x,
    output reg [3:0] player_y,
    output reg [4:0] ghost1_x, ghost2_x, ghost3_x,
    output reg [3:0] ghost1_y, ghost2_y, ghost3_y,
    output reg [7:0] score,
    input [7:0] last_key_received,
    output reg food_eaten
);
    
    reg [3:0] state, next_state;

    parameter update_player_position = 3'b000, wall_collision = 3'b001, update_ghost_positions = 3'b010, eat_food = 3'b011;
    parameter [7:0] won_score = 8'b10111100;

    //FSM
    initial begin
        score = 8'b0;
    end 

    //move to next state
    always @(posedge clock or negedge resetn) begin
        if (!resetn) begin
            state <= wall_collision;
        end
        else if (enable) begin 
            state <= next_state;
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
                if(f_eat_food) next_state = wall_collision;
                else next_state = eat_food;
            end 
                
            default: next_state = wall_collision;
        endcase 
    end 

    //data for calculating stuff in the outputs/operations
    reg e_update_player_position, e_wall_collision, e_update_ghost_positions, e_eat_food; //enable flags
    reg f_update_player_position, f_wall_collision, f_update_ghost_positions, f_eat_food; //finished flags

    //player movement
    reg collision; // wall collision
    wire [2:0] w, direction;
    wire collided;
    assign collided = collision;
    get_direction GD(last_key_received, hs_enable, w); //in player_movement.v
    movement_FSM MF(clock, resetn, hs_enable, w, collided, direction); //in player_movement.v

    parameter still = 3'b000, up = 3'b001, left = 3'b010, down = 3'b011, right = 3'b100;

    //calculating stuff for wall collision
    wire [4:0] columns = 5'b11101;
    wire [3:0] directly_up = player_y - 1;
    wire [4:0] directly_left = player_x - 1;
    wire [3:0] directly_down = player_y + 1;
    wire [4:0] directly_right = player_x + 1;

    reg [8:0] address_temp_wall;
    wire wall;
    wire [8:0] address_wall;
    assign address_wall = address_temp_wall;

    blocks B(address_wall, clock, 3'b0, 1'b0, wall);

    //stuff for updating ghost positions
    reg [6:0] address1, address2, address3;
    wire [10:0] g1, g2, g3;
    wire [6:0] address_g1, address_g2, address_g3;
    assign address_g1 = address1;
    assign address_g2 = address2;
    assign address_g3 = address3;

    ghost1 G1(address_g1, clock, g1);
    ghost2 G2(address_g2, clock, g2);
    ghost3 G3(address_g3, clock, g3);

    assign ghost1_x = g1[10:6];
    assign ghost1_y = g1[5:2];
    assign ghost2_x = g2[10:6];
    assign ghost2_y = g2[5:2];
    assign ghost3_x = g3[10:6];
    assign ghost3_y = g3[5:2];

    //stuff for eating food
    wire [8:0] address_food;
    assign address_food = player_y * columns + player_x;
    wire food_dot;

    reg wr;
    wire wren, q;
    assign wren = wr;

    food F(address, clock, 1'b0, wren, food_dot);

    //FSM outputs
    always @(*) begin 
        //defaults
        f_wall_collision = 1'b0;
        f_update_player_position = 1'b0;
        f_update_ghost_positions = 1'b0;
        f_eat_food = 1'b0;

        case(state)
            //for checking wall collision
            wall_collision: begin 
                case(direction)
                    up: address_temp_wall = directly_up * columns + player_x;
                    left: address_temp_wall = player_y * columns + directly_left;
                    down: address_temp_wall = directly_down * columns + player_x;
                    right: address_temp_wall = player_y * columns + directly_right;
                    default: address_temp_wall = 8'b0;
                endcase

                if (!resetn) begin
                    f_wall_collision <= 1'b0;
                    collision <= 1'b0; 
                end
                else if(enable && direction != still) begin
                    if(wall)
                        collision <= 1'b1;
                    else
                        collision <= 1'b0;
            
                    f_wall_collision <= 1'b1;
                end 
                else begin 
                    f_wall_collision <= 1'b1; 
                    collision <= 1'b0;
                end 
            end 

            //for updating player position
            update_player_position: begin 
                if (!resetn) begin
                    f_update_player_position <= 1'b0;

                   player_x <= 5'b00001;
                   player_y <= 4'b0001;
               end
               else if (hs_enable) begin
                    case(direction)
                        up: begin player_x <= player_x; player_y <= player_y - 1; end
                        left: begin player_x <= player_x - 1; player_y <= player_y; end
                        down: begin player_x <= player_x; player_y <= player_y + 1; end
                        right: begin player_x <= player_x + 1; player_y <= player_y; end
                        default: begin player_x <= player_x; player_y <= player_y; end
                    endcase

                    f_update_player_position <= 1'b1;
                end
            end 

            //for updating ghost positions
            update_ghost_positions: begin 
                if (!resetn) begin
                    address1 <= 7'b0;
                    address2 <= 7'b0;
                    address3 <= 7'b0;

                    f_update_ghost_positions <= 1'b0;
                end
                else if (enable) begin
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

                    f_update_ghost_positions <= 1'b1;
                end
            end 

            //for eating food and incrementing the score
            eat_food: begin
                if(!resetn) begin
                    wr <= 1'b0;
                    f_eat_food <= 1'b0;
                    score <= 8'b0;
                end
                else if(enable) begin
                    wr <= 1'b0;
                    if(q) begin
                        score <= score + 1;
                        wr <= 1'b1;
                        f_eat_food <= 1'b1;
                    end
                end 
            end 
        endcase 
    end 

endmodule

// ghost collision detection module
module m_ghost_collision (clock, resetn, enable, finished, player_x, player_y, ghost1_x, ghost1_y, ghost2_x, ghost2_y, ghost3_x, ghost3_y, ghost_collision);
    input clock, resetn, enable;
    input [4:0] player_x;
    input [3:0] player_y;
    input [4:0] ghost1_x, ghost2_x, ghost3_x;
    input [3:0] ghost1_y, ghost2_y, ghost3_y;
    output reg finished;
    output reg ghost_collision;

    always @(posedge clock or negedge resetn) begin
        if (!resetn) begin
            ghost_collision <= 1'b0;
            finished <= 1'b0;
        end
        else if (enable) begin 
            //check collisions with ghosts
            if( (player_x == ghost1_x && player_y == ghost1_y) || (player_x == ghost2_x && player_y == ghost2_y) || (player_x == ghost3_x && player_y == ghost3_y) ) begin
                ghost_collision <= 1'b1;
            end
            else begin
                ghost_collision <= 1'b0;
            end 

            finished <= 1'b1;
        end 
    end
endmodule
