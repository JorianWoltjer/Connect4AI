class PlayerHuman {
  color mainColor = color(231, 76, 60);
  color darkColor = color(216, 61, 45);
  color mainHoverColor = color(121, 60, 54);
  color darkHoverColor = color(115, 54, 48);

  int selectedSlot = (board.sizeX-1)/2;
  ArrayList<Integer> possibleMoves = new ArrayList<Integer>();

  int[] getMove() {
    ArrayList<Integer> possibleMoves = board.getPossibleMoves(board.disks);
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
    } else if (keyPressed && !pkeyPressed) {
      if ((key == CODED && keyCode == DOWN) || key == ' ' || key == 10) {
        if (possibleMoves.contains(selectedSlot)) {
          move[0] = selectedSlot;
          move[1] = board.getMinY(board.disks[selectedSlot]);
        }
      } else if (possibleMoves.contains(key-49)) {
        selectedSlot = key-49;
        move[0] = selectedSlot;
        move[1] = board.getMinY(board.disks[selectedSlot]);
      }
    }
    return move;
  }

  void draw() {
    ArrayList<Integer> possibleMoves = board.getPossibleMoves(board.disks);

    // Hover disk
    for (int x = 0; x < board.sizeX; x++) {
      if (mouseX > board.gridToPoint(x, false) && mouseX < board.gridToPoint(x+1, false) && mouseY < board.gridToPoint(board.sizeY, true)) {
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
