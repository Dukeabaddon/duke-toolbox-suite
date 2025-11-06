import sys
import random
import msvcrt
import time
import os

class MatrixRain:
    def __init__(self):
        self.width = 120
        self.height = 30
        self.columns = []
        self.paused = False
        
        for i in range(self.width):
            self.columns.append({
                'y': random.randint(-self.height, 0),
                'speed': random.choice([1, 2, 3]),
                'length': random.randint(5, 25)
            })
    
    def get_random_char(self):
        chars = '01'
        return random.choice(chars)
    
    def render(self):
        os.system('cls' if os.name == 'nt' else 'clear')
        
        print('\033[92m' + '=' * 120 + '\033[0m')
        status = 'PAUSED' if self.paused else 'RUNNING'
        print('\033[92m  MATRIX RAIN - Status: {:<100}\033[0m'.format(status))
        print('\033[92m' + '=' * 120 + '\033[0m')
        print('\033[92m  [0] Back    [1] {:<100}\033[0m'.format('Resume' if self.paused else 'Pause'))
        print('\033[92m' + '=' * 120 + '\033[0m')
        print()
        
        buffer = [[' ' for _ in range(self.width)] for _ in range(self.height)]
        
        for x in range(self.width):
            col = self.columns[x]
            y = col['y']
            length = col['length']
            
            for i in range(length):
                char_y = y - i
                if 0 <= char_y < self.height:
                    if i == 0:
                        buffer[char_y][x] = '\033[97m' + self.get_random_char() + '\033[0m'
                    elif i < length // 3:
                        buffer[char_y][x] = '\033[92m' + self.get_random_char() + '\033[0m'
                    else:
                        buffer[char_y][x] = '\033[32m' + self.get_random_char() + '\033[0m'
        
        for row in buffer:
            for cell in row:
                print(cell if '\033' in cell else ' ', end='')
            print()
    
    def update(self):
        if not self.paused:
            for col in self.columns:
                col['y'] += col['speed']
                if col['y'] - col['length'] > self.height:
                    col['y'] = random.randint(-20, -5)
                    col['speed'] = random.choice([1, 2, 3])
                    col['length'] = random.randint(5, 25)
    
    def run(self):
        while True:
            self.render()
            
            if msvcrt.kbhit():
                key = msvcrt.getch().decode('utf-8').lower()
                if key == '0':
                    break
                elif key == '1':
                    self.paused = not self.paused
            
            self.update()
            time.sleep(0.05)
        
        os.system('cls' if os.name == 'nt' else 'clear')
        sys.exit(0)

if __name__ == '__main__':
    try:
        matrix = MatrixRain()
        matrix.run()
    except KeyboardInterrupt:
        print('\n\n  Matrix interrupted.')
        sys.exit(0)
