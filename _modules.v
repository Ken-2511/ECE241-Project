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
    output reg game_over,
    input [7:0] last_key_received
);
    
    reg e_update_player_position, e_wall_collision, e_update_ghost_positions, e_ghost_collision, e_eat_food; //enable flags
    reg f_update_player_position, f_wall_collision, f_update_ghost_positions, f_ghost_collision, f_eat_food; //finished flags
    reg [3:0] state, next_state;
    reg [7:0] score;

    parameter update_player_position = 3'b000, wall_collision = 3'b001, update_ghost_positions = 3'b010, ghost_collision = 3'b011, eat_food = 3'b100;
    parameter [7:0] won_score = 8'b10111100;

    //turn it into an FSM
    initial begin
        score = 8'b0;
    end 

    always @(posedge clock or negedge resetn) begin
        if (!resetn) begin
            score <= 8'b0;
            finished <= 0;
            player_x <= 5'b00001;
            player_y <= 4'b0001; //TODO: FIX THE GHOST COORDINATES
            ghost1_x <= 5'b00101;
            ghost1_y <= 4'b0011;
            ghost2_x <= 5'b00110;
            ghost2_y <= 4'b0110;
            ghost3_x <= 5'b01000;
            ghost3_y <= 4'b1000;

            state <= update_player_position;
        end
        else if (enable) begin 
            state <= next_state;
        end 
    end

    always @(*) begin 
        case(state)
            wall_collision:
                if(f_wall_collision) next_state = update_player_position;
                else next_state = wall_collision;
            update_player_position:
                if(f_update_player_position) next_state = update_ghost_positions;
                else next_state = update_player_position;
            update_ghost_positions:
                if(f_update_ghost_positions) next_state = ghost_collision;
                else next_state = update_ghost_positions;
            ghost_collision:
                if(f_ghost_collision) next_state = eat_food;
                else next_state = ghost_collision;
            eat_food:
                if(f_eat_food) next_state = update_player_position;
                else next_state = eat_food;
            default: next_state = update_player_position;
        endcase 
    end 

    always @(*) begin 
        //defaults
        e_update_player_position = 0;
        e_update_ghost_positions = 0;
        e_wall_collision = 0;
        e_eat_food = 0;
        e_ghost_collision = 0;

        case(state)
            wall_collision: e_wall_collision = 1;
            update_player_position: e_update_player_position = 1;
            update_ghost_positions: e_update_ghost_positions = 1;
            ghost_collision: e_ghost_collision = 1;
            eat_food: e_eat_food = 1;
            default: e_update_player_position = 1;
        endcase 
    end 

    //player 
    wire [2:0] w, direction;
    wire collided;
    get_direction GD(last_key_received, hs_enable, collided, direction); //in player_movement.v
    movement_FSM MF(clock, resetn, he_enable, w, direction); //in player_movement.v
    m_wall_collision U1(clock, resetn, e_wall_collision, f_wall_collision, player_x, player_y, direction, collided);
    m_update_player_position U2(clock, resetn, e_update_player_position, f_update_player_position, direction, player_x, player_y, hs_enable);

    //ghosts
    m_update_ghost_positions U3(clock, resetn, e_update_ghost_positions, f_update_ghost_positions, ghost1_x, ghost1_y, ghost2_x, ghost2_y, ghost3_x, ghost3_y);
    m_collision U4(clock, resetn, e_ghost_collision, f_ghost_collision, player_x, player_y, ghost1_x, ghost1_y, ghost2_x, ghost2_y, ghost3_x, ghost3_y, game_over);

    //TODO: eat food
endmodule

//HELPER MODULES-----------------------------------------------------------------------------------------------------------------------

//update player position module
module m_update_player_position(clock, resetn, enable, finished, direction, player_x, player_y, hs_enable);

    parameter cbit = 11;
    parameter still = 3'b000, up = 3'b001, left = 3'b010, down = 3'b011, right = 3'b100; //TODO: STILL NEED TO DO COLLISIONS

    // Basic inputs
    input clock, resetn, enable, hs_enable;

    // Finish signal
    output reg finished;

    // Player
    input [2:0] direction;
    output reg [4:0] player_x;
    output reg [3:0] player_y;

    always @ (posedge clock) begin
        if (!resetn) begin
            finished <= 0;  // Reset to initial state
            data <= 3'b0;
            addr <= 15'b0;

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

            finished <= 1;  // Finish immediately when enabled, for testing
        end
        else if (finished) begin
            finished <= 0;  // Reset to initial state
        end
    end

