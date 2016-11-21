private final static int gWidth = 640; //<>//
private final static int gHeight = 480;
private final static int cellSz = 5;
private final static char SPACE = ' ';

private boolean pause = false;
private boolean editMode = false;
private final color ALIVE = color(12, 237, 17);
private final color DEAD = color(112, 40, 70);
private boolean[][] state = new boolean[gWidth/cellSz][gHeight/cellSz]; 

void setup() {
  size(640, 480);
  frameRate(8);
  noSmooth();
  noStroke();  
  fillGrid();
}

void draw() {
  if (!pause) {
    drawGrid();
    nextState();
  }
}

void keyPressed() {
  if (keyCode == SPACE) {
    pause = !pause;
    editMode = false;
  }
}

void mouseMoved(){
  if (pause && editMode){
    int xCellOver = int(map(mouseX, 0, gWidth, 0, gWidth/cellSz));
    xCellOver = constrain(xCellOver, 0, gWidth/cellSz - 1);
    int yCellOver = int(map(mouseY, 0, gHeight, 0, gHeight/cellSz));
    yCellOver = constrain(yCellOver, 0, gHeight/cellSz - 1);
    
    state[xCellOver][yCellOver] = true;
    fill(ALIVE);
    rect(xCellOver*cellSz, yCellOver*cellSz, cellSz, cellSz);
  }
}

void mousePressed(){
  if (pause){
    if (mouseButton == LEFT){
       editMode = !editMode;
    }
  }
}

void nextState() {

  class StateCalculator implements Processor {

    final boolean[][] newState = new boolean[gWidth/cellSz][gHeight/cellSz]; 

    public boolean[][] getNewState() {
      return newState;
    }

    public void process(int posX, int posY) {

      int x = posX/cellSz;
      int y = posY/cellSz;

      int neighbors = 0;

      for (int bY = y - 1; bY <= y + 1; bY++) {
        if (bY < 0 || bY >= gHeight/cellSz) continue;
        for (int bX = x - 1; bX <= x + 1; bX++) {
          if (bX < 0 || (bY == y && bX == x) || bX >= gWidth/cellSz) continue;
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
      state[posX/cellSz][posY/cellSz] = random(100) > 80;
    }
  }
  traverseGrid(new GridFiller());
}

void drawGrid() {
  class GridDrawer implements Processor {
    public void process(int posX, int posY) {
      fill(state[posX/cellSz][posY/cellSz] ? ALIVE : DEAD);
      rect(posX, posY, cellSz, cellSz);
    }
  }
  traverseGrid(new GridDrawer());
}

void traverseGrid(Processor processor) {
  for (int tlY = 0; tlY < gHeight; tlY += cellSz) {  
    for (int tlX = 0; tlX < gWidth; tlX += cellSz) {
      processor.process(tlX, tlY);
    }
  }
}

interface Processor {
  void process(int posX, int posY);
}