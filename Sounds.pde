//control the lights effects through OSC Messages
class Sounds {

  NetAddress mRemoteLoc;
  OscP5 osc;
  
  //keep state of the segments
  Sounds(OscP5 _osc) {
    osc = _osc;
    mRemoteLoc = new NetAddress("localhost", 10000);

  }

  void triggerAudio(int id) {
    OscMessage myMessage = new OscMessage("/sound/");
    myMessage.add(int(id)); /* add an int to the osc message */
    osc.send(myMessage, mRemoteLoc);
  }
}