// Get the inputs for FSM from WASD keyboard input
module get_direction(key, w);
    input [7:0] key;
    output reg [2:0] w;

    parameter W = 8'b00011101, A = 8'b00011100, S = 8'b00011011, D = 8'b00100011;

    always @(key) begin
        case (key)
            W: w = 3'b001;
            A: w = 3'b010;
            S: w = 3'b011;
            D: w = 3'b100;
            default: w = 3'b000;
        endcase
    end
endmodule

// Handles states of moving
module movement_FSM(clock, resetn, w, z); 
    input clock, resetn;
    input [2:0] w;
    output reg [1:0] z;

    reg [1:0] state, next_state;
    parameter up = 2'b00, left = 2'b01, down = 2'b10, right = 2'b11;

    // State selection
    always @(resetn or w or state) begin
        case (state)
            up:
                if (w == 3'b010) next_state <= left;
                else if (w == 3'b011) next_state <= down;
                else if (w == 3'b100) next_state <= right;
                else next_state <= up;
            left:
                if (w == 3'b001) next_state = up;
                else if (w == 3'b011) next_state = down;
                else if (w == 3'b100) next_state = right;
                else next_state = left;
            down:
                if (w == 3'b001) next_state = up;
                else if (w == 3'b010) next_state = left;
                else if (w == 3'b100) next_state = right;
                else next_state = down;
            right:
                if (w == 3'b001) next_state = up;
                else if (w == 3'b010) next_state = left;
                else if (w == 3'b011) next_state = down;
                else next_state = right;
        endcase
    end

    // Move to next state
    always @(posedge clock) begin
        if (!resetn)
            state <= up;
        else
            state <= next_state;
    end

    // Outputs
    always @(posedge clock) begin
        case (state)
            up: z = 2'b00;
            left: z = 2'b01;
            down: z = 2'b10;
            right: z = 2'b11;
        endcase
    end
endmodule

//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

// // Handles states of moving
// module movement_FSM(clock, resetn, enable, w, collided, z); // Add wall collision later
//     input clock, resetn, enable;
//     input [3:0] collided;
//     input [2:0] w;
//     output reg [2:0] z;

//     reg [2:0] state, next_state;
//     parameter still = 3'b000, up = 3'b001, left = 3'b010, down = 3'b011, right = 3'b100;

//     // State selection
//     always @(enable or resetn or w or state) begin
//         case (state)
//             still:
//                 if (w == 3'b001) next_state <= up;
//                 else if (w == 3'b010) next_state <= left;
//                 else if (w == 3'b011) next_state <= down;
//                 else if (w == 3'b100) next_state <= right;
//                 else next_state = still;
//             up:
//                 if(collided[3]) next_state = still;
//                 else if (w == 3'b010) next_state <= left;
//                 else if (w == 3'b011) next_state <= down;
//                 else if (w == 3'b100) next_state <= right;
//                 else next_state <= up;
//             left:
//                 if(collided[2]) next_state = still;
//                 else if (w == 3'b001) next_state = up;
//                 else if (w == 3'b011) next_state = down;
//                 else if (w == 3'b100) next_state = right;
//                 else next_state = left;
//             down:
//                 if(collided[1]) next_state = still;
//                 else if (w == 3'b001) next_state = up;
//                 else if (w == 3'b010) next_state = left;
//                 else if (w == 3'b100) next_state = right;
//                 else next_state = down;
//             right:
//                 if(collided[0]) next_state = still;
//                 else if (w == 3'b001) next_state = up;
//                 else if (w == 3'b010) next_state = left;
//                 else if (w == 3'b011) next_state = down;
//                 else next_state = right;
//             default: next_state = still;
//         endcase
//     end

//     // Move to next state
//     always @(posedge clock) begin
//         if (!resetn)
//             state <= still;
//         else
//             state <= next_state;
//     end

//     // Outputs
//     always @(posedge clock) begin
//         case (state)
//             still: z = 3'b000;
//             up: z = 3'b001;
//             left: z = 3'b010;
//             down: z = 3'b011;
//             right: z = 3'b100;
//             default: z = 3'b000;
//         endcase
//     end
// endmodule
