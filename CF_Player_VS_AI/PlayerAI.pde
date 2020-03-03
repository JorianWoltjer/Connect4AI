class PlayerAI {

  color mainColor = color(52, 152, 219); // Blue
  //color mainColor = color(142, 68, 173); // DAF Purple
  color darkColor = color(red(mainColor)-15, green(mainColor)-15, blue(mainColor)-15);

  float[] scores = new float[board.sizeX];
  int lastTime = 0;
  int deltaTime = 1000;
  ArrayList<Integer> possibleMoves = new ArrayList<Integer>();

  int[] getMove() {
    lastTime = millis();
    int[] move = new int[2];
    scores = new float[board.sizeX];
    float bestScore = Float.NEGATIVE_INFINITY;
    ArrayList<Integer> possibleMoves = board.getPossibleMoves();

    // Depth increase if rendering is fast
    for (int i = 10; i > 0; i--) {
      if (deltaTime*pow(board.sizeX, i) < 2000 && board.AIDepth < board.sizeX*board.sizeY) {
        board.AIDepth += i;
        //println("AIDepth = " + (board.AIDepth-i) + "+" + i + "=" + board.AIDepth);
        break;
      }
    }

    for (int i = 0; i < possibleMoves.size(); i++) {
      int x = possibleMoves.get(i);
      int y = board.getMinY(board.disks[x]);
      board.disks[x][y] = 2;
      board.currentPlayer = 2;
      float score = minimax(x, y, board.AIDepth, Float.NEGATIVE_INFINITY, Float.POSITIVE_INFINITY, false);
      board.disks[x][y] = 0;
      board.currentPlayer = 2;
      if (score > bestScore) {
        bestScore = score;
        move[0] = x;
        move[1] = y;
      }
      scores[possibleMoves.get(i)] = score;
    }
    deltaTime = millis() - lastTime;
    return move;

    // Random AI:
    //return possibleMoves.get(int(random(0, possibleMoves.size())));
  }

  float minimax(int x, int y, int AIDepth_, float alpha, float beta, boolean isMaximizing) {
    int result = board.checkLines(x, y, false); // 0=play, 1=win, 2=tie

    if (AIDepth_ == 0) {
      return 0;
    }

    if (result == 2) {
      return 0;
    } else if (result == 1) {
      if (isMaximizing) {
        return -(AIDepth_+1);
      } else {
        return AIDepth_+1;
      }
    }


    if (isMaximizing) {
      float bestScore = Float.NEGATIVE_INFINITY;
      ArrayList<Integer> possibleMoves = board.getPossibleMoves();

      for (int i = 0; i < possibleMoves.size(); i++) {
        int x_ = possibleMoves.get(i);
        int y_ = board.getMinY(board.disks[x_]);
        board.disks[x_][y_] = 2;
        board.currentPlayer = 2;
        float score = minimax(x_, y_, AIDepth_-1, alpha, beta, false);
        board.disks[x_][y_] = 0;
        board.currentPlayer = 2;
        bestScore = max(score, bestScore);
        alpha = max(alpha, score);
        if (beta <= alpha) {
          break;
        }
      }
      return bestScore;
    } else {
      float bestScore = Float.POSITIVE_INFINITY;
      ArrayList<Integer> possibleMoves = board.getPossibleMoves();

      for (int i = 0; i < possibleMoves.size(); i++) {
        int x_ = possibleMoves.get(i);
        int y_ = board.getMinY(board.disks[x_]);
        board.disks[x_][y_] = 1;
        board.currentPlayer = 1;
        float score = minimax(x_, y_, AIDepth_-1, alpha, beta, true);
        board.disks[x_][y_] = 0;
        board.currentPlayer = 1;
        bestScore = min(score, bestScore);
        beta = min(beta, score);
        if (beta <= alpha) {
          break;
        }
      }
      return bestScore;
    }
  }
}
