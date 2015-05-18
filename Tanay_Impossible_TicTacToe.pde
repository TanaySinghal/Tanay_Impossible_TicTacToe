EachBox [] eachbox;
boolean crossTurn, aiTurn, mouseReleased, tied;
int howmany; //Total count of crosses/circles
int time, finalTime; //Delays AI
int boxSize, fps = 10;

float c; //Game over menu's color and delay increment

boolean aiTurnTimer; //check if timer for Ai's delay is on
boolean gameIsLive; //checks if game is being played

float radius;
void setup() {
  size(700, 700);
  fps = 30;
  frameRate(fps);

  rectMode(CENTER);
  textAlign(CENTER, CENTER);
  ellipseMode(RADIUS);
  strokeWeight(3);

  setup2();
}

void setup2 () {
  stroke(0);
  //Reset variables
  gameIsLive = true;
  crossTurn = true;
  aiTurnTimer = false;
  aiTurn = false;
  tied = false;
  time = 0;
  howmany = 0;
  boxSize = round(min(width, height)/4);
  radius = boxSize/2.5;
  c = 0;

  //Clean up background
  background(150, 225, 220);
  eachbox = new EachBox[9];

  for (int i = 0; i < 9; i ++) {
    eachbox[i] = new EachBox(i);
    eachbox[i].drawBoard();
  }
  textAtTop();
}

//Separate input/setup from what needs to be drawn constantly
void draw() {
  //draw doesn't loop after tying..

  //Not only checks gameover but also plays fade-in animation
  checkIfGameOver();
  
  //Delays AI's turn when it is Ai's turn
  if (aiTurnTimer && gameIsLive) {
    aiDelay();
  }

  //Uncomment to display lag info
  //checkFrameRate();
}

//Call method to check frame rate lag
void checkFrameRate() {
  noStroke();
  rectCreator(color(150, 225, 220), 100, 50, 80, 30);
  stroke(0);
  textCreator(15, color(0), "Lag: " + round(100-100*(frameRate)/fps) + " %", 100, 50);
}

void mousePressed() {

  //if the box is empty and the player plays, leave a cross there
  mouseReleased = true;

  for (int i = 0; i < 9; i ++) {
    if (boxIsEmpty(i) && crossTurn && eachbox[i].isUserHoveringOverBox() && mouseReleased && gameIsLive) {
      eachbox[i].drawCross();
      mouseReleased = false;
    }
  }
}

void mouseReleased() {
  mouseReleased = false;
}

void textAtTop() {
  textCreator(40, color(0), "Tic-Tac-Toe", width/2, 40);
  textCreator(20, color(255, 0, 0), "Impossible Difficulty", width/2, 75);
  textCreator(25, color(0), "By Tanay Singhal", width/2, 100);
}

void textCreator(int ts, color c, String s, float x, float y) {
  textSize(ts);
  fill(c);
  text(s, x, y);
}

void rectCreator(color c, float x, float y, float w, float h) {
  fill(c);
  rect(x, y, w, h);
}

void moveTo(int a) {
  //Put a circle in this position
  eachbox[a].drawCircle();
  aiTurn = false;
}

void startCorner() {
  //Only plays once
  //Randomly decides a corner to start from
  int r = round(random(3));
  int a = 0;
  if (r == 0) a = 0;
  else if (r == 1) a = 2;
  else if (r == 2) a = 6;
  else a = 8;
  //Put a circle in this position

  eachbox[a].drawCircle();
  aiTurn = false;
}

void aiFirstMove() {
  //Take the center if it is open
  if (bfwcro(4)) startCorner();
  else moveTo(4);
}

