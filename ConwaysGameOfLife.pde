//Settings
int blocksWide = 50; //Width in blocks
int blocksTall = 50; //Height in blocks
float difficulty = .65; //Bomb spawning probability (sort of)
int loopRate = 50; //Loop delay in ms

//Appearance Settings
int pixPerBlock = 12; //Block size in pixels

//Game Variables
int nums = 0;
boolean[][] state = new boolean[blocksTall][blocksWide]; //Block States (true = alive)
boolean[][] stateBuff = new boolean[blocksTall][blocksWide]; //Block state buffer
boolean pause = true;

void setup() {
  //Setup block arrays
  for(int i=0; i<blocksTall; i++) {
    for(int j=0; j<blocksWide; j++) {
      state[i][j] = false;
      stateBuff[i][j] = false;
    }
  }

  //Window Setup
  println("Done");
  size(pixPerBlock * blocksWide, pixPerBlock * blocksTall);
  background(#000000);
}

//Main Loop
void draw() {
  delay(loopRate);
  
  //Count surrounding blocks
  if(!pause) {
    for(int i=0; i<blocksTall; i++) {
      for(int j=0; j<blocksWide; j++) {
        nums = 0;
        //Top
        if(i>0 && state[i-1][j] == true) {
          nums++;
        }
        //Bottom
        if(i<blocksTall-1 && state[i+1][j] == true){
          nums++;
        }
        //Left
        if(j>0 && state[i][j-1] == true) {
          nums++;
        }
        //Right
        if(j<blocksWide-1 && state[i][j+1] == true) {
          nums++;
        }
        //Top right
        if(i>0 && j<blocksWide-1 && state[i-1][j+1] == true) {
          nums++;
        }
        //Top Left
        if(j>0 && i>0 && state[i-1][j-1] == true) {
          nums++;
        }
        //Bottom Left
        if(j>0 && i<blocksTall-1 && state[i+1][j-1] == true) {
          nums++;
        }
        //Bottom Right
        if(i<blocksTall-1 && j<blocksWide-1 && state[i+1][j+1] == true) {
          nums++;
        }
        
        //Block lives, dies, or is born
        if(nums < 2 || nums > 3) {
          stateBuff[i][j] = false; //dies
        } else if (nums == 2 && state[i][j] == true) {
          stateBuff[i][j] = true; //lives
        } else if (nums == 3) {
          stateBuff[i][j] = true; //live or brought to life
        }
      }
    }
    for(int i=0; i<blocksTall; i++) {
      for(int j=0; j<blocksWide; j++) {
        state[i][j] = stateBuff[i][j];
      }
    }
  }
  
  //Draw Blocks
  for(int i=0; i<blocksTall; i++) {
    for(int j=0; j<blocksWide; j++) {
      if(state[i][j] == true) {
        fill(#FFFFFF);
      } else {
        fill(#7F7F7F);
      }
      rect(j*pixPerBlock, i*pixPerBlock, pixPerBlock, pixPerBlock);
    }
  }
}

void keyPressed() {
  if (keyCode == ENTER) {
    pause = !pause;
  } else if (keyCode == SHIFT) {
    //Place bombs (somewhat random, could be done much better)
    for(int i=0; i<blocksTall; i++) {
      for(int j=0; j<blocksWide; j++) {
        if (random(0, difficulty) > 0.5) {
          state[i][j] = true;
        }
      }
    }
  } else if (keyCode == BACKSPACE) {
    //Kill all blocks
    for(int i=0; i<blocksTall; i++) {
      for(int j=0; j<blocksWide; j++) {
          state[i][j] = false;
      }
    }
  } else if (keyCode == UP && loopRate > 2) {
    loopRate -= 2;
  } else if (keyCode == DOWN) {
    loopRate += 2;
  }
}

//On each mouse click
void mouseClicked() {
  //Determine block clicked
  int x = ceil(mouseX / pixPerBlock);
  int y = ceil(mouseY / pixPerBlock);
  
  //Toggle block life
  if(mouseButton == LEFT) {
    state[y][x] = !state[y][x];
  }
}
