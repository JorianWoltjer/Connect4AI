class Board {

  PlayerAI playerAI;
  PlayerHuman playerHuman;
  int sizeX;
  int sizeY;
  int winNeeded;
  int AIDepth;
  int[][] disks;
  int currentPlayer;

  void setupBoard(int sizeX_, int sizeY_, int winNeeded_, int AIDepth_, int currentPlayer_) {
    sizeX = sizeX_;
    sizeY = sizeY_;
    winNeeded  = winNeeded_;
    AIDepth = AIDepth_;
    disks = new int[sizeX][sizeY];
    currentPlayer = currentPlayer_;

    playerAI = new PlayerAI();
    playerHuman = new PlayerHuman();
  }

  int gameState = 0; // 0=play, 1=win, 2=tie
  int[][] winningLine = new int[2][2];
  float padding = 10;
  float cellSize;
  boolean showScores = false;

  void doNextMove() {
    if (gameState == 0) {
      if (currentPlayer == 2) {
        int[] move = playerAI.getMove();
        setMove(move[0], move[1]);
        for (int i = 0; i < playerAI.scores.length; i++) {
          if (playerAI.scores[i] > 0) {
            println("AI will win");
            break;
          }
        }
        if (AIDepth >= sizeX*sizeY-getDiskCount()) {
          println("AI will play perfectly");
        }
      } else if (currentPlayer == 1) {
        int[] move = playerHuman.getMove();
        if (move[0] != -1) {
          setMove(move[0], move[1]);
        }
      }
    }
  }

  void setMove(int x, int y) {
    disks[x][y] = currentPlayer;
    gameState = checkLines(x, y, true);
    currentPlayer = currentPlayer % 2 + 1;
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
    if (disks[x][y] == currentPlayer) {
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
        if (disks[i][j] == 2) {
          fill(playerAI.mainColor);
          stroke(playerAI.darkColor);
          ellipse(gridToPoint(i, false)+cellSize/10, gridToPoint(j, true)+cellSize/10, cellSize-cellSize/10*2, cellSize-cellSize/10*2);
        } else if (disks[i][j] == 1) {
          fill(playerHuman.mainColor);
          stroke(playerHuman.darkColor);
          ellipse(gridToPoint(i, false)+cellSize/10, gridToPoint(j, true)+cellSize/10, cellSize-cellSize/10*2, cellSize-cellSize/10*2);
        }
      }
    }

    if (currentPlayer == 1 && gameState == 0) {
      playerHuman.draw();
    }

    // Show score values
    if (showScores) {
      textAlign(CENTER, CENTER);
      textSize(cellSize*0.5);
      noStroke();
      for (int i = 0; i < playerAI.scores.length; i++) {
        if (playerAI.scores[i] > 0) {
          fill(39, 174, 96);
        } else if (playerAI.scores[i] < 0) {
          fill(231, 76, 60);
        } else {
          fill(255);
        }
        text(nf(playerAI.scores[i], 0, 1), gridToPoint(i, false)+cellSize/2, gridToPoint(sizeY, true)+cellSize/2);
      }
      textAlign(CENTER, TOP);
    }

    // End screen
    textAlign(CENTER, CENTER);
    textSize(cellSize*0.7);
    noStroke();
    if (gameState == 1) {
      if (currentPlayer == 2) {
        fill(playerHuman.mainColor);
        text("Human Player Wins!", width/2, gridToPoint(-1, true)+cellSize/2);
      } else {
        fill(playerAI.mainColor);
        text("AI Player Wins!", width/2, gridToPoint(-1, true)+cellSize/2);
      }
      stroke(255);
      line(gridToPoint(winningLine[0][0], false)+cellSize/2, gridToPoint(winningLine[0][1], true)+cellSize/2, 
        gridToPoint(winningLine[1][0], false)+cellSize/2, gridToPoint(winningLine[1][1], true)+cellSize/2);
    } else if (gameState == 2) {
      fill(255);
      text("Tie Game!", width/2, gridToPoint(-1, true)+cellSize/2);
    }
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
