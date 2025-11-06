import sys
import random
import msvcrt
import time
import os

SHAPES = [
    [[1, 1, 1, 1]],
    [[1, 1], [1, 1]],
    [[1, 1, 1], [0, 1, 0]],
    [[1, 1, 1], [1, 0, 0]],
    [[1, 1, 1], [0, 0, 1]],
    [[1, 1, 0], [0, 1, 1]],
    [[0, 1, 1], [1, 1, 0]]
]

COLORS = ['\033[36m', '\033[33m', '\033[35m', '\033[32m', '\033[31m', '\033[34m', '\033[37m']

class Tetris:
    def __init__(self):
        self.width = 10
        self.height = 20
        self.board = [[0] * self.width for _ in range(self.height)]
        self.score = 0
        self.current_piece = None
        self.current_x = 0
        self.current_y = 0
        self.game_over = False
        self.spawn_piece()

    def spawn_piece(self):
        self.current_piece = [row[:] for row in random.choice(SHAPES)]
        self.current_color = random.choice(COLORS)
        self.current_x = self.width // 2 - len(self.current_piece[0]) // 2
        self.current_y = 0
        
        if self.check_collision(self.current_piece, self.current_x, self.current_y):
            self.game_over = True

    def check_collision(self, piece, x, y):
        for row_idx, row in enumerate(piece):
            for col_idx, cell in enumerate(row):
                if cell:
                    new_x = x + col_idx
                    new_y = y + row_idx
                    if new_x < 0 or new_x >= self.width or new_y >= self.height:
                        return True
                    if new_y >= 0 and self.board[new_y][new_x]:
                        return True
        return False

    def rotate_piece(self):
        rotated = [list(row) for row in zip(*self.current_piece[::-1])]
        if not self.check_collision(rotated, self.current_x, self.current_y):
            self.current_piece = rotated

    def move(self, dx):
        if not self.check_collision(self.current_piece, self.current_x + dx, self.current_y):
            self.current_x += dx

    def drop(self):
        if not self.check_collision(self.current_piece, self.current_x, self.current_y + 1):
            self.current_y += 1
            return False
        else:
            self.lock_piece()
            return True

    def lock_piece(self):
        for row_idx, row in enumerate(self.current_piece):
            for col_idx, cell in enumerate(row):
                if cell:
                    self.board[self.current_y + row_idx][self.current_x + col_idx] = self.current_color
        self.clear_lines()
        self.spawn_piece()

    def clear_lines(self):
        lines_cleared = 0
        for row_idx in range(self.height - 1, -1, -1):
            if all(self.board[row_idx]):
                del self.board[row_idx]
                self.board.insert(0, [0] * self.width)
                lines_cleared += 1
        self.score += lines_cleared * 100

    def render(self):
        os.system('cls' if os.name == 'nt' else 'clear')
        print('\033[96m' + '=' * 44 + '\033[0m')
        print('\033[96m' + '  TETRIS - Score: {}'.format(self.score).ljust(43) + '\033[0m')
        print('\033[96m' + '=' * 44 + '\033[0m')
        print()
        
        display = [row[:] for row in self.board]
        for row_idx, row in enumerate(self.current_piece):
            for col_idx, cell in enumerate(row):
                if cell:
                    y = self.current_y + row_idx
                    x = self.current_x + col_idx
                    if 0 <= y < self.height and 0 <= x < self.width:
                        display[y][x] = self.current_color
        
        for row in display:
            print('  |', end='')
            for cell in row:
                if cell:
                    print(cell + '#' + '\033[0m', end='')
                else:
                    print(' ', end='')
            print('|')
        
        print('  +' + '-' * self.width + '+')
        print()
        print('\033[97m  [A/D] Move  [W] Rotate  [S] Drop  [Q] Quit\033[0m')

def main():
    game = Tetris()
    last_drop = time.time()
    drop_speed = 0.5
    
    while not game.game_over:
        game.render()
        
        if time.time() - last_drop > drop_speed:
            game.drop()
            last_drop = time.time()
        
        if msvcrt.kbhit():
            key = msvcrt.getch().decode('utf-8').lower()
            if key == 'a':
                game.move(-1)
            elif key == 'd':
                game.move(1)
            elif key == 'w':
                game.rotate_piece()
            elif key == 's':
                while not game.drop():
                    pass
            elif key == 'q':
                break
        
        time.sleep(0.25)
    
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
