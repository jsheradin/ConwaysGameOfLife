# ConwaysGameOfLife

### About
This is an implementation of Conway's game of life in Processing following the four rules:

1. Any live cell with fewer than two live neighbours dies, as if caused by under-population.
2. Any live cell with two or three live neighbours lives on to the next generation.
3. Any live cell with more than three live neighbours dies, as if by over-population.
4. Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.


### Controls
- ENTER: Play/Pause
- SHIFT: Seed random cells into the grid
- BACKSPACE: Kill/clear all cells on the grid
- Left Click: Toggle clicked cell alive or dead

### Additional Info
- Game starts paused with no living cells
- Cell detection wraps around to other side of screen if on edge (Pacman style).
- Runs in Processing 2.2.1
