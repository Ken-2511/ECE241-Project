module m_renderer (
    input wire clock,               // 时钟信号
    input wire resetn,              // 低电平复位
    input wire enable,              // 启用渲染
    output reg finished,            // 渲染完成标志

    // VGA 输出
    output reg [7:0] VGA_X,         // VGA x 坐标
    output reg [6:0] VGA_Y,         // VGA y 坐标
    output reg [2:0] VGA_COLOR,     // VGA 颜色输出

    // 背景
    input wire [2:0] bg_color,

    // 玩家
    input wire [4:0] pl_game_x,
    input wire [3:0] pl_game_y,
    input wire [2:0] pl_color,

    // 幽灵
    input wire [4:0] g1_game_x,
    input wire [3:0] g1_game_y,
    input wire [4:0] g2_game_x,
    input wire [3:0] g2_game_y,
    input wire [4:0] g3_game_x,
    input wire [3:0] g3_game_y
);

    // 状态编码
    parameter IDLE = 3'b000, ERASE = 3'b001, DRAW = 3'b010, DONE = 3'b011;
    reg [2:0] state, next_state;

    // 渲染变量
    reg [4:0] curr_x, curr_y;       // 当前渲染的逻辑坐标
    reg [3:0] dx, dy;               // 块内的偏移量

    // 渲染目标索引
    reg [1:0] render_index;         // 0: 玩家，1: 幽灵 1，2: 幽灵 2，3: 幽灵 3

    // 状态转换逻辑
    always @(posedge clock or negedge resetn) begin
        if (!resetn)
            state <= IDLE;
        else if (enable)
            state <= next_state;
    end

    // 下一状态逻辑
    always @(*) begin
        case (state)
            IDLE: 
                next_state = ERASE;
            ERASE: 
                next_state = (render_index == 3 && dx == 4 && dy == 4) ? DRAW : ERASE;
            DRAW: 
                next_state = (render_index == 3 && dx == 4 && dy == 4) ? DONE : DRAW;
            DONE: 
                next_state = IDLE;
            default: 
                next_state = IDLE;
        endcase
    end

    // VGA 渲染逻辑
    always @(posedge clock or negedge resetn) begin
        if (!resetn) begin
            // 初始化
            VGA_X <= 0;
            VGA_Y <= 0;
            VGA_COLOR <= 0;
            dx <= 0;
            dy <= 0;
            render_index <= 0;
            finished <= 0;
        end else if (enable) begin
            case (state)
                ERASE: begin
                    // 根据 render_index 确定当前对象的坐标
                    {curr_x, curr_y} <= (render_index == 0) ? {pl_game_x, pl_game_y} :
                                        (render_index == 1) ? {g1_game_x, g1_game_y} :
                                        (render_index == 2) ? {g2_game_x, g2_game_y} : {g3_game_x, g3_game_y};

                    // 输出背景颜色
                    VGA_X <= curr_x * 5 + dx;
                    VGA_Y <= curr_y * 5 + dy;
                    VGA_COLOR <= bg_color;

                    if (dx < 4)
                        dx <= dx + 1;
                    else if (dy < 4) begin
                        dx <= 0;
                        dy <= dy + 1;
                    end else begin
                        dx <= 0;
                        dy <= 0;
                        if (render_index < 3)
                            render_index <= render_index + 1;
                        else
                            render_index <= 0;
                    end
                end

                DRAW: begin
                    // 绘制玩家或幽灵
                    VGA_X <= curr_x * 5 + dx;
                    VGA_Y <= curr_y * 5 + dy;
                    VGA_COLOR <= (render_index == 0) ? pl_color : 3'b110; // 假定幽灵为固定颜色

                    if (dx < 4)
                        dx <= dx + 1;
                    else if (dy < 4) begin
                        dx <= 0;
                        dy <= dy + 1;
                    end else begin
                        dx <= 0;
                        dy <= 0;
                        if (render_index < 3)
                            render_index <= render_index + 1;
                        else
                            render_index <= 0;
                    end
                end

                DONE: begin
                    finished <= 1;
                end
            endcase
        end else begin
            finished <= 0;
        end
    end

endmodule
