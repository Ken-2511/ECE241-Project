import config
import random
from config import *


def update_position():
    new_pos = (config.player_pos[0] + config.player_dir[0], config.player_pos[1] + config.player_dir[1])
    if config.BLOCK_ARRAY[new_pos[1]][new_pos[0]] == 0:
        config.player_pos = new_pos


def eat_food():
    player_pos = config.player_pos
    if config.food_array[player_pos[1]][player_pos[0]] == 1:
        config.food_array[player_pos[1]][player_pos[0]] = 0


def update_ghost_positions():
    for i in range(config.num_ghosts):
        new_pos = (config.ghost_pos[i][0] + config.ghost_dir[i][0], config.ghost_pos[i][1] + config.ghost_dir[i][1])
        if config.BLOCK_ARRAY[new_pos[1]][new_pos[0]] == 0:
            config.ghost_pos[i] = new_pos


def update_ghost_directions():
    for i in range(config.num_ghosts):
        # when the ghost is blocked on the front, left, and right, it will turn back
        ghost_pos = config.ghost_pos[i]
        ghost_dir = config.ghost_dir[i]
        front_pos = (ghost_pos[0] + ghost_dir[0], ghost_pos[1] + ghost_dir[1])
        left_dir = (-ghost_dir[1], ghost_dir[0])
        left_pos = (ghost_pos[0] + left_dir[0], ghost_pos[1] + left_dir[1])
        right_dir = (ghost_dir[1], -ghost_dir[0])
        right_pos = (ghost_pos[0] + right_dir[0], ghost_pos[1] + right_dir[1])
        if config.BLOCK_ARRAY[front_pos[1]][front_pos[0]] == 1 and \
                config.BLOCK_ARRAY[left_pos[1]][left_pos[0]] == 1 and \
                config.BLOCK_ARRAY[right_pos[1]][right_pos[0]] == 1:
            config.ghost_dir[i] = (-ghost_dir[0], -ghost_dir[1])
        # when the ghost has a choice, it will randomly choose a direction
        else:
            choices = []
            if config.BLOCK_ARRAY[front_pos[1]][front_pos[0]] == 0:
                choices.append(ghost_dir)
            if config.BLOCK_ARRAY[left_pos[1]][left_pos[0]] == 0:
                choices.append(left_dir)
            if config.BLOCK_ARRAY[right_pos[1]][right_pos[0]] == 0:
                choices.append(right_dir)
            config.ghost_dir[i] = random.choice(choices)


def ghost_collision():
    for i in range(config.num_ghosts):
        ghost_pos = config.ghost_pos[i]
        ghost_dir = config.ghost_dir[i]
        if config.player_pos == ghost_pos:
            config.exit_flag = True
            return
        # also if the ghost has crossed the player, the game ends
        ghost_last_pos = (ghost_pos[0] - ghost_dir[0], ghost_pos[1] - ghost_dir[1])
        player_last_pos = (config.player_pos[0] - config.player_dir[0], config.player_pos[1] - config.player_dir[1])
        if ghost_last_pos == config.player_pos and player_last_pos == ghost_pos:
            config.exit_flag = True
            return