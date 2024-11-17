module regn(R, Resetn, E, Clock, Q);
    parameter n = 8;
    input [n-1:0] R;
    input Resetn, E, Clock;
    output reg [n-1:0] Q;

    always @(posedge Clock)
        if (!Resetn)
            Q <= 0;
        else if (E)
            Q <= R;
endmodule

module count (Clock, Resetn, E, Q);
    parameter n = 8;
    input Clock, Resetn, E;
    output reg [n-1:0] Q;

    always @ (posedge Clock)
        if (Resetn == 0)
            Q <= 0;
        else if (E)
                Q <= Q + 1;
endmodule

module hex7seg (hex, display);
    input [3:0] hex;
    output [6:0] display;

    reg [6:0] display;
    always @ (hex)
        case (hex)
            4'h0: display = 7'b1000000;
            4'h1: display = 7'b1111001;
            4'h2: display = 7'b0100100;
            4'h3: display = 7'b0110000;
            4'h4: display = 7'b0011001;
            4'h5: display = 7'b0010010;
            4'h6: display = 7'b0000010;
            4'h7: display = 7'b1111000;
            4'h8: display = 7'b0000000;
            4'h9: display = 7'b0011000;
            4'hA: display = 7'b0001000;
            4'hB: display = 7'b0000011;
            4'hC: display = 7'b1000110;
            4'hD: display = 7'b0100001;
            4'hE: display = 7'b0000110;
            4'hF: display = 7'b0001110;
        endcase
endmodule


module object_mem (address, clock, data);

	input [9:0] address;
	input clock;
	output [7:0] data;

	assign data = 8'hee;

endmodule


module delay_one_cycle #(parameter n = 8, parameter n_cycles = 1) (
    input clock, 
    input resetn,
    input [n-1:0] signal_in,
    output reg [n-1:0] signal_out
);

    // 定义一个移位寄存器，用于存储中间延迟值
    reg [n-1:0] shift_reg [n_cycles-1:0];
    integer i;

    always @(posedge clock) begin
        if (!resetn) begin
            // 复位移位寄存器和输出
            for (i = 0; i < n_cycles; i = i + 1) begin
                shift_reg[i] <= 0;
            end
            signal_out <= 0;
        end else begin
            // 在移位寄存器中依次传递数据
            shift_reg[0] <= signal_in;
            for (i = 1; i < n_cycles; i = i + 1) begin
                shift_reg[i] <= shift_reg[i-1];
            end
            // 输出延迟后的数据
            signal_out <= shift_reg[n_cycles-1];
        end
    end
endmodule



module game_coord_2_canvas_coord (game_x, game_y, canvas_x, canvas_y);

    input [5:0] game_x;
    input [4:0] game_y;
    output [8:0] canvas_x;
    output [7:0] canvas_y;

    assign canvas_x = game_x * 8;
    assign canvas_y = game_y * 8;

endmodule


module canvas_coord_2_mem_addr (canvas_x, canvas_y, mem_addr);

    input [8:0] canvas_x;
    input [7:0] canvas_y;
    output [16:0] mem_addr;

    assign mem_addr = canvas_x * 320 + canvas_y;

endmodule