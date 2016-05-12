class Motor {

  NetAddress mRemoteLoc, mRemoteReset;
  OscP5 osc;

  private float angle, lastAngle;

  Motor(OscP5 _osc) {
    osc = _osc;

    //initial OSC message to restart 
    mRemoteLoc = new NetAddress("192.168.0.100", 10000);
    mRemoteReset = new NetAddress("192.168.0.100", 20000);
    resetMotor();
  }


  void setAngle(float _angle) {
    lastAngle = angle; //keep track of the last angle
    angle = _angle;

    //only send OSC if the angle changes by a small amount
    //avoid constant OSC messages
    if (abs(lastAngle - angle) > 0.003 && abs(lastAngle - angle) < 0.05) {
      OscMessage myMessage = new OscMessage("/twiz");

      //OscMessage myMessage = new OscMessage("/1/fader2");
      myMessage.add(0.0);
      myMessage.add(0.0);
      myMessage.add(angle);
      osc.send(myMessage, mRemoteLoc);
    }
  }
  void resetMotor() {
    //OscMessage myMessage = new OscMessage("/calibrate");
    //osc.send(myMessage, mRemoteReset);
    
    OscMessage myMessage = new OscMessage("/twiz");
    myMessage.add(0.0); 
    myMessage.add(0.0); 
    myMessage.add(0.0); 
    osc.send(myMessage, mRemoteLoc);
    
    lastAngle = 0;
    angle = 0;
  }
}