# MIPS Maze Game

## Overview
This project implements a maze-based game in MIPS Assembly. Inspired by Pac-Man, the user starts inside a maze and must find the exit. The game supports both manual navigation and an automated solution using a recursive Depth-First Search (DFS) algorithm. The project is designed to test various computer architecture principles and to enhance your skills in assembly language.

## Key Features
- **Manual Maze Navigation**: Move through the maze using the keyboard.
- **Automatic Maze Solver**: The game includes a feature where the program automatically finds the exit using the DFS algorithm.
- **Stack Frame Usage**: Functions are implemented using simplified stack frames compared to those covered in class. All arguments and return values are passed through registers.
- **Dynamic Maze Dimensions**: The maze format is not fixed, and the program dynamically determines the dimensions while reading the maze from a file.

## Requirements
- **MARS Simulator**: Use the provided [MARS4.5](#) simulator to run the project.
- **Bitmap Display Settings**:
  - Unit Width: 16
  - Unit Height: 16
  - Display Width: 512
  - Display Height: 256
  - Base Address: 0x10008000 (`$gp`)

## Files in the Project
- `project_basis.asm`: Contains the basic functionality where the player manually navigates through the maze.
- `input_large.txt`: The maze input file used for testing.
- `input_small.txt`: Smaller maze input file.
- **MIPS Exercises**:
  - Several `.asm` files to build foundational MIPS skills, such as reading keyboard input, handling bitmap displays, and file I/O.

## Running the Project
1. **Run the Game**:
   - Open `project_basis.asm` in MARS.
   - Adjust the path of the maze file.
   - Use the keyboard to navigate the player:
     - `z`: Move up
     - `s`: Move down
     - `q`: Move left
     - `d`: Move right
   - The game ends when the player reaches the exit.
