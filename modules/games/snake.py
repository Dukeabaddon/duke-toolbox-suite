import sys
import random
import msvcrt
import time
import os

class Snake:
    def __init__(self):
        self.width = 40
        self.height = 20
        self.snake = [(self.width // 2, self.height // 2)]
        self.direction = (1, 0)
        self.food = self.spawn_food()
        self.score = 0
        self.game_over = False

    def spawn_food(self):
        while True:
            food = (random.randint(0, self.width - 1), random.randint(0, self.height - 1))
            if food not in self.snake:
                return food

    def move(self):
        head_x, head_y = self.snake[0]
        dx, dy = self.direction
        new_head = (head_x + dx, head_y + dy)
        
        if (new_head[0] < 0 or new_head[0] >= self.width or 
            new_head[1] < 0 or new_head[1] >= self.height or
            new_head in self.snake):
            self.game_over = True
            return
        
        self.snake.insert(0, new_head)
        
        if new_head == self.food:
            self.score += 10
            self.food = self.spawn_food()
        else:
            self.snake.pop()

    def change_direction(self, new_direction):
        dx, dy = self.direction
        ndx, ndy = new_direction
        if (dx, dy) != (-ndx, -ndy):
            self.direction = new_direction

    def render(self):
        os.system('cls' if os.name == 'nt' else 'clear')
        print('\033[92m' + '=' * 84 + '\033[0m')
        print('\033[92m' + '  SNAKE GAME - Score: {}'.format(self.score).ljust(83) + '\033[0m')
        print('\033[92m' + '=' * 84 + '\033[0m')
        print()
        
        board = [[' ' for _ in range(self.width)] for _ in range(self.height)]
        
        for x, y in self.snake[1:]:
            board[y][x] = '\033[32mo\033[0m'
        
        head_x, head_y = self.snake[0]
        board[head_y][head_x] = '\033[92mO\033[0m'
        
        fx, fy = self.food
        board[fy][fx] = '\033[91m*\033[0m'
        
        print('  +' + '-' * self.width + '+')
        for row in board:
            print('  |', end='')
            for cell in row:
                print(cell if '\033' in cell else ' ', end='')
            print('|')
        print('  +' + '-' * self.width + '+')
        print()
        print('\033[97m  [W] Up  [S] Down  [A] Left  [D] Right  [Q] Quit\033[0m')

def main():
    game = Snake()
    last_move = time.time()
    move_speed = 0.2
    
    while not game.game_over:
        game.render()
        
        if time.time() - last_move > move_speed:
            game.move()
            last_move = time.time()
        
        if msvcrt.kbhit():
            key = msvcrt.getch().decode('utf-8').lower()
            if key == 'w':
                game.change_direction((0, -1))
            elif key == 's':
                game.change_direction((0, 1))
            elif key == 'a':
                game.change_direction((-1, 0))
            elif key == 'd':
                game.change_direction((1, 0))
            elif key == 'q':
                break
        
        time.sleep(0.15)
    
    os.system('cls' if os.name == 'nt' else 'clear')
    print('\033[91m')
    print('  +===========================================+')
    print('  |          GAME OVER!                       |')
    print('  |  Final Score: {:<27} |'.format(game.score))
    print('  +===========================================+')
    print('\033[0m')
    print('  [0] Back to Menu    [1] Play Again')
    print()
    
    while True:
        if msvcrt.kbhit():
            key = msvcrt.getch().decode('utf-8')
            if key == '0':
                sys.exit(0)
            elif key == '1':
                main()
                return

if __name__ == '__main__':
    try:
        main()
    except KeyboardInterrupt:
        print('\n\n  Game interrupted.')
        sys.exit(0)
