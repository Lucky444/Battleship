import java.util.Map;

HashMap<Integer, Integer> shipCounts = new HashMap<>();
ArrayList<Ship> toSet = new ArrayList<>();
int cellSize;

void initShips(Ship[] ships, Grid grid) {
  cellSize = grid.cellSize;

  for (Ship s : ships) {
    toSet.add(s);
    if (shipCounts.get(s.type) == null) {
      shipCounts.put(s.type, 0);
    }

    shipCounts.put(s.type, shipCounts.get(s.type) + 1);
  }
}

Ship getSet(int type) {
  Ship ret = null;
  for (Ship s : toSet) {
    if (s.type == type) {
      ret = s;
      break;
    }
  }

  if (ret != null)
    toSet.remove(ret);

  return ret;
}

void renderUI() {

  //Rendering ship display at start of round
  noStroke();

  int xCoord = 10;
  int maxLen = 0;
  for (Map.Entry me : shipCounts.entrySet()) {
    int len = (int)me.getKey();
    if (len > maxLen && (int)me.getValue() > 0) {
      maxLen = len;
    }

    int w = cellSize * (len + 1);

    fill(shipcolors[len]);

    rect(xCoord, 360, w, cellSize);
    textAlign(CENTER);
    textSize(30);
    text((int)me.getValue(), xCoord + w/2, 420);
    xCoord += w + 20;
  }

  grid.maxShipLen = maxLen;
}

Ship setShip(int len) {
  
  Ship ret = getSet(len);
  
  if (shipCounts.get(len) != null && ret != null) {
    shipCounts.put(len, shipCounts.get(len) - 1);
  }

  return ret;
}

class readyButton {
  int x, y;
  int w, h;
  boolean ready;
  color c;
  color hovered;
  String text = "NOT READY {p} / 2";
  int readyPeople = 0;

  public readyButton(int x, int y, int w, int h, color c, color hovered) {
    this.c = c;
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.hovered = hovered;
  }

  void show() {
    strokeWeight(2);
    stroke(#2f3542);

    color set = c;

    if (mouseX >= x && mouseX <= x + w && mouseY >= y && mouseY <= y + h) {
      set = hovered;
    }

    fill(set);
    rect(x, y, w, h);
    fill(#ffffff);
    textSize(23);
    textAlign(CENTER);
    text(text.replace("{p}",str(readyPeople)), x + w/2, y + h/2 + 10);
  }

  void Input() {
    if (mouseX >= x && mouseX <= x + w && mouseY >= y && mouseY <= y + h) {
      ready = !ready;
      text = ready ? "READY {p} / 2" : "NOT READY {p} / 2";
      WritePacket(byte(1), new byte[]{byte(ready)});
    }
  }
}
