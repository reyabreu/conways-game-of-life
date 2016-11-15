private final static int sizeX = 400; //<>//
private final static int sizeY = 400;

private boolean[][] grid = new boolean[20][20]; 

void setup() {
  size(400, 400);
  frameRate(8);
  fillGrid();
}

void draw() {
  drawGrid();
  nextState();
}

void nextState() {

  class StateCalculator implements Processor {

    final boolean[][] tmpGrid = new boolean[20][20]; 

    public boolean[][] getGrid() {
      return tmpGrid;
    }

    public void process(int posX, int posY) {

      int x = posX/20;
      int y = posY/20;

      boolean state = grid[x][y];
      int neighbors = 0;

      for (int bY = y - 1; bY <= y + 1; bY++) {
        if (bY < 0 || bY >= 20) continue;
        for (int bX = x - 1; bX <= x + 1; bX++) {
          if (bX < 0 || (bY == y && bX == x) || bX >= 20) continue;
          if (grid[bX][bY]) {
            neighbors++;
          }
        }
      }


      if (state) {
        if (neighbors < 2 || neighbors > 3) { 
          state = false;
        }
      } else {
        if (neighbors == 3) {
          state = true;
        }
      }      

      tmpGrid[x][y] = state;
    }
  }

  final StateCalculator calc = new StateCalculator();
  traverseGrid(calc);
  grid = calc.getGrid();
}

void fillGrid() {
  class GridFiller implements Processor {
    public void process(int posX, int posY) {
      grid[posX/20][posY/20] = random(100) > 80;
    }
  }
  traverseGrid(new GridFiller());
}

void drawGrid() {
  background(85);
  noStroke();
  class GridDrawer implements Processor {
    public void process(int posX, int posY) {
      if (grid[posX/20][posY/20]) {
        fill(232);
      } else {
        noFill();
      }
      rect(posX, posY, 20, 20);
    }
  }
  traverseGrid(new GridDrawer());
}

void traverseGrid(Processor processor) {
  for (int tlY = 0; tlY < sizeY; tlY += 20) {  
    for (int tlX = 0; tlX < sizeX; tlX += 20) {
      processor.process(tlX, tlY);
    }
  }
}

interface Processor {
  void process(int posX, int posY);
}