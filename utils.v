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


module delay_n_cycle #(parameter n = 8, parameter n_cycles = 1) (
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


module delay_one_cycle #(parameter n = 8) (
    input clock, 
    input resetn,
    input [n-1:0] signal_in,
    output reg [n-1:0] signal_out
);

    always @(posedge clock or negedge resetn) begin
        if (!resetn)
            signal_out <= {n{1'b0}}; // Reset to all zeros
        else
            signal_out <= signal_in; // Delay signal by one clock cycle
    end

endmodule


module game_coord_2_canvas_coord (game_x, game_y, canvas_x, canvas_y);

    input [5:0] game_x;
    input [4:0] game_y;
    output [7:0] canvas_x;
    output [6:0] canvas_y;

    assign canvas_x = game_x * 5;
    assign canvas_y = game_y * 5;

endmodule


module canvas_coord_2_mem_addr (canvas_x, canvas_y, mem_addr);

    input [7:0] canvas_x;
    input [6:0] canvas_y;
    output [14:0] mem_addr;

    assign mem_addr = canvas_y * 160 + canvas_x;

endmodule

//half second counter
module half_sec_counter(clock, resetn, enable);
	input clock, resetn;
	output reg enable;
	reg [24:0] count;
	
	initial begin 
		count <= 25'b0;
		enable <= 1'b0;
	end 
	
	always @(posedge clock) begin
		if(!resetn) begin
			count <= 25'b0;
			enable <= 1'b0;
		end
		else if(count == 25000000) begin
			enable <= 1'b1;
			count <= 25'b0;
		end
		else begin
			enable <= 1'b0;
			count <= count + 1;
		end
	end
	
endmodule


module debounce_filter #(
    parameter n = 8,                 // 输入信号的位宽
    parameter THRESHOLD = 10,        // 连续稳定所需的周期数
    parameter COUNTER_WIDTH = $clog2(THRESHOLD) // 计数器的位宽
) (
    input wire clock,                // 时钟信号
    input wire resetn,               // 低电平复位
    input wire [n-1:0] A,            // 输入信号（需要去抖）
    output reg [n-1:0] B             // 输出信号（已稳定）
);

    reg [COUNTER_WIDTH-1:0] counter; // 计数器
    reg [n-1:0] prev_A;              // 记录前一个周期的 A 值

    always @(posedge clock or negedge resetn) begin
        if (!resetn) begin
            counter <= 0;
            prev_A <= {n{1'b0}}; // 初始化为全 0
            B <= {n{1'b0}};
        end else begin
            if (A == prev_A) begin
                // 输入信号与前一个周期的信号一致，计数器加 1
                if (counter < THRESHOLD - 1)
                    counter <= counter + 1;
            end else begin
                // 输入信号发生变化，计数器清零
                counter <= 0;
            end

            // 更新 prev_A 以便下一周期比较
            prev_A <= A;

            // 如果计数器达到门限值，则更新输出信号 B
            if (counter == THRESHOLD - 1)
                B <= A;
        end
    end
endmodule
