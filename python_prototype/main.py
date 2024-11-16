# this project is a simple game of Pac-Man. we use it to make a demo for the verilog project
# rules:
# 1. no classes
# 2. no dicts, sets, dynamic arrays
# 3. no recursion
# 4. no exceptions
# 5. no floats
# 6. no dynamic memory allocation
# 7. use a timer to control the game loop

import sys
import config
from config import *
from game_logic import update_position, eat_food, update_ghost_positions, update_ghost_directions, ghost_collision
from render import render_blocks, fill_screen, render_player, render_food, render_ghosts

modules = [
    update_position,
    eat_food,
    update_ghost_directions,
    update_ghost_positions,
    fill_screen,
    render_blocks,
    render_player,
    render_food,
    render_ghosts,
    ghost_collision
]

def simulate_modules():
    for module in modules:
        module()


# 事件处理函数
def handle_events():
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            config.exit_flag = True
            pygame.quit()
            sys.exit()
        if event.type == pygame.KEYDOWN:
            key = event.key
            if key == pygame.K_UP:
                config.player_dir = (0, -1)
            elif key == pygame.K_DOWN:
                config.player_dir = (0, 1)
            elif key == pygame.K_LEFT:
                config.player_dir = (-1, 0)
            elif key == pygame.K_RIGHT:
                config.player_dir = (1, 0)
            else:
                config.player_dir = (0, 0)
            print(f"changed direction to {config.player_dir}")


# 渲染函数
def render():
    pygame.display.flip()  # 更新屏幕


if __name__ == '__main__':
    # 主游戏循环
    import time
    last_time = time.time()
    while not config.exit_flag:
        handle_events()  # 处理事件
        simulate_modules()  # 模块模拟
        render()  # 渲染

        # 控制帧率
        CLOCK.tick(FPS)
        duration = time.time() - last_time
        last_time = time.time()

    pygame.quit()
    sys.exit()
