
private enum GameState {
  INIT, 
    WAIT, 
    START, 
    STOP
};

class Game {

  OscP5 oscP5;
  NetAddress myRemoteLocation;
  NetAddress lightServer;

  private static final long BLOCKTIME = 5000;  
  /*
  WAITING mode - 
   send OSC message Wait music 
   
   IF hand detected START  
   
   START -
   -- OSC Sound for Start Game... 
   -- wait Xs (sound start lenght)
   -- random position for the arrow - 1/8
   -- 
   
   STOP 
   --- Wait until user take out HAND
   
   */

  private GameState mCurrentState;
  private long lastMillis;
  private float angle, lastAngle, lightAngle;

  Game() {
    oscP5 = new OscP5(this, 9000);
    //initial OSC message to restart 
    myRemoteLocation = new NetAddress("192.168.0.100", 20000);

    OscMessage myMessage = new OscMessage("/1/fader1");
    myMessage.add(0.6); 
    oscP5.send(myMessage, myRemoteLocation);

    lightServer = new NetAddress("192.168.0.8", 3000);

    for (int i=0; i<8; i++) {
      myMessage = new OscMessage("/lightSegOff/"+i);
      oscP5.send(myMessage, lightServer);
    }

    mCurrentState = GameState.INIT;
    lastMillis = 0;
    lastAngle = 1;
    angle = 0; //start angle 0
    setMotorAngle();
  }


  void draw() {



    pushMatrix();
    pushStyle();
    translate(width/2, height/2);
    strokeWeight(5);
    stroke(255, 100, 0);
    fill(50, 50, 50, 100);
    beginShape();
    for (int i = 0; i < 8; i++) {
      vertex(300*cos(i*PI/4), 300*sin(i*PI/4));
    }
    endShape(CLOSE);
    popStyle();
    popMatrix();

    if (angle!=-1) {
      pushStyle();
      pushMatrix();
      translate(width/2, height/2);
      rotate(map(angle, 1, 0, PI, -PI));
      pushMatrix();
      stroke(255, 200, 0);
      strokeWeight(10);
      line(0, 0, 250, 0);
      popMatrix();
      popMatrix();
      popStyle();
      setMotorAngle();
      setLightRing();
    }




    if (mCurrentState == GameState.INIT) {
      pushStyle();
      textSize(50);
      textAlign(CENTER, CENTER);
      textFont(font);
      text("INIT\n"+str(millis() - lastMillis), width/2, height/2);
      popStyle();
    } else if (mCurrentState == GameState.WAIT) {
      pushStyle();
      textSize(50);
      textAlign(CENTER, CENTER);
      textFont(font);
      text("WAITING", width/2, height/2);
      popStyle();
    } else if (mCurrentState == GameState.START) {
      pushStyle();
      textSize(50);
      textAlign(CENTER, CENTER);
      textFont(font);
      text("START\n"+str(millis() - lastMillis), width/2, height/2);
      popStyle();
    }
  }

  void update(float _angle) {
    lastAngle = angle; //keep track of the last angle
    angle = _angle;
    if (angle !=- 1 && mCurrentState == GameState.WAIT ) {
      mCurrentState = GameState.START;
      lastMillis = millis();
    }

    if (mCurrentState == GameState.INIT) { //wait block time, init
      if (millis() - lastMillis > BLOCKTIME) {
        mCurrentState = GameState.WAIT;
        lastMillis = 0;
      }
    } else if (mCurrentState == GameState.WAIT) {
    } else if (mCurrentState == GameState.START) {
      if (angle !=- 1) {
        setMotorAngle();
      }
    }
  }

  void setMotorAngle() {
    //only send OSC if the angle
    if (abs(lastAngle - angle) > 0.002) {

      OscMessage myMessage = new OscMessage("/1/fader2");
      myMessage.add(angle); /* add an int to the osc message */
      oscP5.send(myMessage, myRemoteLocation);
    }
  }

  void setLightRing() {
    //only send OSC if the angle
    if (abs(lastAngle - angle) > 0.002) {

      OscMessage myMessage = new OscMessage("/light/1");
      myMessage.add(angle); /* add an int to the osc message */
      oscP5.send(myMessage, lightServer);




      int seg = int(map(angle, 0, 1, 0, 8));
      //myMessage = new OscMessage("/lightSeg/"+seg);
      myMessage = new OscMessage("/lightSegOff/"+seg);
      oscP5.send(myMessage, lightServer);
    }
  }
}