void aiMoves() {
  //Only runs once
  //ATTACK MOVES
  if (ccirclep(1, 2, 0)) moveTo(0);
  else if (ccirclep(0, 2, 1)) moveTo(1);
  else if (ccirclep(0, 1, 2)) moveTo(2);
  else if (ccirclep(4, 5, 3)) moveTo(3);
  else if (ccirclep(3, 5, 4)) moveTo(4);
  else if (ccirclep(3, 4, 5)) moveTo(5);
  else if (ccirclep(7, 8, 6)) moveTo(6);
  else if (ccirclep(6, 8, 7)) moveTo(7);
  else if (ccirclep(6, 7, 8)) moveTo(8);
  //done with hor
  else if (ccirclep(3, 6, 0)) moveTo(0);
  else if (ccirclep(4, 7, 1)) moveTo(1);
  else if (ccirclep(5, 8, 2)) moveTo(2);

  else if (ccirclep(0, 6, 3)) moveTo(3);
  else if (ccirclep(1, 7, 4)) moveTo(4);
  else if (ccirclep(2, 8, 5)) moveTo(5);

  else if (ccirclep(0, 3, 6)) moveTo(6);
  else if (ccirclep(1, 4, 7)) moveTo(7);
  else if (ccirclep(2, 5, 8)) moveTo(8);
  //done with vert
  else if (ccirclep(4, 8, 0)) moveTo(0);
  else if (ccirclep(6, 4, 2)) moveTo(2);
  else if (ccirclep(0, 8, 4)) moveTo(4); 
  else if (ccirclep(6, 2, 4)) moveTo(4);
  else if (ccirclep(2, 4, 6)) moveTo(6);
  else if (ccirclep(0, 4, 8)) moveTo(8);

  //DEFENSE MOVES
  else if (ccrossp(1, 2, 0)) moveTo(0);
  else if (ccrossp(0, 2, 1)) moveTo(1);
  else if (ccrossp(0, 1, 2)) moveTo(2);
  else if (ccrossp(4, 5, 3)) moveTo(3);
  else if (ccrossp(3, 5, 4)) moveTo(4);
  else if (ccrossp(3, 4, 5)) moveTo(5);
  else if (ccrossp(7, 8, 6)) moveTo(6);
  else if (ccrossp(6, 8, 7)) moveTo(7);
  else if (ccrossp(6, 7, 8)) moveTo(8);
  //done with hor
  else if (ccrossp(3, 6, 0)) moveTo(0);
  else if (ccrossp(4, 7, 1)) moveTo(1);
  else if (ccrossp(5, 8, 2)) moveTo(2);

  else if (ccrossp(0, 6, 3)) moveTo(3);
  else if (ccrossp(1, 7, 4)) moveTo(4);
  else if (ccrossp(2, 8, 5)) moveTo(5);
  else if (ccrossp(0, 3, 6)) moveTo(6);
  else if (ccrossp(1, 4, 7)) moveTo(7);
  else if (ccrossp(2, 5, 8)) moveTo(8);
  //done with vert
  else if (ccrossp(4, 8, 0)) moveTo(0);
  else if (ccrossp(4, 6, 2)) moveTo(2);
  else if (ccrossp(0, 8, 4)) moveTo(4);
  else if (ccrossp(2, 6, 4)) moveTo(4);
  else if (ccrossp(2, 4, 6)) moveTo(6); 
  else if (ccrossp(0, 4, 8)) moveTo(8);

  //defending strategy (thinking 2 steps ahead)
  //Set 1
  else if (ccrossp(1, 3, 0)) moveTo(0);
  else if (ccrossp(1, 5, 2)) moveTo(2);
  else if (ccrossp(3, 7, 6)) moveTo(6);
  else if (ccrossp(5, 7, 8)) moveTo(8);

  //Set 2
  else if (ccrossp(3, 8, 7)) moveTo(7); //3,8--> 7
  else if (ccrossp(5, 6, 7)) moveTo(7);//6,5--> 7
  else if (ccrossp(2, 7, 5)) moveTo(5); //2,7--> 5
  else if (ccrossp(1, 8, 5)) moveTo(5);//1,8--> 5
  else if (ccrossp(0, 7, 3)) moveTo(3); //2,7--> 3
  else if (ccrossp(1, 6, 3)) moveTo(3);//1,8--> 3
  else if (ccrossp(0, 5, 1)) moveTo(1);//0,5-->1
  else if (ccrossp(2, 3, 1)) moveTo(1);//2,3-->1

    //Set 3
  else if (ccrossp(2, 4, 8)) moveTo(8);//0,5-->1
  else if (ccrossp(0, 4, 6)) moveTo(6);//2,3-->1
  else if (ccrossp(4, 8, 2)) moveTo(2);//0,5-->1
  else if (ccrossp(4, 6, 0)) moveTo(0);//2,3-->1
  //random

  //Set 4
  else if (bfwcro(2) && bfwcro(6)) randomAction(); //2, 6
  else if (bfwcro(0) && bfwcro(8)) randomAction(); //0, 8

  //If no threat or attacking opportunity, play in random position
  else while (true) {
    int i = round(random(8));
    if (boxIsEmpty(i) && i != 1) {
      moveTo(i);
      break;
    }
  }
}

void randomAction() {
  //It randomly puts you in CORRECT positions
  while (true) {
    //possibilities: 1, 3, 5, 7
    //These four possibilities make a diamond shape (quick visualization)
    int i = round(random(1, 4))*2 - 1; 
    if (boxIsEmpty(i)) {
      println("random action taken at box #" + i);
      moveTo(i);
      break;
    }
  }
}

void checkHowMany () {
  //If all the boxes are filled up, we have tied
  if (howmany == 9) tied = true;
}

void checkIfGameOver() {
  if (circleWins()) {
    gameOver("YOU LOSE");
  } else if (crossWins()) {
    gameOver("YOU WIN");
  } else if (tied) {
    gameOver("TIED");
  }
}

