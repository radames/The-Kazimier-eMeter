//control the lights effects through OSC Messages
class Lights {
  
  NetAddress mRemoteLoc;
  OscP5 osc;

  private float angle, lastAngle;

  Lights(OscP5 _osc) {
    osc = _osc;

    mRemoteLoc = new NetAddress("192.168.0.8", 3000);
    
    OscMessage myMessage;
    for (int i=0; i<8; i++) {
      myMessage = new OscMessage("/lightSegOff/"+i);
      osc.send(myMessage, mRemoteLoc);
    }
    
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

      OscMessage myMessage = new OscMessage("/light/1");
      myMessage.add(angle); /* add an int to the osc message */
      osc.send(myMessage, mRemoteLoc);

      int seg = int(map(angle, 0, 1, 0, 8));
      //myMessage = new OscMessage("/lightSeg/"+seg);
      myMessage = new OscMessage("/lightSegOff/"+seg);
      osc.send(myMessage, mRemoteLoc);
    }
  }
}