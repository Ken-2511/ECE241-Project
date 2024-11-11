/*
*   Displays a pattern, which is read from a small memory, at (x,y) on the VGA output.
*   To set coordinates, first place the desired value of y onto SW[6:0] and press KEY[1].
*   Next, place the desired value of x onto SW[7:0] and then press KEY[2]. The (x,y)
*   coordinates are displayed (in hexadecimal) on (HEX3-2,HEX1-0). Finally, press KEY[3]
*   to draw the pattern at location (x,y).
*/
module milestone1(CLOCK_50, SW, KEY, HEX3, HEX2, HEX1, HEX0,
				VGA_R, VGA_G, VGA_B,
				VGA_HS, VGA_VS, VGA_BLANK_N, VGA_SYNC_N, VGA_CLK);
	
	input CLOCK_50;	
	input [7:0] SW;
	input [3:0] KEY;
    output [6:0] HEX3, HEX2, HEX1, HEX0;
	output [7:0] VGA_R;
	output [7:0] VGA_G;
	output [7:0] VGA_B;
	output VGA_HS;
	output VGA_VS;
	output VGA_BLANK_N;
	output VGA_SYNC_N;
	output VGA_CLK;

	wire [8:0] X;           // starting x location of object
	wire [7:0] Y;           // starting y location of object
	wire [8:0] VGA_X;       // x location of each object pixel
	wire [7:0] VGA_Y;       // y location of each object pixel
	wire [2:0] VGA_COLOR;   // color of each object pixel

	// store (x,y) starting location
    regn U1 (SW[6:0], KEY[0], ~KEY[1], CLOCK_50, Y);
        defparam U1.n = 8;
    regn U2 (SW[7:0], KEY[0], ~KEY[2], CLOCK_50, X);
        defparam U2.n = 9;

	draw_big_maze U3 (CLOCK_50, KEY[0], VGA_X, VGA_Y, VGA_COLOR, ~KEY[3]);

    hex7seg H3 (X[7:4], HEX3);
    hex7seg H2 (X[3:0], HEX2);
    hex7seg H1 ({1'b0, Y[6:4]}, HEX1);
    hex7seg H0 (Y[3:0], HEX0);

    assign plot = ~KEY[3];

    // connect to VGA controller
    vga_adapter VGA (
			.resetn(KEY[0]),
			.clock(CLOCK_50),
			.colour(VGA_COLOR),
			.x(VGA_X),
			.y(VGA_Y),
			.plot(~KEY[3]),
			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HS(VGA_HS),
			.VGA_VS(VGA_VS),
			.VGA_BLANK_N(VGA_BLANK_N),
			.VGA_SYNC_N(VGA_SYNC_N),
			.VGA_CLK(VGA_CLK));
		defparam VGA.RESOLUTION = "320x240";
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
		defparam VGA.BACKGROUND_IMAGE = "black.mif";
endmodule


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

module draw_big_maze(clock, resetn, vga_x, vga_y, color, enable);
	// draw a maze with blocks of 8x8 pixels

	input clock, resetn, enable;
	output reg [7:0] color;
	output reg [8:0] vga_x;
	output reg [7:0] vga_y;

	wire [4:0] maze_x;
	wire [3:0] maze_y;
	wire [7:0] maze_color;
	reg maze_enable;
	reg [3:0] dx, dy;

	parameter n = 8;

	always @ (posedge clock) begin
		if (!resetn) begin
			maze_enable <= 0;
			dx <= 0;
			dy <= 0;
			vga_x <= 0;
			vga_y <= 0;
			color <= 0;
		end
		else if (enable) begin
			// start drawing maze
			maze_enable <= 0;
			if (dx == 0 && dy == 0) begin
				maze_enable <= 1;
			end
			// update the position
			if (dx == n - 1) begin
				dx <= 0;
				if (dy == n - 1) begin
					dy <= 0;
				end
				else
					dy <= dy + 1;
			end
			else
				dx <= dx + 1;
			// update the VGA position
			vga_x <= maze_x * n + dx;
			vga_y <= maze_y * n + dy;
			// update the color
			color <= maze_color;
		end
	end

	draw_maze U1 (clock, resetn, maze_x, maze_y, maze_color, maze_enable);

endmodule

module draw_maze(clock, resetn, x, y, color, enable);
    input clock, resetn, enable;
    output reg [7:0] color;    // 将 `color` 声明为 `reg` 类型
    output reg [4:0] x;
	output reg [3:0] y;

    // 使用非打包数组实现二维结构
    reg [28:0] maze_data [12:0]; // 定义一个 13 行 29 列的迷宫

    parameter maze_width = 29;
    parameter maze_height = 13;

    // 初始化迷宫数据
    initial begin
        maze_data[0]  = 29'b11111111111111111111111111111;
        maze_data[1]  = 29'b10000000100000001000000100001;
        maze_data[2]  = 29'b10111110101111101011110101101;
        maze_data[3]  = 29'b10000000000000000000000000001;
        maze_data[4]  = 29'b10101110111011101110101010101;
        maze_data[5]  = 29'b10101000100010000010101010101;
        maze_data[6]  = 29'b10001110100011101110111010001;
        maze_data[7]  = 29'b10101000100010001000001010101;
        maze_data[8]  = 29'b10101110111011101110001010101;
        maze_data[9]  = 29'b10000000000000000000000000001;
        maze_data[10] = 29'b10111110101111101011110101101;
        maze_data[11] = 29'b10000000100000001000000100001;
        maze_data[12] = 29'b11111111111111111111111111111;
    end

    always @ (posedge clock) begin
        if (!resetn) begin
            x <= 0;
            y <= 0;
            color <= 8'h00; // 初始颜色设置为黑色
        end
        else if (enable) begin
            // 设置颜色，根据 maze_data 的值来确定
            if (maze_data[y] & (1 << (maze_width - x - 1)))
				color <= 8'o222; // 黑色
			else
                color <= 8'o777; // 白色

            // 更新位置坐标
            if (x == maze_width - 1) begin
                x <= 0;
                if (y == maze_height - 1)
                    y <= 0;
                else 
                    y <= y + 1;
            end
            else begin
                x <= x + 1;
            end
        end
    end
endmodule