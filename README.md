#conways-game-of-life
=====================

A small project in Processing that shows some of the functionality available to Java devs, by implementing Conway's famous cellular automata: The Game of Life.

## Automata's rules
Each cell is represented by a square on a grid. cells can be either 'alive' or 'dead', show by coloring (green is 'alive'). The future state or condition of each individual cell depends on the perifereal state of cells around itself. A low rate of screen refresh represnts the progression of time. 
If a cell is 'alive' it requires 2 or 3 live 'neighbors' to keep alive - otherwise it dies, either by under or over population. Empty locations (or 'dead' cells) can spring back to life if exactly neihgbored by 3 'live' cells.

## Features
This was written originally without referring to the example that is provided with processing itself, but some improvements that are on the example have been transported - namely: 
* Pausing and Restarting on SPACE bar tapping
* Only when Paused, Left click to enter 'edit' mode. Moving the mouse over the empty cells will spring them to life.

## Run the Simulation
Just run the program and enjoy the simulation of a randomly generated set.
