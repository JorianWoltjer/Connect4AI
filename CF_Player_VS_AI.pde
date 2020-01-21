// Controls: ----------------------------------------------------------+
// | * Links/Rechts -> Cursor verplaatsen                              |
// | * Beneden -> Stuk plaatsen op cursor                              |
// | * Muis -> Klikken om stuk te plaatsen op cursor                   |
// | * R -> Reset bord                                                 |
// | * P -> Print alle disks van het bord in de console                |
// | * S -> Scores van AI per zet onderaan het bord weergeven          |
// +-------------------------------------------------------------------+

import java.util.Collections;

Board board = new Board();
PFont DIN;

void setup() {
  size(640, 360);
  surface.setResizable(true);
  board.setupBoard(7, 6, 4, 10); // 7 bij 6, 4-op-een-rij, 7 zetten vooruit denken {VERANDEREN}
  DIN = createFont("DIN Bold_0.otf", 40);
  textFont(DIN);
}

void draw() {
  board.doNextMove();
  board.draw();
}

void keyPressed() {
  switch (key) { 
  case 'r': // Reset
    board.resetBoard();
    break;
  case 'p': // Print shown disks
    printDisks(board.disks);
    break;
  case 's':
    board.showScores = !board.showScores;
    break;
  }
}

void printDisks(int[][] disks) {
  println();
  for (int i = 0; i < disks[0].length; i++) {
    for (int j = 0; j < disks.length; j++) {
      print(disks[j][i] + " ");
    }
    println();
  }
}
