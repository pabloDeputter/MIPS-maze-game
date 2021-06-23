# mips_maze_game
Maze game written with MIPS-assembly language, made in Mars MIPS simulator, created by Deputter Pablo.

# Display
The **bitmap display tool** of Mars can be used to display the maze. The display-width and display-height for one pixel must be set to ```16px``` each. The dimensions of the bitmap display must be set to ```512 x 512```. The base address of the display is the global stack-pointer or the register ```$gp```.

# Keyboard Inputs
For keyboard inputs we use the **Keyboard and Display MMIO Simulator tool**.