endmodule

//check collision with walls module
module m_wall_collision(clock, resetn, enable, finished, player_x, player_y, direction, collision);
    input clock, resetn, enable;
    input [2:0] direction;
    input [4:0] player_x;
    input [3:0] player_y;
    output reg finished, collision;

    wire [4:0] columns = 5'b11101;
    wire [3:0] directly_up = player_y - 1;
    wire [4:0] directly_left = player_x - 1;
    wire [3:0] directly_down = player_y + 1;
    wire [4:0] directly_right = player_x + 1;

    parameter still = 3'b000, up = 3'b001, left = 3'b010, down = 3'b011, right = 3'b100;
    reg [8:0] address_temp;
    wire q;

    always @(*) begin
        case(direction)
            up: adress_temp = directly_up * columns + player_x;
            left: address_temp = player_y * columns + directly_left;
            down: address_temp = directly_down * columns + player_x;
            right: address_temp = player_y * columns + directly_right;
            default: address_temp = 8'b0;
        endcase
    end
    wire [8:0] address;
    assign address = address_temp;
    blocks B(address, clock, 3'b0, 1'b0, q);

    always @(posedge clock) begin
        if (!resetn) begin
            finished <= 1'b0;
            collision <= 1'b0;
        end
        else if(enable and direction != still) begin
            if(q)
                collision <= 1'b1;
            else
                collision <= 1'b0;
            
            finished <= 1'b1;
        end 
        else begin 
            finished <= 1'b1; //if player is still, then no collision and exist the module
            collision <= 1'b0;
        end 
    end 
endmodule

//update ghost position module
module m_update_ghost_positions(clock, resetn, enable, finished, ghost1_x, ghost1_y, ghost2_x, ghost2_y, ghost3_x, ghost3_y); 

    parameter cbit = 11;

    // Basic inputs
    input clock, resetn, enable;

    // Finish signal
    output reg finished;

    // Ghost coordinates
    reg [6:0] address1, address2, address3;
    wire [10:0] q1, q2, q3;
    output [4:0] ghost1_x, ghost2_x, ghost3_x;
    output [3:0] ghost1_y, ghost2_y, ghost3_y;

    always @ (posedge clock) begin
        //going through the fsm
        if (!resetn) begin
            address1 <= 7'b0;
            address2 <= 7'b0;
            address3 <= 7'b0;

            finished <= 0;  // Reset to initial state
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

            finished <= 1;  // Finish immediately when enabled, for testing
        end
        else if (finished) begin
            finished <= 0;  // Reset to initial state
        end
    end

    ghost1 G1(address1, clock, q1);
    ghost2 G2(address2, clock, q2);
    ghost3 G3(address3, clock, q3);

    assign ghost1_x = q1[10:6];
    assign ghost1_y = q1[5:2];
    assign ghost2_x = q2[10:6];
    assign ghost2_y = q2[5:2];
    assign ghost3_x = q3[10:6];
    assign ghost3_y = q3[5:2];

endmodule

// ghost collision detection module
module m_collision (clock, resetn, enable, finished, player_x, player_y, ghost1_x, ghost1_y, ghost2_x, ghost2_y, ghost3_x, ghost3_y, ghost_collision);
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

//module for eating food
module m_eat_food(clock, resetn, enable, finished, player_x, player_y, score);
    input clock, resetn, enable;
    input [4:0] player_x;
    input [3:0] player_y;
    output reg finished;
    output reg [7:0] score;

    wire [4:0] columns = 5'b11101;
    wire [8:0] address;
    assign address = player_y * columns + player_x;

    reg wr;
    wire wren, q;
    assign wren = wr;

    always @(posedge clock) begin 
        if(!resetn) begin
            wr <= 1'b0;
            finished <= 1'b0;
        end
        else if(enable) begin
            wr <= 1'b0;
            if(q) begin
                score <= score + 1;
                wr <= 1'b1;
                finished <= 1'b1;
            end
        end 
    end

    food F(address, clock, 1'b0, wren, q);
endmodule 
