//control the lights effects through OSC Messages
class Lights {

  NetAddress mRemoteLoc;
  OscP5 osc;



  private float angle, lastAngle;
  private int lastSeg, currSeg;

  //keep state of the segments
  public int segments[] = new int[8];
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

    for (int i=0; i <segments.length; i++) segments[i] = 0;
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

      lastSeg = currSeg;
      currSeg = int(map(angle, 0, 1, 0, 8));
      
      //only sends message if the arrow is in a new segment
      if (abs(lastSeg - currSeg) > 0) {
        //if the current segment is off
        if (segments[currSeg] == 0) {
          //send OSC on message
          myMessage = new OscMessage("/lightSeg/" + currSeg);
          osc.send(myMessage, mRemoteLoc);
          //turn off last segment
          myMessage = new OscMessage("/lightSegOff/" + lastSeg);
          osc.send(myMessage, mRemoteLoc);
          
          segments[lastSeg] = 0;
          segments[currSeg] = 1;
          
        }
      }
    }
  }
}