//Create the game over menu
void gameOver(String message) {
  gameIsLive = false;
  if (c < 200) c += 120/(fps+1);
  stroke(0, c);
  rectCreator(color(0, c), width/2, height/2 + 50, width-100, 200);
  textCreator(round(95*min(width, height)/800), color(255, c), message, width/2, height/2);
  rect(width/3, height/2 + 100, 100, 50);
  rect(width*2/3, height/2 + 100, 100, 50);

  textCreator(round(25*min(width, height)/800), color(0, c), "Restart", width/3, height/2+100);
  text("Save", width*2/3, height/2 + 100);

  stroke(0);
  if (overRect(width/3, height/2+100, 100, 50) && mouseReleased) {
    mouseReleased = false;
    //Reset all variables and clear background
    setup();
  } else if (overRect(width*2/3, height/2+100, 100, 50) && mouseReleased) {
    mouseReleased = false;
    saveFrame();
  }
}

void switchTurns() {
  //Player's turn

  howmany ++; 
  if (howmany % 2 == 1 && gameIsLive) {
    crossTurn = false;
    aiTurnTimer = true;
  }
}

void aiDelay() {
  //Delay the AI's move
  finalTime = (int)frameRate;
  if (time < finalTime) time++;
  //When the time comes, play it once
  else {
    aiTurnTimer = false;
    aiTurn = true;

    if (howmany == 1) aiFirstMove();
    else aiMoves();

    time = 0;
    
    aiTurn = false;
    crossTurn = true;
  }
}

//Check if user's mouse is hovering over a rectangle
boolean overRect(float x, float y, float w, float h) {
  return (mouseX >= x-w/2 && mouseX <= x+w/2 && mouseY >= y-h/2 && mouseY <= y+h/2);
}

//Check if a box is empty
boolean boxIsEmpty(int a) {
  return (!eachbox[a].crossed && !eachbox[a].circled);
}

//Check if a box is full
boolean boxFull(int a) {
  return (eachbox[a].crossed || eachbox[a].circled);
}

//Check if a circle occupies the box
boolean bfwcir(int a) {
  return (eachbox[a].circled);
}

//Check if a cross occupies the box
boolean bfwcro(int a) { //bfwcro
  return (eachbox[a].crossed);
}

//Check if the computer won
boolean Op(int a, int b, int c) {
  if (bfwcir(a) && bfwcir(b) && bfwcir(c)) {
    drawLines(a, c);
    return true;
  } else return false;
}

//Check if the user miraculously wins
boolean Xp(int a, int b, int c) {
  if (bfwcro(a) && bfwcro(b) && bfwcro(c)) {
    drawLines(a, c); //Draw a line to show the winning positions
    return true;
  } else return false;
}

boolean ccirclep(int a, int b, int c) { //check circle position
  return (bfwcir(a) && bfwcir(b) && boxIsEmpty(c));
}
boolean ccrossp(int a, int b, int c) { //check circle position
  return (bfwcro(a) && bfwcro(b) && boxIsEmpty(c));
}

void drawLines(int a, int c) {
  line(eachbox[a].x, eachbox[a].y, eachbox[c].x, eachbox[c].y);
}

boolean circleWins() {
  if (Op(0, 1, 2)) return true;
  else if (Op(3, 4, 5)) return true;
  else if (Op(6, 7, 8)) return true;
  else if (Op(0, 3, 6)) return true;
  else if (Op(1, 4, 7)) return true;
  else if (Op(2, 5, 8)) return true;
  else if (Op(0, 4, 8)) return true;
  else if (Op(2, 4, 6)) return true;
  else return false;
}

boolean crossWins() {
  if (Xp(0, 1, 2)) return true;
  else if (Xp(3, 4, 5)) return true;
  else if (Xp(6, 7, 8)) return true;
  else if (Xp(0, 3, 6)) return true;
  else if (Xp(1, 4, 7)) return true;
  else if (Xp(2, 5, 8)) return true;
  else if (Xp(0, 4, 8)) return true;
  else if (Xp(2, 4, 6)) return true;
  else return false;
}

class EachBox {
  int n; //number of this box
  int x, y; //position of box
  boolean crossed, circled;

  EachBox(int num) {
    rectMode(CENTER);
    n = num;
    num ++;

    setBoxSize(num, round(num/3f - 0.6));
  }

  void setBoxSize(int num, float a) {
    x = round(boxSize * (num-a*3));
    y = round(height/2+50 - boxSize + boxSize*a);
  }

  void drawBoard() {
    rectCreator(color(255, 255, 220), x, y, boxSize, boxSize);
  }

  void drawCross() {
    crossed = true; //mark this box as a cross
    switchTurns();

    if (howmany == 9) tied = true;

    line(x-radius, y-radius, x+radius, y+radius);
    line(x-radius, y+radius, x+radius, y-radius);
  }

  void drawCircle() {
    circled = true; //mark this box as a circle and draw one there
    switchTurns();

    if (howmany == 9) tied = true;
    fill(255, 255, 220);
    ellipse(x, y, radius, radius);
  }

  boolean isUserHoveringOverBox() {
    return overRect(x, y, boxSize, boxSize);
  }
}
