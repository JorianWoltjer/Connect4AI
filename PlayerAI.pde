class PlayerAI {
  color mainColor = color(52, 152, 219);
  color darkColor = color(32, 132, 199);

  float[] scores = new float[board.sizeX];
  int lastTime = 0;
  int deltaTime = 1000;
  ArrayList<Integer> possibleMoves = new ArrayList<Integer>();

  int[] getMove() {
    lastTime = millis();
    int[] move = new int[2];
    scores = new float[board.sizeX];
    float bestScore = Float.NEGATIVE_INFINITY;
    ArrayList<Integer> possibleMoves = board.getPossibleMoves(board.disks);
    Collections.shuffle(possibleMoves);

    // Depth increase if rendering is fast
    for (int i = 10; i > 0; i--) {
      if (deltaTime*pow(board.sizeX, i) < 2000 && board.AIDepth < board.sizeX*board.sizeY) {
        board.AIDepth += i;
        println("AIDepth = " + (board.AIDepth-i) + "+" + i + "=" + board.AIDepth);
        break;
      }
    }

    for (int i = 0; i < possibleMoves.size(); i++) {
      int y = board.getMinY(board.disks[possibleMoves.get(i)]);
      board.disks[possibleMoves.get(i)][y] = 1;
      board.currentPlayer = "human";
      float score = minimax(possibleMoves.get(i), y, board.AIDepth, false);
      board.disks[possibleMoves.get(i)][y] = 0;
      board.currentPlayer = "ai";
      if (score > bestScore) {
        bestScore = score;
        move[0] = possibleMoves.get(i);
        move[1] = y;
      }
      scores[possibleMoves.get(i)] = score;
    }
    deltaTime = millis() - lastTime;
    return move;

    // Random AI:
    //return possibleMoves.get(int(random(0, possibleMoves.size())));
  }

  float minimax(int x, int y, int AIDepth_, boolean isMaximizing) {
    String result = board.checkLines(x, y, false);

    if (AIDepth_ == 0) {
      return 0;
    }

    if (result == "tie") {
      return 0;
    } else if (result == "win") {
      if (isMaximizing) {
        return -(AIDepth_+1);
      } else {
        return AIDepth_+1;
      }
    }


    if (isMaximizing) {
      float bestScore = Float.NEGATIVE_INFINITY;
      ArrayList<Integer> possibleMoves = board.getPossibleMoves(board.disks);
      Collections.shuffle(possibleMoves);

      for (int i = 0; i < possibleMoves.size(); i++) {
        int y_ = board.getMinY(board.disks[possibleMoves.get(i)]);
        board.disks[possibleMoves.get(i)][y_] = 1;
        board.currentPlayer = "human";
        float score = minimax(possibleMoves.get(i), y_, AIDepth_-1, false);
        board.disks[possibleMoves.get(i)][y_] = 0;
        board.currentPlayer = "ai";
        bestScore = max(score, bestScore);
      }
      return bestScore;
    } else {
      float bestScore = Float.POSITIVE_INFINITY;
      ArrayList<Integer> possibleMoves = board.getPossibleMoves(board.disks);
      Collections.shuffle(possibleMoves);

      for (int i = 0; i < possibleMoves.size(); i++) {
        int y_ = board.getMinY(board.disks[possibleMoves.get(i)]);
        board.disks[possibleMoves.get(i)][y_] = 2;
        board.currentPlayer = "ai";
        float score = minimax(possibleMoves.get(i), y_, AIDepth_-1, true);
        board.disks[possibleMoves.get(i)][y_] = 0;
        board.currentPlayer = "human";
        bestScore = min(score, bestScore);
      }
      return bestScore;
    }
  }
}
