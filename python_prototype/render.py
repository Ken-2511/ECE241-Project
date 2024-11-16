import config
from config import *


def render_blocks():
    for i in range(0, 29):
        for j in range(0, 13):
            if BLOCK_ARRAY[j][i] == 0:
                pygame.draw.rect(SCREEN,
                                 (255, 255, 255),
                                 (i * BLOCK_SIZE, j * BLOCK_SIZE, BLOCK_SIZE, BLOCK_SIZE))


def fill_screen():
    SCREEN.fill((0, 0, 0))


def render_player():
    pygame.draw.circle(SCREEN, (255, 0, 0), (config.player_pos[0] * BLOCK_SIZE + BLOCK_SIZE // 2,
                                             config.player_pos[1] * BLOCK_SIZE + BLOCK_SIZE // 2), 10)


def render_food():
    food_size = 5
    for i in range(0, 29):
        for j in range(0, 13):
            if config.food_array[j][i] == 1:
                pygame.draw.rect(SCREEN,
                                 (100, 100, 0),
                                 (i * BLOCK_SIZE + BLOCK_SIZE // 2 - food_size // 2,
                                  j * BLOCK_SIZE + BLOCK_SIZE // 2 - food_size // 2,
                                  food_size, food_size))


def render_ghosts():
    ghost_size = 10
    for i in range(config.num_ghosts):
        pygame.draw.circle(SCREEN, (0, 255, 255), (config.ghost_pos[i][0] * BLOCK_SIZE + BLOCK_SIZE // 2,
                                                   config.ghost_pos[i][1] * BLOCK_SIZE + BLOCK_SIZE // 2), ghost_size)