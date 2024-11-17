module fsm_game_state(
    clock,
    resetn,
    enable,
    key3,
    data,
    addr,
    wren,
    q,
    VGA_X,      // 新增输出
    VGA_Y,      // 新增输出
    VGA_COLOR   // 新增输出
);

    // 基本输入
    input clock, resetn, enable;
    input key3;

    // 输出用于RAM控制
    output reg [2:0] data;
    output reg [16:0] addr;
    output reg wren;
    input [2:0] q;

    // 新增输出用于VGA
    output reg [8:0] VGA_X;
    output reg [7:0] VGA_Y;
    output reg [2:0] VGA_COLOR;

    // 状态编码
    parameter GREETING = 2'b00, PLAYING = 2'b01, GAME_OVER = 2'b10;

    // 状态寄存器
    reg [1:0] next_game_state, game_state;

    // 使能信号
    reg e_greeting, e_playing, e_game_over;

    // 完成信号
    wire f_greeting, f_playing, f_game_over;

    // 来自子模块的数据控制线
    wire [2:0] dt_greeting, dt_playing, dt_game_over;
    wire [16:0] ad_greeting, ad_playing, ad_game_over;
    wire wr_greeting, wr_playing, wr_game_over;

    // 来自子模块的VGA控制线
    wire [8:0] vga_x_greeting, vga_x_playing, vga_x_game_over;
    wire [7:0] vga_y_greeting, vga_y_playing, vga_y_game_over;
    wire [2:0] vga_color_greeting, vga_color_playing, vga_color_game_over;

    // 状态转移逻辑
    always @ (posedge clock) begin
        if (!resetn)
            game_state <= GREETING;  // 复位到初始状态
        else if (enable)
            game_state <= next_game_state;  // 若使能则转移到下一个状态
    end

    // 下一个状态逻辑
    always @ (*) begin
        case (game_state)
            GREETING: begin
                if (f_greeting)
                    next_game_state = PLAYING;  // 当GREETING完成时转移到PLAYING
                else
                    next_game_state = GREETING; // 否则保持在GREETING
            end
            PLAYING: begin
                if (f_playing)
                    next_game_state = GAME_OVER;  // 当PLAYING完成时转移到GAME_OVER
                else
                    next_game_state = PLAYING;   // 否则保持在PLAYING
            end
            GAME_OVER: begin
                if (f_game_over)
                    next_game_state = GREETING;  // 当GAME_OVER完成时循环回GREETING
                else
                    next_game_state = GAME_OVER; // 否则保持在GAME_OVER
            end
            default: next_game_state = GREETING; // 默认状态为GREETING
        endcase
    end

    // 输出逻辑
    always @ (*) begin
        e_greeting = (game_state == GREETING);
        e_playing = (game_state == PLAYING);
        e_game_over = (game_state == GAME_OVER);
        case (game_state)
            GREETING: begin
                data = dt_greeting;
                addr = ad_greeting;
                wren = wr_greeting;
                VGA_X = vga_x_greeting;
                VGA_Y = vga_y_greeting;
                VGA_COLOR = vga_color_greeting;
            end
            PLAYING: begin
                data = dt_playing;
                addr = ad_playing;
                wren = wr_playing;
                VGA_X = vga_x_playing;
                VGA_Y = vga_y_playing;
                VGA_COLOR = vga_color_playing;
            end
            GAME_OVER: begin
                data = dt_game_over;
                addr = ad_game_over;
                wren = wr_game_over;
                VGA_X = vga_x_game_over;
                VGA_Y = vga_y_game_over;
                VGA_COLOR = vga_color_game_over;
            end
            default: begin
                data = 3'b000;
                addr = 17'b0;
                wren = 1'b0;
                VGA_X = 9'b0;
                VGA_Y = 8'b0;
                VGA_COLOR = 3'b0;
            end
        endcase
    end

    // 子模块实例化并连接VGA信号
    m_greeting m_greeting_inst(
        .clock(clock),
        .resetn(resetn),
        .enable(e_greeting),
        .finished(f_greeting),
        .data(dt_greeting),
        .addr(ad_greeting),
        .wren(wr_greeting)
    );

    m_playing m_playing_inst(
        .clock(clock),
        .resetn(resetn),
        .enable(e_playing),
        .finished(f_playing),
        .data(dt_playing),
        .addr(ad_playing),
        .wren(wr_playing),
        .q(q),
        .VGA_X(vga_x_playing),
        .VGA_Y(vga_y_playing),
        .VGA_COLOR(vga_color_playing)
    );

    m_game_over m_game_over_inst(
        .clock(clock),
        .resetn(resetn),
        .enable(e_game_over),
        .finished(f_game_over),
        .data(dt_game_over),
        .addr(ad_game_over),
        .wren(wr_game_over)
    );

