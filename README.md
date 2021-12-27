# mips-maze-game
Project for the course Computer Systems and Architecture, first bachelor at the University of Antwerp.

# Details
The game is completely writting in the MIPS-assembly language and tested with the Mars software. New levels can be created by simply constructing it in a \*.txt file and using the following characters:<br/> <br/>
**WALL : w <br/>
PASSAGE : p <br/>
PLAYER : s <br/>
EXIT : u <br/>
CANDY : c**

# Display
The **bitmap display tool** of Mars can be used to display the maze. The display-width and display-height for one pixel must be set to ```16px``` each. The dimensions of the bitmap display must be set to ```512 x 512```. The base address of the display is the global stack-pointer or the register ```$gp```.

# Keyboard Inputs
For keyboard inputs we use the **Keyboard and Display MMIO Simulator tool**.
