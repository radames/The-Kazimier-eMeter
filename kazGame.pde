import de.voidplus.leapmotion.*;
import oscP5.*;
import netP5.*;

LeapMotion leap;
Graph g;
Game game;

PFont font;

void setup() {
  size(800, 800);
  pixelDensity(2); //for MacRetina

  background(255);
  // ...

  leap = new LeapMotion(this);
  g = new Graph(0, 0);
  game = new Game();
  
  font = createFont(PFont.list()[81], 100);
}

void draw() {
  background(255);
  float angle = processHand();

  g.addPoint(angle);
  game.update(angle);
  g.draw();
  game.draw();
}
void exit(){
  game.close();
}