class PlayGrid {
  int w, h;
  int cellSize = 20;
  int cellMargin = 0;
  int offset = 0;

  boolean setShip = false;

  PlayCell[][] grid;

  PlayCell hoveredCell = null;

  public PlayGrid(int w, int h, int size, int margin, int offset) {
    this.w = w;
    this.h = h;
    this.cellSize = size;
    this.cellMargin = margin;
    this.offset = offset;

    grid = new PlayCell[w][h];

    for (int y = 0; y < h; y ++) {
      for (int x = 0; x < w; x ++) {
        grid[x][y] = new PlayCell(x, y, this);
      }
    }
  }

  void show() {

    int yCoord = 0;

    for (int y = 0; y < h; y ++) {

      int xCoord = offset;

      for (int x = 0; x < w; x ++) {

        stroke(#2f3542);
        strokeWeight(cellMargin);

        //Check if hovered
        color c = color(#ffffff);

        switch(grid[x][y].display) {
          case(2):
          c = color(#ff6348);
          break;
          case(1):
          c = color(#70a1ff);
          break;
        }

        if (mouseX >= xCoord && mouseX <= xCoord + cellSize && mouseY >= yCoord && mouseY <= yCoord + cellSize && GameGoing && myTurn) {

          c = color(#747d8c);

          hoveredCell = grid[x][y];
        }

        fill(c);
        rect(xCoord, yCoord, cellSize, cellSize);

        xCoord += cellSize + cellMargin;
      }

      yCoord += cellSize + cellMargin;
    }
  }

  void HandleInput() {
    if (hoveredCell != null) {
      hoveredCell.display = 1;
      WritePacket(byte(2), new byte[]{byte(hoveredCell.x), byte(hoveredCell.y)});
    }
  }
}

class PlayCell {
  int x, y;
  PlayGrid grid;

  int display = 0;

  public PlayCell(int x, int y, PlayGrid grid) {
    this.x = x;
    this.y = y;
    this.grid = grid;
  }
}
