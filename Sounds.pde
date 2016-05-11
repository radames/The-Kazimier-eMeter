//control the lights effects through OSC Messages
class Sounds {
  final static int NUM_SOUNDS = 7;
  private AudioPlayer[] audios;

  //keep state of the segments
  Sounds() {
    audios = new AudioPlayer[7];  
    for (int i=0; i < NUM_SOUNDS; i++) {
      audios[i] = minim.loadFile(dataPath(i+".wav"), 2048);
    }
  }

  void playAudio(GameState state) {
    audios[getId(state)].loop(0); //make it play and stop once
  }
  boolean isPlaying(GameState state) {
    return audios[getId(state)].isPlaying();
  }
  private int getId(GameState state) {
    int id;
    switch(state) {
    case WAITHAND:
      id = 0;
      break;
    case START:
      id = 1;
      break;
    case ACTION:
      id = 2;
      break;
    case SUCCESS:
      id = 3;
      break;
    case TIMESOVER:
      id = 4;
      break;
    case SHUFFLE:
      id = 5;
      break;
    case GAMEOVER:
      id = 6;
      break;
    default:
      id = -1;
      break;
    }
    return id;
  }
}