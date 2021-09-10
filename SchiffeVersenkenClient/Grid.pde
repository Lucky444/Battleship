class Grid {
  int w, h;
  int cellSize = 20;
  int cellMargin = 0;
  int maxShipLen = 3;

  Cell selectedCell = null;
  Cell sel2 = null;

  boolean setShip = false;

  Cell[][] grid;

  public Grid(int w, int h, int size, int margin) {
    this.w = w;
    this.h = h;
    this.cellSize = size;
    this.cellMargin = margin;

    grid = new Cell[w][h];

    for (int y = 0; y < h; y ++) {
      for (int x = 0; x < w; x ++) {
        grid[x][y] = new Cell(x, y, this);
      }
    }
  }

  void show() {

    int yCoord = 0;

    for (int y = 0; y < h; y ++) {

      int xCoord = 0;

      for (int x = 0; x < w; x ++) {

        stroke(#2f3542);
        strokeWeight(cellMargin);

        //Check if hovered
        color c = color(#ffffff);

        if (selectedCell != null && (x == selectedCell.pos.x || y == selectedCell.pos.y) && !GameGoing) {

          int distx = abs((int)selectedCell.pos.x - x);
          int disty = abs((int)selectedCell.pos.y - y);

          if (distx <= maxShipLen && disty <= maxShipLen) {
            c = color(#7bed9f);
          }
        }

        if (mouseX >= xCoord && mouseX <= xCoord + cellSize && mouseY >= yCoord && mouseY <= yCoord + cellSize && !GameGoing) {

          if (!setShip) {
            if (!grid[x][y].set) {
              selectedCell = grid[x][y];
            } else {
              selectedCell = null;
            }
          } else {
            sel2 = grid[x][y];
          }

          c = color(#747d8c);
        }

        if (grid[x][y].set)
        {
          if (grid[x][y].parent != null) {
            c = shipcolors[grid[x][y].parent.type];
          } else {
            c = color(#2f3542);
          }
        }

        fill(c);
        rect(xCoord, yCoord, cellSize, cellSize);

        if (grid[x][y].hit) {
          fill(#ffffff);
          noStroke();
          circle(xCoord + cellSize/2, yCoord + cellSize/2, 20);
        }

        xCoord += cellSize + cellMargin;
      }

      yCoord += cellSize + cellMargin;
    }
  }

  void handleInput() {

    if (mouseX < 0 || mouseX > (cellSize + cellMargin) * 10 || mouseY < 0 || mouseY > (cellSize + cellMargin) * 10) {
      return;
    }

    if (selectedCell == null)
      return;

    if (!setShip) {
      setShip = true;
      selectedCell.set = true;
    } else {
      setShip = false;

      int distx = abs((int)selectedCell.pos.x - (int)sel2.pos.x);
      int disty = abs((int)selectedCell.pos.y - (int)sel2.pos.y);

      Ship setTo = setShip(max(distx, disty));

      if ((distx != 0 && disty != 0) || setTo == null) {
        selectedCell.set = false;
        return;
      }

      if (distx <= maxShipLen && disty <= maxShipLen) {
        sel2.set = true;

        sel2.parent = setTo;
        selectedCell.parent = setTo;

        if (disty == 0) {

          int xS = min((int)selectedCell.pos.x, (int)sel2.pos.x);
          int xE = max((int)selectedCell.pos.x, (int)sel2.pos.x);

          for (int x = xS; x < xE; x++) {
            grid[x][(int)selectedCell.pos.y].set = true;
            grid[x][(int)selectedCell.pos.y].parent = setTo;
          }
        } else if (distx == 0) {

          int yS = min((int)selectedCell.pos.y, (int)sel2.pos.y);
          int yE = max((int)selectedCell.pos.y, (int)sel2.pos.y);

          for (int y = yS; y < yE; y++) {
            grid[(int)selectedCell.pos.x][y].set = true;
            grid[(int)selectedCell.pos.x][y].parent = setTo;
          }
        }
      } else {
        selectedCell.set = false;
      }
    }
  }
}

class Cell {
  Grid grid;
  boolean hit;
  PVector pos;
  boolean set = false;
  Ship parent;

  public Cell(int x, int y, Grid grid) {
    pos = new PVector(x, y);
    this.grid = grid;
  }
}

class Ship {
  int type = 0; //0 = Submarine | 1 = Frigate | 2 = Destroyer | 3 = Aircraft Carrier

  public Ship(int type) {
    this.type = type;
  }
}
