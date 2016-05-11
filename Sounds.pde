//control the lights effects through OSC Messages
class Sounds {
  final static int NUM_SOUNDS = 7;
  private ArrayList<AudioPlayer> audios;

  //keep state of the segments
  Sounds() {
    audios = new ArrayList<AudioPlayer>();
    for (int i=0; i < NUM_SOUNDS; i++) {
      AudioPlayer a = minim.loadFile(dataPath(i+".mp3"), 2048);
      audios.add(a);
    }
  }

  void triggerAudio(int id) {
      audios.get(id).loop(0); //make it play and stop once
  }
}