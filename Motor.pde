class Motor {

  NetAddress mRemoteLoc;
  OscP5 osc;

  private float angle, lastAngle;

  Motor(OscP5 _osc) {
    osc = _osc;

    //initial OSC message to restart 
    mRemoteLoc = new NetAddress("192.168.0.100", 20000);
    startMotor();
    resetMotor();
    lastAngle = 0;
    angle = 1;
    setAngle(ZEROANG);
  }


  void setAngle(float _angle) {
    lastAngle = angle; //keep track of the last angle
    angle = _angle;

    //only send OSC if the angle changes by a small amount
    //avoid constant OSC messages
    if (abs(lastAngle - angle) > 0.002) {

      OscMessage myMessage = new OscMessage("/1/fader2");
      myMessage.add(angle); /* add an int to the osc message */
      osc.send(myMessage, mRemoteLoc);
    }
  }
  void startMotor() {
    OscMessage myMessage = new OscMessage("/1/fader1");
    myMessage.add(0.6); 
    osc.send(myMessage, mRemoteLoc);
  }
  void resetMotor() {
    OscMessage myMessage = new OscMessage("/calibrate");
    osc.send(myMessage, mRemoteLoc);
  }
}