//global constats for times
private static final long RESET_TIME = 10000; //Reset time 10s
private static final long PAUSE_TIME = 3000; 
private static final long START_TIME = 10000; //initial start time with inial instructions 
private static final long SHUFFLE_TIME = 200; //200ms times SHUFFLE_COUNT
private static final int SHUFFLE_COUNT = 10; // number of different shuffles
private static final long MAX_ACTION_TIME = 15000; //15s max time to play
private static final int MAX_ATTEMPS = 5; //max attemps

private enum GameState {
  INIT, 
    WAITHAND, 
    START, 
    SHUFFLE, 
    ACTION, 
    SUCCESS, 
    TIMESOVER, 
    RESET, 
    PAUSE, 
    GAMEOVER
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

  private GameState mCurrentState, nextState;
  private long lastMillis;
  private float angle, lastAngle, shuffleAngle;
  private int countShuffle, maxAttempts;

  Game() {
    oscP5 = new OscP5(this, 9000);

    mMotor = new Motor(oscP5);
    mLight = new Lights(oscP5);

    mCurrentState = GameState.INIT;
    lastMillis = 0;
    countShuffle = 0;
    maxAttempts = 0;
    lastAngle = -1;
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
      stroke(0, 0, 255);
      strokeWeight(10);
      line(0, 0, 250, 0);
      popMatrix();
      popMatrix();
      popStyle();
    }

    if (shuffleAngle!=-1) {
      pushStyle();
      pushMatrix();
      translate(width/2, height/2);
      rotate(map(shuffleAngle, 1, 0, PI, -PI));
      pushMatrix();
      stroke(255, 0, 0);
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
    } else if (mCurrentState == GameState.WAITHAND) {
      pushStyle();
      textSize(50);
      textAlign(CENTER, CENTER);
      textFont(font);
      text("WAIT HAND", width/2, height/2);
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
    } else if (mCurrentState == GameState.ACTION) {
      pushStyle();
      textSize(50);
      textAlign(CENTER, CENTER);
      textFont(font);
      text(angle+"\n"+shuffleAngle+"\nACTION\n"+str(millis() - lastMillis), width/2, height/2);
      popStyle();
    } else if (mCurrentState == GameState.RESET) {
      pushStyle();
      textSize(50);
      textAlign(CENTER, CENTER);
      textFont(font);
      text("RESETING\n"+str(millis() - lastMillis), width/2, height/2);
      popStyle();
    } else if (mCurrentState == GameState.PAUSE) {
      pushStyle();
      textSize(50);
      textAlign(CENTER, CENTER);
      textFont(font);
      text("PAUSE\n"+str(millis() - lastMillis), width/2, height/2);
      popStyle();
    } else if (mCurrentState == GameState.SUCCESS) {
      pushStyle();
      textSize(50);
      textAlign(CENTER, CENTER);
      textFont(font);
      text(maxAttempts + "\nSUCCESS\n"+str(millis() - lastMillis), width/2, height/2);
      popStyle();
    } else if (mCurrentState == GameState.TIMESOVER) {
      pushStyle();
      textSize(50);
      textAlign(CENTER, CENTER);
      textFont(font);
      text(maxAttempts + "\nTIMESOVER\n"+str(millis() - lastMillis), width/2, height/2);
      popStyle();
    } else if (mCurrentState == GameState.GAMEOVER) {
      pushStyle();
      textSize(50);
      textAlign(CENTER, CENTER);
      textFont(font);
      text("GAMEOVER\n"+str(millis() - lastMillis), width/2, height/2);
      popStyle();
    }
  }

  void update(float _angle) {

    if (_angle !=- 1) {
      angle = _angle;
    }
    if (mCurrentState == GameState.INIT) { //wait block time, init
      if (millis() - lastMillis > PAUSE_TIME) {
        mCurrentState = GameState.WAITHAND;
        lastMillis = 0;
      }
    } else if (mCurrentState == GameState.WAITHAND) {
      if (_angle !=- 1) {
        mCurrentState = GameState.START;
        lastMillis = millis();
      }
    } else if (mCurrentState == GameState.START) {
      if (_angle !=- 1) {
        lastAngle = _angle; //keep the last angle in the memory
        mMotor.setAngle(_angle); //set motor position
        mLight.setAngle(_angle, 2); //set all  lights, 2 for segments and trail
      }

      //time to wait for the Audio instruction and time to experiment the sensor and lights 
      if (millis() - lastMillis > START_TIME) {
        //goto pause and start the shuffle
        mCurrentState = GameState.PAUSE;
        nextState = GameState.SHUFFLE;
        lastMillis = millis();
      }
    } else if (mCurrentState == GameState.SHUFFLE) {

      //start shuffling, 
      //also needs to be different from the last angle position
      if (millis() - lastMillis > SHUFFLE_TIME) {
        shuffleAngle = (float)1.0/floor(random(0,8));
        println(shuffleAngle);
        mLight.setAngle(shuffleAngle, 1); //send only segments lights
        lastMillis = millis();
        countShuffle++;
        if (countShuffle > SHUFFLE_COUNT && abs(shuffleAngle-lastAngle) > 0.00001) {

          mCurrentState = GameState.PAUSE;
          nextState = GameState.ACTION;
          lastMillis = millis();
        }
      }
    } else if (mCurrentState == GameState.ACTION) {
      if (_angle !=- 1) {
        mMotor.setAngle(_angle);
        mLight.setAngle(_angle, 0); //send only trail lights

        if (millis() - lastMillis < MAX_ACTION_TIME) {//
          //here is good timing
          if (abs(shuffleAngle-_angle) < 0.006) { // WIN!!

            mCurrentState = GameState.SUCCESS;
            lastMillis = millis();
            countShuffle = 0;
            maxAttempts++;
            if (maxAttempts > MAX_ATTEMPS) {
              maxAttempts = 0; 
              mCurrentState = GameState.GAMEOVER;
            }
          }
        } else {
          //times is over
          mCurrentState = GameState.TIMESOVER;
          lastMillis = millis();
          countShuffle = 0;
          maxAttempts++;
          if (maxAttempts > MAX_ATTEMPS) {
            maxAttempts = 0; 
            mCurrentState = GameState.GAMEOVER;
          }
        }
      }
    } else if (mCurrentState == GameState.SUCCESS) {
      if (millis() - lastMillis > 2000) {
        mCurrentState = GameState.SHUFFLE;
        lastMillis = millis();
      }
    } else if (mCurrentState == GameState.TIMESOVER) {
      if (millis() - lastMillis > 2000) {
        mCurrentState = GameState.SHUFFLE;
        lastMillis = millis();
      }
    } else if (mCurrentState == GameState.RESET) {
      if (millis() - lastMillis > RESET_TIME) {
        mCurrentState = GameState.INIT;
        lastMillis = millis();
        countShuffle = 0;
        maxAttempts = 0;
      }
    } else if (mCurrentState == GameState.PAUSE) {
      //general pause, it needs to pass the next state to 
      if (millis() - lastMillis > PAUSE_TIME) {
        mCurrentState = nextState;
        lastMillis = millis();
      }
    } else if (mCurrentState == GameState.GAMEOVER) {
      //general pause, it needs to pass the next state to
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