//may need to comment it out

module ghost1_path(clock, enable, resetn, new_x, new_y); 
    input clock, enable, resetn;
    output [4:0] new_x;
    output [3:0] new_y;

    reg [6:0] address;
    wire [10:0] q;

    initial begin
        address = 7'b0;
    end

    always @(posedge clock) begin
        if (!resetn) begin
            address = 7'b0;
        end
        else if(enable && address == 63) begin 
            address = 7'b0;
        end 
        else if(enable) begin
            address = address + 1;
        end
    end

    ghost1 ghost1(address, clock, q);

    assign new_x = q[10:6];
    assign new_y = q[5:2];

endmodule 

module ghost2_path(clock, enable, resetn, new_x, new_y); 
    input clock, enable, resetn;
    output [4:0] new_x;
    output [3:0] new_y;

    reg [6:0] address;
    wire [10:0] q;

    initial begin
        address = 7'b0;
    end

    always @(posedge clock) begin
        if (!resetn) begin
            address = 7'b0;
        end
        else if(enable && address == 78) begin 
            address = 7'b0;
        end 
        else if(enable) begin
            address = address + 1;
        end
    end

    ghost2 ghost2(address, clock, q);

    assign new_x = q[10:6];
    assign new_y = q[5:2];

endmodule 

module ghost1_path(clock, enable, resetn, new_x, new_y); 
    input clock, enable, resetn;
    output [4:0] new_x;
    output [3:0] new_y;

    reg [6:0] address;
    wire [10:0] q;

    initial begin
        address = 7'b0;
    end

    always @(posedge clock) begin
        if (!resetn) begin
            address = 7'b0;
        end
        else if(enable && address == 50) begin 
            address = 7'b0;
        end 
        else if(enable) begin
            address = address + 1;
        end
    end

    ghost3 ghost3(address, clock, q);

    assign new_x = q[10:6];
    assign new_y = q[5:2];

endmodule 