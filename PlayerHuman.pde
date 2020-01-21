class PlayerHuman extends Board {
  color mainColor = color(231, 76, 60);
  color darkColor = color(216, 61, 45);
  color mainHoverColor = color(121, 60, 54);
  color darkHoverColor = color(115, 54, 48);

  int selectedSlot = 0;
  boolean pmousePressed = true;
  boolean pkeyPressed = true;

  int[] getMove(int[][] disks, float cellSize) {
    ArrayList<Integer> possibleMoves = getPossibleMoves(disks);
    int[] move = new int[] {-1, -1};

    if (mousePressed && !pmousePressed) {
      for (int x = 0; x < disks.length; x++) {
        if (mouseX > gridToPoint(x, false, disks, cellSize) && mouseX < gridToPoint(x+1, false, disks, cellSize) && mouseY < gridToPoint(disks[0].length, true, disks, cellSize)) {
          if (possibleMoves.contains(x)) {
            move[0] = x;
            move[1] = getMinY(disks[x]);
          }
        }
      }
    } else if (keyPressed && !pkeyPressed) {
      if (key == CODED && keyCode == DOWN) {
        if (possibleMoves.contains(selectedSlot)) {
          move[0] = selectedSlot;
          move[1] = getMinY(disks[selectedSlot]);
        }
      } else {
        int x = key-49;
        if (possibleMoves.contains(x)) {
          move[0] = x;
          move[1] = getMinY(disks[x]);
        }
      }
    }
    return move;
  }

  void draw(int[][] disks, float cellSize) {
    ArrayList<Integer> possibleMoves = getPossibleMoves(disks);

    // Hover disk
    for (int x = 0; x < disks.length; x++) {
      if (mouseX > gridToPoint(x, false, disks, cellSize) && mouseX < gridToPoint(x+1, false, disks, cellSize) && mouseY < gridToPoint(disks[0].length, true, disks, cellSize)) {
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
        if (selectedSlot < disks.length-1) {
          selectedSlot++;
        }
      }
    }

    fill(mainHoverColor);
    stroke(darkHoverColor);
    ellipse(gridToPoint(selectedSlot, false, disks, cellSize)+cellSize/10, gridToPoint(-1, true, disks, cellSize)+cellSize/10, cellSize-cellSize/10*2, cellSize-cellSize/10*2);

    pmousePressed = mousePressed;
    pkeyPressed = keyPressed;
  }
}
