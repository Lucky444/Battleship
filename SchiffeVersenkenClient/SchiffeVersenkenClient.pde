Grid grid = null;
PlayGrid playGrid = null;
readyButton rB = new readyButton(20, 440, 200, 50, #7bed9f, #2ed573);

Ship[] ships = new Ship[] {new Ship(0), new Ship(0), new Ship(0), new Ship(0), new Ship(1), new Ship(1), new Ship(1), new Ship(2), new Ship(2), new Ship(3)};
color[] shipcolors = new color[]{#2f3542, #3742fa, #ff4757, #2ed573};

void setup() {
  
  connect();
  
  size(799, 500);

  int min = min(width, height);
  grid = new Grid(10, 10, min / 15, 2);
  playGrid = new PlayGrid(10, 10, min/15, 2, (grid.cellSize + grid.cellMargin + 10) * 10);

  initShips(ships, grid);
}

void draw() {
  
  handleData();
  
  background(#ffffff);
  if (!GameGoing) {
    rB.show();
    renderUI();
  }
  grid.show();
  playGrid.show();
}

void mousePressed() {
  if (!GameGoing) {
    rB.Input();
    grid.handleInput();
  }
  else{
     if(myTurn){
        playGrid.HandleInput();
     }
  }
}
