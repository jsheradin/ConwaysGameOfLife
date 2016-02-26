//Settings
int blocksWide = 40; //Width in blocks
int blocksTall = 40; //Height in blocks
float difficulty = .65; //Bomb spawning probability (sort of)
int loopRate = 50; //Loop delay in ms

//Appearance Settings
int pixPerBlock = 15; //Block size in pixels

//Game Variables
int nums = 0;
boolean[][] state = new boolean[blocksTall][blocksWide]; //Block States (true = alive)
boolean[][] stateBuff = new boolean[blocksTall][blocksWide]; //Block state buffer
int[][] numsL = new int[blocksTall][blocksWide]; //Debug block nums
boolean pause = true;
boolean debug = false;

void setup() {
  //Setup block arrays
  for (int i=0; i<blocksTall; i++) {
    for (int j=0; j<blocksWide; j++) {
      state[i][j] = false;
      stateBuff[i][j] = false;
    }
  }

  //Window Setup
  textAlign(CENTER, CENTER);
  //println("Done");
  size(pixPerBlock * blocksWide, pixPerBlock * blocksTall);
  background(#000000);
}

//Main Loop
void draw() {
  delay(loopRate);

  if (!pause) {
    advance();
  }

  //Draw Blocks
  for (int i=0; i<blocksTall; i++) {
    for (int j=0; j<blocksWide; j++) {
      if (state[i][j] == true) {
        fill(#FFFFFF);
      } else {
        fill(#7F7F7F);
      }
      rect(j*pixPerBlock, i*pixPerBlock, pixPerBlock, pixPerBlock);
      fill(#000000);
      if (debug) {
        text(numsL[i][j], j*pixPerBlock + pixPerBlock/2, i*pixPerBlock + pixPerBlock/2); //Debug numbers
      }
    }
  }
}

//
void advance() {
  for (int i=0; i<blocksTall; i++) {
    for (int j=0; j<blocksWide; j++) {
      nums = 0;

      //Not edge blocks
      int top = i - 1;
      int bottom = i + 1;
      int right = j + 1;
      int left = j - 1;

      //Edge cases (literally)
      if (i == 0) { //On top
        top = blocksTall - 1;
      }
      if (i == blocksTall - 1) { //On bottom
        bottom = 0;
      }
      if (j == 0) { //On left
        left = blocksWide - 1;
      }
      if (j == blocksWide - 1) { //On right
        right = 0;
      }

      //Get surrounding blocks
      //Top
      if (state[top][j] == true) {
        nums++;
      }
      //Bottom
      if (state[bottom][j] == true) {
        nums++;
      }
      //Left
      if (state[i][left] == true) {
        nums++;
      }
      //Right
      if (state[i][right] == true) {
        nums++;
      }
      //Top left
      if (state[top][left] == true) {
        nums++;
      }
      //Bottom left
      if (state[bottom][left] == true) {
        nums++;
      }
      //Top right
      if (state[top][right] == true) {
        nums++;
      }
      //Bottom right
      if (state[bottom][right] == true) {
        nums++;
      }

      //Block lives, dies, or is born
      if (nums < 2 || nums > 3) {
        stateBuff[i][j] = false; //dies
      } else if (nums == 2 && state[i][j] == true) {
        stateBuff[i][j] = true; //lives
      } else if (nums == 3) {
        stateBuff[i][j] = true; //live or brought to life
      }
      numsL[i][j] = nums;

      //println(nums);
    }
  }
  for (int i=0; i<blocksTall; i++) {
    for (int j=0; j<blocksWide; j++) {
      state[i][j] = stateBuff[i][j];
    }
  }
}

void keyPressed() {
  if (key == ' ') { //Space to pause/play
    pause = !pause;
  } else if (key == 's' || key == 'S') { //'s' to seed bombs
    //Place bombs (somewhat random, could be done much better)
    for (int i=0; i<blocksTall; i++) {
      for (int j=0; j<blocksWide; j++) {
        if (random(0, difficulty) > 0.5) {
          state[i][j] = true;
        }
      }
    }
  } else if (keyCode == BACKSPACE) { //Backspace to clear
    //Kill all blocks
    for (int i=0; i<blocksTall; i++) {
      for (int j=0; j<blocksWide; j++) {
        state[i][j] = false;
      }
    }
  } else if (keyCode == UP && loopRate > 2) { //up to speed up
    loopRate -= 2;
  } else if (keyCode == DOWN) { //down to slow down
    loopRate += 2;
  } else if (keyCode == RIGHT) { //right to advance manually
    advance();
  } else if (key == 'd' || key == 'D') { //d to toggle debug numbers
    debug = !debug;
  }
}

//On each mouse click
void mouseClicked() {
  //Determine block clicked
  int x = ceil(mouseX / pixPerBlock);
  int y = ceil(mouseY / pixPerBlock);

  //Toggle block life
  if (mouseButton == LEFT) {
    state[y][x] = !state[y][x];
  }
}

