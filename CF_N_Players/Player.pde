class Player {
  color mainColor;
  color darkColor;
  color mainHoverColor;
  color darkHoverColor;

  Player(color mainColor_) {
    mainColor = mainColor_;
    darkColor = color(red(mainColor)-15, green(mainColor)-15, blue(mainColor)-15);
    mainHoverColor = color(sqrt(red(mainColor)-15)*8, sqrt(green(mainColor)-15)*8, sqrt(blue(mainColor)-15)*8);
    darkHoverColor = color(sqrt(red(mainColor)-15)*8-6, sqrt(green(mainColor)-15)*8-6, sqrt(blue(mainColor)-15)*8-6);
  }

  int selectedSlot = (board.sizeX-1)/2;
  ArrayList<Integer> possibleMoves = new ArrayList<Integer>();

  int[] getMove() {
    ArrayList<Integer> possibleMoves = board.getPossibleMoves();
    int[] move = new int[] {-1, -1};

    if (mousePressed && !pmousePressed) {
      for (int x = 0; x < board.sizeX; x++) {
        if (mouseX > board.gridToPoint(x, false) && mouseX < board.gridToPoint(x+1, false) && mouseY < board.gridToPoint(board.sizeY, true)) {
          if (possibleMoves.contains(x)) {
            move[0] = x;
            move[1] = board.getMinY(board.disks[x]);
          }
        }
      }
    } else if (keyPressed && !pkeyPressed && ((key == CODED && keyCode == DOWN) || key == ' ' || key == 10)) {
      if (possibleMoves.contains(selectedSlot)) {
        move[0] = selectedSlot;
        move[1] = board.getMinY(board.disks[selectedSlot]);
      }
    }
    return move;
  }

  void draw() {
    // Hover disk
    for (int x = 0; x < board.sizeX; x++) {
      if (mouseX > board.gridToPoint(x, false) && mouseX < board.gridToPoint(x+1, false) && mouseY < board.gridToPoint(board.sizeY, true)) {
        selectedSlot = x;
      }
    }
    if (keyPressed && !pkeyPressed && key == CODED) {
      if (keyCode == LEFT) {
        if (selectedSlot > 0) {
          selectedSlot--;
        }
      } else if (keyCode == RIGHT) {
        if (selectedSlot < board.sizeX-1) {
          selectedSlot++;
        }
      }
    }

    fill(mainHoverColor);
    stroke(darkHoverColor);
    ellipse(board.gridToPoint(selectedSlot, false)+board.cellSize/10, board.gridToPoint(-1, true)+board.cellSize/10, board.cellSize-board.cellSize/10*2, board.cellSize-board.cellSize/10*2);
  }
}