endmodule


module m_playing(
    clock,
    resetn,
    enable,
    finished,
    data,
    addr,
    wren,
    q,
    VGA_X,      // 新增输出
    VGA_Y,      // 新增输出
    VGA_COLOR   // 新增输出
);

    // 基本输入
    input clock, resetn, enable;

    // 输出
    output reg finished;
    output reg [2:0] data;
    output reg [16:0] addr;
    output reg wren;
    input [2:0] q;

    // 新增输出用于VGA
    output reg [8:0] VGA_X;
    output reg [7:0] VGA_Y;
    output reg [2:0] VGA_COLOR;

    // 状态编码
    parameter IDLE = 4'b0000, CLEAR_SCREEN = 4'b0001, UPDATE_POSITION = 4'b0010, EAT_FOOD = 4'b0011;
    parameter UPDATE_GHOST_DIRECTIONS = 4'b0100, UPDATE_GHOST_POSITIONS = 4'b0101, FILL_SCREEN = 4'b0110;
    parameter RENDER_BLOCKS = 4'b0111, RENDER_PLAYER = 4'b1000, RENDER_FOOD = 4'b1001, RENDER_GHOSTS = 4'b1010;
    parameter GHOST_COLLISION = 4'b1011, UPDATE_VGA = 4'b1100, GAME_OVER = 4'b1101;

    // 状态寄存器
    reg [3:0] game_state;
    reg [3:0] next_game_state;

    // 使能信号
    reg e_clear_screen, e_update_position, e_eat_food, e_update_ghost_directions, e_update_ghost_positions;
    reg e_fill_screen, e_render_blocks, e_render_player, e_render_food, e_render_ghosts, e_ghost_collision, e_update_vga;

    // 完成信号
    wire f_clear_screen, f_update_position, f_eat_food, f_update_ghost_directions, f_update_ghost_positions;
    wire f_fill_screen, f_render_blocks, f_render_player, f_render_food, f_render_ghosts, f_ghost_collision, f_update_vga;

    // 来自子模块的数据控制线
    wire [2:0] dt_clear_screen, dt_update_position, dt_eat_food, dt_update_ghost_directions, dt_update_ghost_positions;
    wire [2:0] dt_fill_screen, dt_render_blocks, dt_render_player, dt_render_food, dt_render_ghosts, dt_ghost_collision, dt_update_vga;
    wire [16:0] ad_clear_screen, ad_update_position, ad_eat_food, ad_update_ghost_directions, ad_update_ghost_positions;
    wire [16:0] ad_fill_screen, ad_render_blocks, ad_render_player, ad_render_food, ad_render_ghosts, ad_ghost_collision, ad_update_vga;
    wire wr_clear_screen, wr_update_position, wr_eat_food, wr_update_ghost_directions, wr_update_ghost_positions;
    wire wr_fill_screen, wr_render_blocks, wr_render_player, wr_render_food, wr_render_ghosts, wr_ghost_collision, wr_update_vga;

    // 来自子模块的VGA控制线
    wire [8:0] vga_x_clear_screen, vga_x_update_position, vga_x_eat_food, vga_x_update_ghost_directions, vga_x_update_ghost_positions;
    wire [8:0] vga_x_fill_screen, vga_x_render_blocks, vga_x_render_player, vga_x_render_food, vga_x_render_ghosts, vga_x_ghost_collision, vga_x_update_vga;
    wire [7:0] vga_y_clear_screen, vga_y_update_position, vga_y_eat_food, vga_y_update_ghost_directions, vga_y_update_ghost_positions;
    wire [7:0] vga_y_fill_screen, vga_y_render_blocks, vga_y_render_player, vga_y_render_food, vga_y_render_ghosts, vga_y_ghost_collision, vga_y_update_vga;
    wire [2:0] vga_color_clear_screen, vga_color_update_position, vga_color_eat_food, vga_color_update_ghost_directions, vga_color_update_ghost_positions;
    wire [2:0] vga_color_fill_screen, vga_color_render_blocks, vga_color_render_player, vga_color_render_food, vga_color_render_ghosts, vga_color_ghost_collision, vga_color_update_vga;

    // 状态转移逻辑
    always @ (posedge clock) begin
        if (!resetn)
            game_state <= IDLE;  // 复位到初始状态
        else if (enable)
            game_state <= next_game_state;  // 若使能则转移到下一个状态
    end

    // 下一个状态逻辑
    always @ (*) begin
        case (game_state)
            IDLE: begin
                next_game_state = CLEAR_SCREEN; // 立即转移到CLEAR_SCREEN
            end
            CLEAR_SCREEN: begin
                if (f_clear_screen)
                    next_game_state = UPDATE_POSITION;  // 当CLEAR_SCREEN完成时转移到UPDATE_POSITION
                else
                    next_game_state = CLEAR_SCREEN; // 否则保持在CLEAR_SCREEN
            end
            UPDATE_POSITION: begin
                if (f_update_position)
                    next_game_state = EAT_FOOD;  // 当UPDATE_POSITION完成时转移到EAT_FOOD
                else
                    next_game_state = UPDATE_POSITION; // 否则保持在UPDATE_POSITION
            end
            EAT_FOOD: begin
                if (f_eat_food)
                    next_game_state = UPDATE_GHOST_DIRECTIONS;  // 当EAT_FOOD完成时转移到UPDATE_GHOST_DIRECTIONS
                else
                    next_game_state = EAT_FOOD; // 否则保持在EAT_FOOD
            end
            UPDATE_GHOST_DIRECTIONS: begin
                if (f_update_ghost_directions)
                    next_game_state = UPDATE_GHOST_POSITIONS;  // 当UPDATE_GHOST_DIRECTIONS完成时转移到UPDATE_GHOST_POSITIONS
                else
                    next_game_state = UPDATE_GHOST_DIRECTIONS; // 否则保持在UPDATE_GHOST_DIRECTIONS
            end
            UPDATE_GHOST_POSITIONS: begin
                if (f_update_ghost_positions)
                    next_game_state = FILL_SCREEN;  // 当UPDATE_GHOST_POSITIONS完成时转移到FILL_SCREEN
                else
                    next_game_state = UPDATE_GHOST_POSITIONS; // 否则保持在UPDATE_GHOST_POSITIONS
            end
            FILL_SCREEN: begin
                if (f_fill_screen)
                    next_game_state = RENDER_BLOCKS;  // 当FILL_SCREEN完成时转移到RENDER_BLOCKS
                else
                    next_game_state = FILL_SCREEN; // 否则保持在FILL_SCREEN
            end
            RENDER_BLOCKS: begin
                if (f_render_blocks)
                    next_game_state = RENDER_PLAYER;  // 当RENDER_BLOCKS完成时转移到RENDER_PLAYER
                else
                    next_game_state = RENDER_BLOCKS; // 否则保持在RENDER_BLOCKS
            end
            RENDER_PLAYER: begin
                if (f_render_player)
                    next_game_state = RENDER_FOOD;  // 当RENDER_PLAYER完成时转移到RENDER_FOOD
                else
                    next_game_state = RENDER_PLAYER; // 否则保持在RENDER_PLAYER
            end
            RENDER_FOOD: begin
                if (f_render_food)
                    next_game_state = RENDER_GHOSTS;  // 当RENDER_FOOD完成时转移到RENDER_GHOSTS
                else
                    next_game_state = RENDER_FOOD; // 否则保持在RENDER_FOOD
            end
            RENDER_GHOSTS: begin
                if (f_render_ghosts)
                    next_game_state = GHOST_COLLISION;  // 当RENDER_GHOSTS完成时转移到GHOST_COLLISION
                else
                    next_game_state = RENDER_GHOSTS; // 否则保持在RENDER_GHOSTS
            end
            GHOST_COLLISION: begin
                if (f_ghost_collision)
                    next_game_state = UPDATE_VGA;  // 当GHOST_COLLISION完成时转移到UPDATE_VGA
                else
                    next_game_state = GHOST_COLLISION; // 否则保持在GHOST_COLLISION
            end
            UPDATE_VGA: begin
                if (f_update_vga)
                    next_game_state = GAME_OVER;  // 当UPDATE_VGA完成时转移到GAME_OVER
                else
                    next_game_state = UPDATE_VGA; // 否则保持在UPDATE_VGA
            end
            GAME_OVER: begin
                next_game_state = IDLE; // 立即转移回IDLE
            end
            default: next_game_state = CLEAR_SCREEN; // 默认状态为CLEAR_SCREEN
        endcase
    end

    // 输出逻辑
    always @ (*) begin
        e_clear_screen = (game_state == CLEAR_SCREEN);
        e_update_position = (game_state == UPDATE_POSITION);
        e_eat_food = (game_state == EAT_FOOD);
        e_update_ghost_directions = (game_state == UPDATE_GHOST_DIRECTIONS);
        e_update_ghost_positions = (game_state == UPDATE_GHOST_POSITIONS);
        e_fill_screen = (game_state == FILL_SCREEN);
        e_render_blocks = (game_state == RENDER_BLOCKS);
        e_render_player = (game_state == RENDER_PLAYER);
        e_render_food = (game_state == RENDER_FOOD);
        e_render_ghosts = (game_state == RENDER_GHOSTS);
        e_ghost_collision = (game_state == GHOST_COLLISION);
        e_update_vga = (game_state == UPDATE_VGA);
        finished = (game_state == GAME_OVER);  // 当处于GAME_OVER状态时设置完成标志

        case (game_state)
            CLEAR_SCREEN: begin
                data = dt_clear_screen;
                addr = ad_clear_screen;
                wren = wr_clear_screen;
                VGA_X = vga_x_clear_screen;
                VGA_Y = vga_y_clear_screen;
                VGA_COLOR = vga_color_clear_screen;
            end
            UPDATE_POSITION: begin
                data = dt_update_position;
                addr = ad_update_position;
                wren = wr_update_position;
                VGA_X = vga_x_update_position;
                VGA_Y = vga_y_update_position;
                VGA_COLOR = vga_color_update_position;
            end
            EAT_FOOD: begin
                data = dt_eat_food;
                addr = ad_eat_food;
                wren = wr_eat_food;
                VGA_X = vga_x_eat_food;
                VGA_Y = vga_y_eat_food;
                VGA_COLOR = vga_color_eat_food;
            end
            UPDATE_GHOST_DIRECTIONS: begin
                data = dt_update_ghost_directions;
                addr = ad_update_ghost_directions;
                wren = wr_update_ghost_directions;
                VGA_X = vga_x_update_ghost_directions;
                VGA_Y = vga_y_update_ghost_directions;
                VGA_COLOR = vga_color_update_ghost_directions;
            end
            UPDATE_GHOST_POSITIONS: begin
                data = dt_update_ghost_positions;
                addr = ad_update_ghost_positions;
                wren = wr_update_ghost_positions;
                VGA_X = vga_x_update_ghost_positions;
                VGA_Y = vga_y_update_ghost_positions;
                VGA_COLOR = vga_color_update_ghost_positions;
            end
            FILL_SCREEN: begin
                data = dt_fill_screen;
                addr = ad_fill_screen;
                wren = wr_fill_screen;
                VGA_X = vga_x_fill_screen;
                VGA_Y = vga_y_fill_screen;
                VGA_COLOR = vga_color_fill_screen;
            end
            RENDER_BLOCKS: begin
                data = dt_render_blocks;
                addr = ad_render_blocks;
                wren = wr_render_blocks;
                VGA_X = vga_x_render_blocks;
                VGA_Y = vga_y_render_blocks;
                VGA_COLOR = vga_color_render_blocks;
            end
            RENDER_PLAYER: begin
                data = dt_render_player;
                addr = ad_render_player;
                wren = wr_render_player;
                VGA_X = vga_x_render_player;
                VGA_Y = vga_y_render_player;
                VGA_COLOR = vga_color_render_player;
            end
            RENDER_FOOD: begin
                data = dt_render_food;
                addr = ad_render_food;
                wren = wr_render_food;
                VGA_X = vga_x_render_food;
                VGA_Y = vga_y_render_food;
                VGA_COLOR = vga_color_render_food;
            end
            RENDER_GHOSTS: begin
                data = dt_render_ghosts;
                addr = ad_render_ghosts;
                wren = wr_render_ghosts;
                VGA_X = vga_x_render_ghosts;
                VGA_Y = vga_y_render_ghosts;
                VGA_COLOR = vga_color_render_ghosts;
            end
            GHOST_COLLISION: begin
                data = dt_ghost_collision;
                addr = ad_ghost_collision;
                wren = wr_ghost_collision;
                VGA_X = vga_x_ghost_collision;
                VGA_Y = vga_y_ghost_collision;
                VGA_COLOR = vga_color_ghost_collision;
            end
            UPDATE_VGA: begin
                data = dt_update_vga;
                addr = ad_update_vga;
                wren = wr_update_vga;
                VGA_X = vga_x_update_vga;
                VGA_Y = vga_y_update_vga;
                VGA_COLOR = vga_color_update_vga;
            end
            default: begin
                data = 3'b000;
                addr = 17'b0;
                wren = 1'b0;
                VGA_X = 9'b0;
                VGA_Y = 8'b0;
                VGA_COLOR = 3'b0;
            end
        endcase
    end

    // 子模块实例化并连接VGA信号
    m_clear_screen m_clear_screen_inst(
        .clock(clock),
        .resetn(resetn),
        .enable(e_clear_screen),
        .wren(wr_clear_screen),
        .finished(f_clear_screen),
        .data(dt_clear_screen),
        .addr(ad_clear_screen)
    );

    m_update_position m_update_position_inst(
        .clock(clock),
        .resetn(resetn),
        .enable(e_update_position),
        .wren(wr_update_position),
        .finished(f_update_position),
        .data(dt_update_position),
        .addr(ad_update_position)
    );

    m_eat_food m_eat_food_inst(
        .clock(clock),
        .resetn(resetn),
        .enable(e_eat_food),
        .wren(wr_eat_food),
        .finished(f_eat_food),
        .data(dt_eat_food),
        .addr(ad_eat_food)
    );

    m_update_ghost_directions m_update_ghost_directions_inst(
        .clock(clock),
        .resetn(resetn),
        .enable(e_update_ghost_directions),
        .wren(wr_update_ghost_directions),
        .finished(f_update_ghost_directions),
        .data(dt_update_ghost_directions),
        .addr(ad_update_ghost_directions)
    );

    m_update_ghost_positions m_update_ghost_positions_inst(
        .clock(clock),
        .resetn(resetn),
        .enable(e_update_ghost_positions),
        .wren(wr_update_ghost_positions),
        .finished(f_update_ghost_positions),
        .data(dt_update_ghost_positions),
        .addr(ad_update_ghost_positions)
    );

    m_fill_screen m_fill_screen_inst(
        .clock(clock),
        .resetn(resetn),
        .enable(e_fill_screen),
        .wren(wr_fill_screen),
        .finished(f_fill_screen),
        .data(dt_fill_screen),
        .addr(ad_fill_screen)
    );

    m_render_blocks m_render_blocks_inst(
        .clock(clock),
        .resetn(resetn),
        .enable(e_render_blocks),
        .wren(wr_render_blocks),
        .finished(f_render_blocks),
        .data(dt_render_blocks),
        .addr(ad_render_blocks)
    );

    m_render_player m_render_player_inst(
        .clock(clock),
        .resetn(resetn),
        .enable(e_render_player),
        .wren(wr_render_player),
        .finished(f_render_player),
        .data(dt_render_player),
        .addr(ad_render_player)
    );

    m_render_food m_render_food_inst(
        .clock(clock),
        .resetn(resetn),
        .enable(e_render_food),
        .wren(wr_render_food),
        .finished(f_render_food),
        .data(dt_render_food),
        .addr(ad_render_food)
    );

    m_render_ghosts m_render_ghosts_inst(
        .clock(clock),
        .resetn(resetn),
        .enable(e_render_ghosts),
        .wren(wr_render_ghosts),
        .finished(f_render_ghosts),
        .data(dt_render_ghosts),
        .addr(ad_render_ghosts)
    );

    m_ghost_collision m_ghost_collision_inst(
        .clock(clock),
        .resetn(resetn),
        .enable(e_ghost_collision),
        .wren(wr_ghost_collision),
        .finished(f_ghost_collision),
        .data(dt_ghost_collision),
        .addr(ad_ghost_collision)
    );

    m_update_vga m_update_vga_inst(
        .clock(clock),
        .resetn(resetn),
        .enable(e_update_vga),
        .wren(wr_update_vga),
        .finished(f_update_vga),
        .data(dt_update_vga),
        .addr(ad_update_vga),
        .q(q),
        .VGA_X(vga_x_update_vga),      // 新增输出
        .VGA_Y(vga_y_update_vga),      // 新增输出
        .VGA_COLOR(vga_color_update_vga) // 新增输出
    );

endmodule
