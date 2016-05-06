float processHand() {

  int fps = leap.getFrameRate();
  if (leap.hasHands()) {
    try {
      Hand hand;
      if (!leap.getHands().isEmpty() && leap.getHands().size() > 0) {
        hand = leap.getHands().get(0);
      } else {
        return -1;
      }
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
    }  
    catch (Exception e) {
      e.printStackTrace();
      exit();
    }
    return -1;
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