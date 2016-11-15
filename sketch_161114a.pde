private final static int sizeX = 400; //<>//
private final static int sizeY = 400;

private boolean[][] state = new boolean[40][40]; 

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

    final boolean[][] newState = new boolean[40][40]; 

    public boolean[][] getNewState() {
      return newState;
    }

    public void process(int posX, int posY) {

      int x = posX/10;
      int y = posY/10;

      int neighbors = 0;

      for (int bY = y - 1; bY <= y + 1; bY++) {
        if (bY < 0 || bY >= 40) continue;
        for (int bX = x - 1; bX <= x + 1; bX++) {
          if (bX < 0 || (bY == y && bX == x) || bX >= 40) continue;
          if (state[bX][bY]) {
            neighbors++;
          }
        }
      }  
      //conway's cell life rules
      newState[x][y] =  state[x][y] ? neighbors == 2 || neighbors == 3 : neighbors == 3;
    }
  }

  final StateCalculator calc = new StateCalculator();
  traverseGrid(calc);
  state = calc.getNewState();
}

void fillGrid() {
  class GridFiller implements Processor {
    public void process(int posX, int posY) {
      state[posX/10][posY/10] = random(100) > 80;
    }
  }
  traverseGrid(new GridFiller());
}

void drawGrid() {
  background(85);
  noStroke();
  class GridDrawer implements Processor {
    public void process(int posX, int posY) {
      if (state[posX/10][posY/10]) {
        fill(232);
      } else {
        noFill();
      }
      rect(posX, posY, 10, 10);
    }
  }
  traverseGrid(new GridDrawer());
}

void traverseGrid(Processor processor) {
  for (int tlY = 0; tlY < sizeY; tlY += 10) {  
    for (int tlX = 0; tlX < sizeX; tlX += 10) {
      processor.process(tlX, tlY);
    }
  }
}

interface Processor {
  void process(int posX, int posY);
}