class PlayerHuman {
  color mainColor = color(231, 76, 60);
  color darkColor = color(216, 61, 45);
  color mainHoverColor = color(121, 60, 54);
  color darkHoverColor = color(115, 54, 48);

  int selectedSlot = floor((board.boardSizeX-1)/2);
  boolean pmousePressed = true;
  boolean pkeyPressed = true;
  ArrayList<Integer> possibleMoves = new ArrayList<Integer>();

  int[] getMove() {
    ArrayList<Integer> possibleMoves = board.getPossibleMoves(board.disks);
    int[] move = new int[] {-1, -1};

    if (mousePressed && !pmousePressed) {
      for (int x = 0; x < board.boardSizeX; x++) {
        if (mouseX > board.gridToPoint(x, false) && mouseX < board.gridToPoint(x+1, false) && mouseY < board.gridToPoint(board.boardSizeY, true)) {
          if (possibleMoves.contains(x)) {
            move[0] = x;
            move[1] = board.getMinY(board.disks[x]);
          }
        }
      }
    } else if (keyPressed && !pkeyPressed) {
      if (key == CODED && keyCode == DOWN) {
        if (possibleMoves.contains(selectedSlot)) {
          move[0] = selectedSlot;
          move[1] = board.getMinY(board.disks[selectedSlot]);
        }
      } else {
        int x = key-49;
        if (possibleMoves.contains(x)) {
          move[0] = x;
          move[1] = board.getMinY(board.disks[x]);
        }
      }
    }
    return move;
  }

  void draw() {
    ArrayList<Integer> possibleMoves = board.getPossibleMoves(board.disks);

    // Hover disk
    for (int x = 0; x < board.boardSizeX; x++) {
      if (mouseX > board.gridToPoint(x, false) && mouseX < board.gridToPoint(x+1, false) && mouseY < board.gridToPoint(board.boardSizeY, true)) {
        if (possibleMoves.contains(x)) {
          selectedSlot = x;
        }
      }
    }
    if (keyPressed && !pkeyPressed && key == CODED) {
      if (keyCode == LEFT) {
        if (selectedSlot > 0) {
          selectedSlot--;
        }
      } else if (keyCode == RIGHT) {
        if (selectedSlot < board.boardSizeX-1) {
          selectedSlot++;
        }
      }
    }

    fill(mainHoverColor);
    stroke(darkHoverColor);
    ellipse(board.gridToPoint(selectedSlot, false)+board.cellSize/10, board.gridToPoint(-1, true)+board.cellSize/10, board.cellSize-board.cellSize/10*2, board.cellSize-board.cellSize/10*2);

    pmousePressed = mousePressed;
    pkeyPressed = keyPressed;
  }
}
