// Controls: ----------------------------------------------------------+
// | * Links/Rechts -> Cursor verplaatsen                              |
// | * Beneden/Enter/Spatie -> Stuk plaatsen op cursor                 |
// | * Muis -> Klikken om stuk te plaatsen op cursor                   |
// | * R -> Reset bord                                                 |
// | * P -> Print alle disks van het bord in de console                |
// | * S -> Scores van AI per zet onderaan het bord weergeven          |
// +-------------------------------------------------------------------+

// Setup: -------------------------------------------------------------+
int sizeX = 7; // Horizontale groote van het bord                      |
int sizeY = 6; // Verticale groote van het bord                        |
int winNeeded = 4; // Stukken nodig op een rij om te winnen            |
int AIDepth = 8; // Aantal zetten die de AI vooruit denkt              |
int currentPlayer = 1; // Beginnende speler (1=Human, 2=AI)            |
// +-------------------------------------------------------------------+

import java.util.Collections;
import processing.serial.*;

Serial arduinoPort;  // Create object from Serial class
String arduinoVal = "";   // Data received from the serial port
String pArduinoVal = "";

Board board = new Board();
PFont DIN;
boolean pmousePressed = true;
boolean pkeyPressed = true;

void setup() {
  size(640, 360);
  background(50);
  surface.setResizable(true);

  if (Serial.list().length > 0) {
    arduinoPort = new Serial(this, Serial.list()[Serial.list().length-1], 9600);
  }
  board.setupBoard(sizeX, sizeY, winNeeded, AIDepth, currentPlayer);
  DIN = createFont("DIN Bold_0.otf", 40);
  textFont(DIN);
}

void draw() {
  if (arduinoPort.available() > 0) {
    arduinoVal = arduinoPort.readString().trim();
  } 

  board.doNextMove();
  board.draw();

  pArduinoVal = arduinoVal;
  pmousePressed = mousePressed;
  pkeyPressed = keyPressed;
}

void keyPressed() {
  switch (key) { 
  case 'r': // Reset
    board = new Board();
    board.setupBoard(sizeX, sizeY, winNeeded, AIDepth, currentPlayer);
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
