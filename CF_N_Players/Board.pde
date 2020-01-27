class Board {

  Player[] players;
  int sizeX;
  int sizeY;
  int winNeeded;
  int[][] disks;

  void setupBoard(int sizeX_, int sizeY_, int winNeeded_, color[] playerColors_) {
    sizeX = sizeX_;
    sizeY = sizeY_;
    winNeeded  = winNeeded_;
    disks = new int[sizeX][sizeY];

    players = new Player[playerColors_.length];
    for (int i = 0; i < players.length; i++) {
      players[i] = new Player(playerColors_[i]);
    }
  }

  int currentPlayer = 0;
  int gameState = 0; // 0=play, 1=win, 2=tie
  int[][] winningLine = new int[2][2];
  float padding = 10;
  float cellSize;
  boolean showScores = false;

  void doNextMove() {
    if (gameState == 0) {
      int[] move = players[currentPlayer].getMove();
      if (move[0] != -1) {
        setMove(move[0], move[1]);
      }
    }
  }

  void setMove(int x, int y) {
    disks[x][y] = currentPlayer+1;
    gameState = checkLines(x, y, true);
    currentPlayer = (currentPlayer + 1) % players.length;
  }

  ArrayList<Integer> getPossibleMoves() {
    ArrayList<Integer> pm = new ArrayList<Integer>();
    for (int i = 0; i < sizeX; i++) {
      if (disks[i][0] == 0) {
        pm.add(i);
      }
    }
    Collections.shuffle(pm);
    return pm;
  }

  int getDiskCount() {
    int diskCount = 0;
    for (int i = 0; i < disks.length; i++) {
      for (int j = 0; j < disks[0].length; j++) {
        if (disks[i][j] != 0) {
          diskCount++;
        }
      }
    }
    return diskCount;
  }

  int getMinY(int[] column) {
    for (int i = column.length-1; i >= 0; i--) {
      if (column[i] == 0) {
        return i;
      }
    }
    return -1;
  }

  boolean checkDuplicate(int x, int y) {
    if (x < 0 || x >= sizeX || y < 0 || y >= sizeY) {
      return false; // out of bounds
    }
    if (disks[x][y] == currentPlayer+1) {
      return true; // duplicate
    }
    return false; // no duplicate
  }

  int checkLines(int x, int y, boolean realGame) {
    boolean found;

    // check horizontal line
    for (int i = 0; i < winNeeded; i++) { 
      found = true; 
      for (int j = 0; j < winNeeded; j++) {
        if (!checkDuplicate(x-i+j, y)) {
          found = false;
          break;
        }
      }
      if (found) {
        if (realGame) {
          winningLine[0][0] = x-i;
          winningLine[0][1] = y;
          winningLine[1][0] = x-i+winNeeded-1;
          winningLine[1][1] = y;
        }
        return 1;
      }
    }
    // check vertical line
    found = true; 
    for (int j = 0; j < winNeeded; j++) {
      if (!checkDuplicate(x, y+j)) {
        found = false;
        break;
      }
    }
    if (found) {
      if (realGame) {
        winningLine[0][0] = x;
        winningLine[0][1] = y;
        winningLine[1][0] = x;
        winningLine[1][1] = y+winNeeded-1;
      }
      return 1;
    }
    // check diagonal tl-br line
    for (int i = 0; i < winNeeded; i++) { 
      found = true; 
      for (int j = 0; j < winNeeded; j++) {
        if (!checkDuplicate(x-i+j, y-i+j)) {
          found = false;
          break;
        }
      }
      if (found) {
        if (realGame) {
          winningLine[0][0] = x-i;
          winningLine[0][1] = y-i;
          winningLine[1][0] = x-i+winNeeded-1;
          winningLine[1][1] = y-i+winNeeded-1;
        }
        return 1;
      }
    }
    // check diagonal tr-bl line
    for (int i = 0; i < winNeeded; i++) { 
      found = true; 
      for (int j = 0; j < winNeeded; j++) {
        if (!checkDuplicate(x+i-j, y-i+j)) {
          found = false;
          break;
        }
      }
      if (found) {
        if (realGame) {
          winningLine[0][0] = x+i;
          winningLine[0][1] = y-i;
          winningLine[1][0] = x+i-winNeeded+1;
          winningLine[1][1] = y-i+winNeeded-1;
        }
        return 1;
      }
    }

    // check for tie
    if (getDiskCount() >= sizeX*sizeY) {
      return 2;
    }
    return 0;
  }

  //----------Drawing:----------

  void draw() {
    background(50);
    ellipseMode(CORNER);
    textAlign(CENTER, TOP);
    textSize(40);

    // Calculate sizes
    cellSize = min((height-padding*2)/(sizeY+2), (width-padding*2)/(sizeX+2));

    // Draw Grid
    strokeWeight(cellSize/10*0.75);
    stroke(255);
    for (int i = 0; i < sizeX+1; i++) {
      line(width/2-sizeX*0.5*cellSize+cellSize*i, height/2-sizeY*0.5*cellSize, width/2-sizeX*0.5*cellSize+cellSize*i, height/2-sizeY*0.5*cellSize+cellSize*sizeY);
    }
    for (int i = 0; i < sizeY+1; i++) {
      line(width/2-sizeX*0.5*cellSize, height/2-sizeY*0.5*cellSize+cellSize*i, width/2-sizeX*0.5*cellSize+cellSize*sizeX, height/2-sizeY*0.5*cellSize+cellSize*i);
    }

    // Draw all disks
    strokeWeight(cellSize/10*0.75);
    for (int i = 0; i < sizeX; i++) {
      for (int j = 0; j < sizeY; j++) {
        if (disks[i][j] != 0) {
          fill(players[disks[i][j]-1].mainColor);
          stroke(players[disks[i][j]-1].darkColor);
          ellipse(gridToPoint(i, false)+cellSize/10, gridToPoint(j, true)+cellSize/10, cellSize-cellSize/10*2, cellSize-cellSize/10*2);
        }
      }
    }

    if (gameState == 0) {
      players[currentPlayer].draw();
    }

    // End screen
    textAlign(CENTER, CENTER);
    textSize(cellSize*0.7);
    noStroke();
    if (gameState == 1) {
      fill(players[mod(currentPlayer - 1, players.length)].mainColor);
      text("Player " + (mod(currentPlayer - 1, players.length) + 1) + " Wins!", width/2, gridToPoint(-1, true)+cellSize/2);
      stroke(255);
      line(gridToPoint(winningLine[0][0], false)+cellSize/2, gridToPoint(winningLine[0][1], true)+cellSize/2, 
        gridToPoint(winningLine[1][0], false)+cellSize/2, gridToPoint(winningLine[1][1], true)+cellSize/2);
    } else if (gameState == 2) {
      fill(255);
      text("Tie Game!", width/2, gridToPoint(-1, true)+cellSize/2);
    }
  }

  int mod(int a, int b) { // For dealing with negative numbers
    int r = a % b;
    return r < 0 ? r + b : r;
  }

  float gridToPoint(int n, boolean isY) {
    if (isY) 
      return height/2-sizeY*0.5*cellSize+cellSize*n;
    else
      return width/2-sizeX*0.5*cellSize+cellSize*n;
  }

  float gridToPoint(float n, boolean isY, int[][] board, float cellSize) {
    if (isY) 
      return height/2-board[0].length*0.5*cellSize+cellSize*n;
    else
      return width/2-board.length*0.5*cellSize+cellSize*n;
  }
}
