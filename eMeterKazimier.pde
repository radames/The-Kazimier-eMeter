import java.util.Date;
import de.voidplus.leapmotion.*;
import oscP5.*;
import netP5.*;
import processing.serial.*;
import ddf.minim.*;

LeapMotion leap;
Graph g;
Game game;

Serial sPort;
Minim minim;

PFont font;

void setup() {
  size(800, 800);
  pixelDensity(2); //for MacRetina

  background(255);
  // ...
  minim = new Minim(this);
  leap = new LeapMotion(this);
  g = new Graph(0, 0);
  game = new Game();

  font = createFont(PFont.list()[81], 100);
  try {
    sPort = new Serial(this, "/dev/cu.Bluetooth-Incoming-Port", 57600);
    //sPort = new Serial(this, "/dev/cu.LightBlue-Bean", 57600);
    sPort.bufferUntil('\n');
  }
  catch (Exception e) {
    println("Error Serial Port");
    e.printStackTrace();
    exit();
  }
}

void draw() {
  background(255);
  float angle = processHand();

  g.addPoint(angle);
  game.update(angle);
  g.draw();
  game.draw();
}

void serialEvent(Serial sPort) {
  String myString = sPort.readStringUntil('\n');

  myString = trim(myString);
  int pins[] = int(split(myString, ','));

  if (pins[0] == 0) { //button 1
    if (pins[1] == 0) {// Pressed
      Date d = new Date();
      println("Reseting Motor Positon " +  d.getTime()/1000);
      game.reset();
    }
  } else if (pins[0] == 1) {//button 2
    if (pins[1] == 0) {// Pressed
    }
  }
}  