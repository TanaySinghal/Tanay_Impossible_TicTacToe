class EachBox {
  int n;
  int x, y;
  boolean over, cross = true, crossed, circled;

  EachBox(int num) {
    n = num;
    num ++;
    if (num <= 3) setBoxSize(num, 0);
    else if (num <= 6) setBoxSize(num, 3);
    else if (num <= 9) setBoxSize(num, 6);
  }

  void setBoxSize(int num, float a) {
    x = round(width/2 - boxSize*2 + boxSize*(num-a));
    y = round(height/2+50*min(width, height)/800-boxSize + boxSize*a/3);
    println(num + ": " + x);
  }

  void drawEachBox(boolean cross) {
    cross = crossTurn;
    if (!crossed && !circled && cross && over && mouseReleased) {
      crossed = true;
      mouseReleased = false;
    }
    drawBoard();
  }

  void active() {
    if (crossed) drawCross();
    if (circled) drawCircle();
  }

  void drawBoard() {
    rectCreator(color(255, 255, 220), x, y, boxSize, boxSize);
  }

  void drawCross() {
    line(x-boxSize/2.5, y-boxSize/2.5, x+boxSize/2.5, y+boxSize/2.5);
    line(x-boxSize/2.5, y+boxSize/2.5, x+boxSize/2.5, y-boxSize/2.5);
  }

  void drawCircle() {
    fill(255, 255, 220);
    ellipse(x, y, boxSize/1.25, boxSize/1.25);
    circled = true;
  }

  void checkIfOver() {
    if (overRect(x, y, boxSize, boxSize)) over = true;
    else over = false;
  }
}

