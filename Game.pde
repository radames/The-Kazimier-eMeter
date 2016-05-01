
private enum GameState {
  INIT, 
    WAIT, 
    START, 
    STOP
};

class Game {

  OscP5 oscP5;
  NetAddress myRemoteLocation;
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
  private long OSClastMillis;

  private float angle;

  Game() {
    oscP5 = new OscP5(this, 9000);
    myRemoteLocation = new NetAddress("192.168.0.100", 10000);
    OscMessage myMessage = new OscMessage("/1/fader1");
    myMessage.add(0.6); 
    oscP5.send(myMessage, myRemoteLocation);
    myRemoteLocation = new NetAddress("192.168.0.100", 20000);

    mCurrentState = GameState.INIT;
    lastMillis = 0;
    OSClastMillis = 0;
    sendAngle(0); // start Arrow at 0
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
        sendAngle(angle);
      }
    }
  }

  void sendAngle(float a) {

    OscMessage myMessage = new OscMessage("/1/fader2");
    myMessage.add(a); /* add an int to the osc message */
    if (millis() - OSClastMillis > 10) {
      oscP5.send(myMessage, myRemoteLocation);
      OSClastMillis = millis();
    }
  }
}