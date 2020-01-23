class Board {

  PlayerAI playerAI;
  PlayerHuman playerHuman;
  int boardSizeX;
  int boardSizeY;
  int winNeeded;
  int AIDepth;
  int[][] disks;
  String currentPlayer;

  void setupBoard(int boardSizeX_, int boardSizeY_, int winNeeded_, int AIDepth_, String currentPlayer_) {
    boardSizeX = boardSizeX_;
    boardSizeY = boardSizeY_;
    winNeeded  = winNeeded_;
    AIDepth = AIDepth_;
    disks = new int[boardSizeX][boardSizeY];
    currentPlayer = currentPlayer_;

    playerAI = new PlayerAI();
    playerHuman = new PlayerHuman();
  }

  int[][] winningLine = new int[2][2];
  float padding = 10;
  float cellSize;
  String gameState = "play";
  boolean showScores = false;

  void doNextMove() {
    if (gameState == "play") {
      if (currentPlayer == "ai") {
        int[] move = playerAI.getMove();
        setMove(move[0], move[1]);
      } else if (currentPlayer == "human") {
        int[] move = playerHuman.getMove();
        if (move[0] != -1) {
          setMove(move[0], move[1]);
        }
      }
    }
  }

  void setMove(int x, int y) {
    if (currentPlayer == "ai") {
      disks[x][y] = 1;
    } else { 
      disks[x][y] = 2;
    }

    if (currentPlayer == "ai") {
      currentPlayer = "human";
    } else {
      currentPlayer = "ai";
    }

    gameState = checkLines(x, y, currentPlayer, true);
  }

  ArrayList<Integer> getPossibleMoves(int[][] disks) {
    ArrayList<Integer> pm = new ArrayList<Integer>();
    for (int i = 0; i < boardSizeX; i++) {
      if (disks[i][0] == 0) {
        pm.add(i);
      }
    }
    Collections.shuffle(pm);
    return pm;
  }

  int getMinY(int[] column) {
    for (int i = column.length-1; i >= 0; i--) {
      if (column[i] == 0) {
        return i;
      }
    }
    return -1;
  }

  boolean checkDuplicate(int x, int y, String currentPlayer) {
    boardSizeX = disks.length;
    boardSizeY = disks[0].length;

    if (x < 0 || x >= boardSizeX || y < 0 || y >= boardSizeY) {
      return false; // out of bounds
    }
    if ((currentPlayer == "human" && disks[x][y] == 1) || (currentPlayer == "ai" && disks[x][y] == 2)) {
      return true; // duplicate
    }
    return false; // no duplicate
  }

  String checkLines(int x, int y, String currentPlayer, boolean realGame) {
    boolean found;

    // check horizontal line
    for (int i = 0; i < winNeeded; i++) { 
      found = true; 
      for (int j = 0; j < winNeeded; j++) {
        if (!checkDuplicate(x-i+j, y, currentPlayer)) {
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
        return "win";
      }
    }
    // check vertical line
    found = true; 
    for (int j = 0; j < winNeeded; j++) {
      if (!checkDuplicate(x, y+j, currentPlayer)) {
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
      return "win";
    }
    // check diagonal tl-br line
    for (int i = 0; i < winNeeded; i++) { 
      found = true; 
      for (int j = 0; j < winNeeded; j++) {
        if (!checkDuplicate(x-i+j, y-i+j, currentPlayer)) {
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
        return "win";
      }
    }
    // check diagonal tr-bl line
    for (int i = 0; i < winNeeded; i++) { 
      found = true; 
      for (int j = 0; j < winNeeded; j++) {
        if (!checkDuplicate(x+i-j, y-i+j, currentPlayer)) {
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
        return "win";
      }
    }
    // check for tie
    int diskCount = 0;
    for (int i = 0; i < disks.length; i++) {
      for (int j = 0; j < disks[0].length; j++) {
        if (disks[i][j] != 0) {
          diskCount++;
        }
      }
    }
    if (diskCount >= boardSizeX*boardSizeY) {
      return "tie";
    }
    return "play";
  }


  //----------Drawing:----------

  void draw() {
    background(50);
    ellipseMode(CORNER);
    textAlign(CENTER, TOP);
    textSize(40);

    // Calculate sizes
    cellSize = min((height-padding*2)/(boardSizeY+2), (width-padding*2)/(boardSizeX+2));

    // Draw Grid
    strokeWeight(cellSize/10*0.75);
    stroke(255);
    for (int i = 0; i < boardSizeX+1; i++) {
      line(width/2-boardSizeX*0.5*cellSize+cellSize*i, height/2-boardSizeY*0.5*cellSize, width/2-boardSizeX*0.5*cellSize+cellSize*i, height/2-boardSizeY*0.5*cellSize+cellSize*boardSizeY);
    }
    for (int i = 0; i < boardSizeY+1; i++) {
      line(width/2-boardSizeX*0.5*cellSize, height/2-boardSizeY*0.5*cellSize+cellSize*i, width/2-boardSizeX*0.5*cellSize+cellSize*boardSizeX, height/2-boardSizeY*0.5*cellSize+cellSize*i);
    }

    // Draw all disks
    strokeWeight(cellSize/10*0.75);
    for (int i = 0; i < boardSizeX; i++) {
      for (int j = 0; j < boardSizeY; j++) {
        if (disks[i][j] == 1) {
          fill(playerAI.mainColor);
          stroke(playerAI.darkColor);
          ellipse(gridToPoint(i, false)+cellSize/10, gridToPoint(j, true)+cellSize/10, cellSize-cellSize/10*2, cellSize-cellSize/10*2);
        } else if (disks[i][j] == 2) {
          fill(playerHuman.mainColor);
          stroke(playerHuman.darkColor);
          ellipse(gridToPoint(i, false)+cellSize/10, gridToPoint(j, true)+cellSize/10, cellSize-cellSize/10*2, cellSize-cellSize/10*2);
        }
      }
    }

    if (currentPlayer == "human" && gameState == "play") {
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
        text(nf(playerAI.scores[i], 0, 1), gridToPoint(i, false)+cellSize/2, gridToPoint(boardSizeY, true)+cellSize/2);
      }
      textAlign(CENTER, TOP);
    }

    // End screen
    if (gameState == "win") {
      textAlign(CENTER, CENTER);
      textSize(cellSize*0.7);
      noStroke();
      if (currentPlayer == "ai") {
        fill(playerHuman.mainColor);
        text("Human Player Wins!", width/2, gridToPoint(-1, true)+cellSize/2);
      } else {
        fill(playerAI.mainColor);
        text("AI Player Wins!", width/2, gridToPoint(-1, true)+cellSize/2);
      }
      stroke(255);
      line(gridToPoint(winningLine[0][0], false)+cellSize/2, gridToPoint(winningLine[0][1], true)+cellSize/2, 
        gridToPoint(winningLine[1][0], false)+cellSize/2, gridToPoint(winningLine[1][1], true)+cellSize/2);
    } else if (gameState == "tie") {
      fill(255);
      text("Tie Game!", width/2, padding/10);
    }
  }

  float gridToPoint(int n, boolean isY) {
    if (isY) 
      return height/2-boardSizeY*0.5*cellSize+cellSize*n;
    else
      return width/2-boardSizeX*0.5*cellSize+cellSize*n;
  }

  float gridToPoint(float n, boolean isY, int[][] board, float cellSize) {
    if (isY) 
      return height/2-board[0].length*0.5*cellSize+cellSize*n;
    else
      return width/2-board.length*0.5*cellSize+cellSize*n;
  }
}
