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

  void playAudio(GameState state) {
    audios.get(getId(state)).loop(0); //make it play and stop once
  }
  boolean isPlaying(GameState state) {
    return audios.get(getId(state)).isPlaying();
  }
  private int getId(GameState state) {
    int id;
    switch(state) {
    case WAITHAND:
      id = 0;
      break;
    case START:
      id = 0;
      break;
    default:
      id = -1;
    }
    return id;
  }
}