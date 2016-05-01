import de.voidplus.leapmotion.*;
import oscP5.*;
import netP5.*;



LeapMotion leap;
Graph g;
Game game;

PFont font;

float initAngle = -1;

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

float processHand() {

  int fps = leap.getFrameRate();
  if (leap.hasHands()) {
    Hand hand = leap.getHands().get(0);

    // ----- BASICS -----

    int     hand_id          = hand.getId();
    PVector hand_position    = hand.getPosition();
    PVector hand_stabilized  = hand.getStabilizedPosition();
    PVector hand_direction   = hand.getDirection();
    PVector hand_dynamics    = hand.getDynamics();
    float   hand_roll        = hand.getRoll();
    float   hand_pitch       = hand.getPitch();
    float   hand_yaw         = hand.getYaw();
    boolean hand_is_left     = hand.isLeft();
    boolean hand_is_right    = hand.isRight();
    float   hand_grab        = hand.getGrabStrength();
    float   hand_pinch       = hand.getPinchStrength();
    float   hand_time        = hand.getTimeVisible();
    PVector sphere_position  = hand.getSpherePosition();
    float   sphere_radius    = hand.getSphereRadius();


    float centerY = height/2;
    float centerX = width/2;

    //pushMatrix();
    //translate(centerX, centerY);
    //ellipse(0, 0, 20, 20);
    //popMatrix();

    //line(hand_position.x, hand_position.y, centerX, centerY);

    float x = hand_position.x - centerX;
    float y = hand_position.y - centerY;

    float r = sqrt(x*x + y*y);
    float a = atan2(y, x);
    float aN = map(a, PI, -PI, 1, 0);

    //println(aN);

    //pushStyle();
    //pushMatrix();
    //translate(centerX, centerY);
    //rotate(a);
    //pushMatrix();
    //stroke(255, 0, 0);
    //strokeWeight(4);
    //line(0, 0, 100, 0);
    //popMatrix();
    //popMatrix();
    //popStyle();

    pushStyle();
    textSize(10);
    for (Finger finger : hand.getFingers()) {


      finger.draw(); // = drawBones()+drawJoints()
      finger.drawBones();
      finger.drawJoints();
    }
    popStyle();

    return aN;
  } else {
    return -1;
  }
}


// ========= CALLBACKS =========

void leapOnInit() {
  // println("Leap Motion Init");
}
void leapOnConnect() {
  // println("Leap Motion Connect");
}
void leapOnFrame() {
  // println("Leap Motion Frame");
}
void leapOnDisconnect() {
  // println("Leap Motion Disconnect");
}
void leapOnExit() {
  // println("Leap Motion Exit");
}