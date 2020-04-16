class PlayerHuman {
  
  color mainColor = color(231, 76, 60); // Red
  //color mainColor = color(241, 196, 15); // DAF Yellow
  color darkColor = color(red(mainColor)-15, green(mainColor)-15, blue(mainColor)-15);
  color mainHoverColor = color(sqrt(red(mainColor)-15)*8, sqrt(green(mainColor)-15)*8, sqrt(blue(mainColor)-15)*8);
  color darkHoverColor = color(sqrt(red(mainColor)-15)*8-6, sqrt(green(mainColor)-15)*8-6, sqrt(blue(mainColor)-15)*8-6);

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
    } else if (arduinoVal.equals("down") && pArduinoVal.equals("none")) {
      if (possibleMoves.contains(selectedSlot)) {
        move[0] = selectedSlot;
        move[1] = board.getMinY(board.disks[selectedSlot]);
      }
    }
    return move;
  }

  void draw() {
    if ((keyPressed && !pkeyPressed && key == CODED) || pArduinoVal.equals("none")) {
      if (keyCode == LEFT || arduinoVal.equals("left")) {
        if (selectedSlot > 0) {
          selectedSlot--;
        }
      } else if (keyCode == RIGHT || arduinoVal.equals("right")) {
        if (selectedSlot < board.sizeX-1) {
          selectedSlot++;
        }
      }
    }
    // Hover disk
    for (int x = 0; x < board.sizeX; x++) {
      if (mouseX > board.gridToPoint(x, false) && mouseX < board.gridToPoint(x+1, false) && mouseY < board.gridToPoint(board.sizeY, true)) {
        selectedSlot = x;
      }
    }

    fill(mainHoverColor);
    stroke(darkHoverColor);
    ellipse(board.gridToPoint(selectedSlot, false)+board.cellSize/10, board.gridToPoint(-1, true)+board.cellSize/10, board.cellSize-board.cellSize/10*2, board.cellSize-board.cellSize/10*2);
  }
}
