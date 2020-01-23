// Controls: ----------------------------------------------------------+
// | * Links/Rechts -> Cursor verplaatsen                              |
// | * Beneden -> Stuk plaatsen op cursor                              |
// | * Muis -> Klikken om stuk te plaatsen op cursor                   |
// | * R -> Reset bord                                                 |
// | * P -> Print alle disks van het bord in de console                |
// | * S -> Scores van AI per zet onderaan het bord weergeven          |
// +-------------------------------------------------------------------+

// Setup: -------------------------------------------------------------+
int boardSizeX = 7; // Horizontale groote van het bord                 |
int boardSizeY = 6; // Verticale groote van het bord                   |
int winNeeded = 4; // Stukken nodig op een rij om te winnen            |
int depth = 7; // Aantal zetten die AI vooruit denkt                   |
String currentPlayer = "human"; // Beginnende speler                   |
// +-------------------------------------------------------------------+


import java.util.Collections;

Board board = new Board();
PFont DIN;

void setup() {
  size(640, 360);
  surface.setResizable(true);
  board.setupBoard(boardSizeX, boardSizeY, winNeeded, depth, currentPlayer);
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
    board = new Board();
    board.setupBoard(boardSizeX, boardSizeY, winNeeded, depth, currentPlayer);
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
