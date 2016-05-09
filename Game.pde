//global constats for times
private static final RESET_TIME = 10000; //Reset time 10s
private static final long BLOCKTIME = 6000; 


private enum GameState {
  INIT, 
    WAIT, 
    START, 
    SHUFFLE, 
    TEST, 
    STOP, 
    RESET,
};

class Game {

  OscP5 oscP5;
  Motor mMotor;
  Lights mLight;

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
  private float angle, shuffleAngle;
  private int countShuffle;
  Game() {
    oscP5 = new OscP5(this, 9000);

    mMotor = new Motor(oscP5);
    mLight = new Lights(oscP5);

    mCurrentState = GameState.INIT;
    lastMillis = 0;
    countShuffle = 0;
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

    for (int i=0; i< mLight.segments.length; i++) {
      if (mLight.segments[i] == 1) {
        pushMatrix();
        pushStyle();
        translate(width/2, height/2);
        translate(300*cos(PI+i*PI/4), 300*sin(PI+i*PI/4));
        rectMode(CENTER);
        pushMatrix();
        rotate(PI/8+(i*PI/4));
        noStroke();
        fill(255, 0, 0);
        rect(-25, -300*sqrt(2-2*cos(PI/4))/2, 50, 300*sqrt(2-2*cos(PI/4)));
        popMatrix();
        popStyle();
        popMatrix();
      }
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
      text(angle+"\nSTART\n"+str(millis() - lastMillis), width/2, height/2);
      popStyle();
    } else if (mCurrentState == GameState.SHUFFLE) {
      pushStyle();
      textSize(50);
      textAlign(CENTER, CENTER);
      textFont(font);
      text(angle+"\nSHUFFLE\n"+str(millis() - lastMillis), width/2, height/2);
      popStyle();
    } else if (mCurrentState == GameState.TEST) {
      pushStyle();
      textSize(50);
      textAlign(CENTER, CENTER);
      textFont(font);
      text(angle+"\n"+shuffleAngle+"\nTEST\n"+str(millis() - lastMillis), width/2, height/2);
      popStyle();
    } else if (mCurrentState == GameState.RESET) {
      pushStyle();
      textSize(50);
      textAlign(CENTER, CENTER);
      textFont(font);
      text("RESETING\n"+str(millis() - lastMillis), width/2, height/2);
      popStyle();
    }
  }

  void update(float _angle) {
    if (_angle!= -1) {
      angle = _angle;
    }
    if (mCurrentState == GameState.INIT) { //wait block time, init
      if (millis() - lastMillis > BLOCKTIME) {
        mCurrentState = GameState.WAIT;
        lastMillis = 0;
      }
    } else if (mCurrentState == GameState.WAIT) {
      if (_angle !=- 1) {
        mCurrentState = GameState.START;
        lastMillis = millis();
      }
    } else if (mCurrentState == GameState.START) {
      if (_angle !=- 1) {
        mMotor.setAngle(_angle);
        mLight.setAngle(_angle);
      }

      //wait for the intruction and experiment time
      if (millis() - lastMillis > 5000) {
        mCurrentState = GameState.SHUFFLE;
        lastMillis = millis();
      }
    } else if (mCurrentState == GameState.SHUFFLE) {

      if (millis() - lastMillis > 200) {
        shuffleAngle = random(0, 1);
        mLight.setAngle(shuffleAngle);
        lastMillis = millis();
        countShuffle++;
        if (countShuffle > 30 && abs(shuffleAngle-angle) > 0.006) {
          mCurrentState = GameState.TEST;
        }
      }
    } else if (mCurrentState == GameState.TEST) {
      if (_angle !=- 1) {
        mMotor.setAngle(_angle);
        if(abs(shuffleAngle-_angle) < 0.006){
          mCurrentState = GameState.SHUFFLE;
          lastMillis = millis();
          countShuffle = 0;
        }
      }
    }else if (mCurrentState == GameState.RESET) {
      if (millis() - lastMillis > RESET_TIME) {
        mCurrentState = GameState.INIT;
        lastMillis = millis();
      }
    }
  }

  void reset() {
    //only reset if it's not on reset state
    if ( mCurrentState != GameState.RESET) {
      mCurrentState = GameState.RESET;
      mMotor.resetMotor();
      mLight.resetLight();
      lastMillis = millis();
    }
  }
}