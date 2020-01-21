class PlayerAI extends Board {

  color mainColor = color(52, 152, 219);
  color darkColor = color(32, 132, 199);
  int depth;
  float[] scores;
  int lastTime = 0;
  int deltaTime = 1000;
  
  PlayerAI(int depth_) {
    depth = depth_;
  }

  int[] getMove(int[][] disks, int winNeeded_) {
    lastTime = millis();
    winNeeded = winNeeded_;
    int[] move = new int[2];
    scores = new float[disks.length];
    float bestScore = Float.NEGATIVE_INFINITY;    
    ArrayList<Integer> possibleMoves = getPossibleMoves(disks);
    Collections.shuffle(possibleMoves);

    // Depth increase if rendering is fast
    for (int i = 10; i > 0; i--) {
      if (deltaTime*pow(disks.length, i) < 2000 && depth < disks.length*disks[0].length) {
        depth += i;
        println("depth = " + (depth-i) + "+" + i + "=" + depth);
        break;
      }
    }

    for (int i = 0; i < possibleMoves.size(); i++) {
      int y = getMinY(disks[possibleMoves.get(i)]);
      disks[possibleMoves.get(i)][y] = 1;
      float score = minimax(possibleMoves.get(i), y, disks, depth, false);
      disks[possibleMoves.get(i)][y] = 0;
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

  float minimax(int x, int y, int[][] disks, int depth_, boolean isMaximizing) {
    String result;
    if (isMaximizing) {
      result = checkLines(x, y, disks, winNeeded, "ai", false);
    } else {
      result = checkLines(x, y, disks, winNeeded, "human", false);
    }

    if (depth_ == 0) {
      return 0;
    }

    if (result == "tie") {
      return 0;
    } else if (result == "win") {
      if (isMaximizing) {
        return -(depth_+1);
      } else {
        return depth_+1;
      }
    }


    if (isMaximizing) {
      float bestScore = Float.NEGATIVE_INFINITY;
      ArrayList<Integer> possibleMoves = getPossibleMoves(disks);
      Collections.shuffle(possibleMoves);

      for (int i = 0; i < possibleMoves.size(); i++) {
        int y_ = getMinY(disks[possibleMoves.get(i)]);
        disks[possibleMoves.get(i)][y_] = 1;
        float score = minimax(possibleMoves.get(i), y_, disks, depth_-1, false);
        disks[possibleMoves.get(i)][y_] = 0;
        bestScore = max(score, bestScore);
      }
      return bestScore;
    } else {
      float bestScore = Float.POSITIVE_INFINITY;
      ArrayList<Integer> possibleMoves = getPossibleMoves(disks);
      Collections.shuffle(possibleMoves);

      for (int i = 0; i < possibleMoves.size(); i++) {
        int y_ = getMinY(disks[possibleMoves.get(i)]);
        disks[possibleMoves.get(i)][y_] = 2;
        float score = minimax(possibleMoves.get(i), y_, disks, depth_-1, true);
        disks[possibleMoves.get(i)][y_] = 0;
        bestScore = min(score, bestScore);
      }
      return bestScore;
    }
  }
}
