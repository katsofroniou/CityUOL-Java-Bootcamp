// Imports
import processing.sound.*;

// Variable Declarations
Sound s;
boolean pause;
boolean mute;
boolean help;
int count;
float currentVolume;
SoundFile ex, silence, pacman, currentSong;
PImage img;
String artist;
String song;

FFT fft;
int numBands = 256;
float baseLine;

// Voids
void helpMenu() {
  
  textAlign(LEFT);
  
  String title = "Help Screen";  
  String helpMessage = "a - Previous Song\ns - Next song\n, - Volume down\n. - Volume up\nm - Mute/Unmute\np - Pause/Unpause\nh - Show/Close Help menu"; 
 
  fill(200);
  rect(100, 30, 400, 250);
  fill(150);
  text(title, 150, 50);
  text(helpMessage, 150, 80);
}

void changeSong() {

  currentSong.stop();

  if (currentSong.isPlaying()) {
  } 
  
  else {

    // Chooses song out of 3
    if (count % 3 == 0) {
      currentSong = ex;
      img = loadImage("In life.jpg");
      artist = "Artist: Stray Kids    Year: 2020";
      song = "Ex";
      fft.input(currentSong);
    } 
    
    else if (count % 3 == 1) {
      currentSong = silence;
      img = loadImage("silence.jpg");
      artist = "Artist: Before You Exit    Year: 2018";
      song = "Silence";
      fft.input(currentSong);
    }
    
    else if (count % 3 == 2) {
      currentSong = pacman;
      img = loadImage("pacman.jpg");
      artist = "Artist: eaJ    Year: 2020";
      song = "Pacman";
      fft.input(currentSong);
    }
  }

  currentSong.loop();
}

void setup() {

  size(600, 300);
  
  baseLine = 20;;

  textSize(32);

  // Initialising variables
  s = new Sound(this);
  pacman = new SoundFile(this, "pacman.mp3");
  silence = new SoundFile(this, "Silence.mp3");
  ex = new SoundFile(this, "Ex.mp3");
  pause = false;
  help = false;
  currentSong = silence;
  song = "Silence";
  artist = "Artist: Before You Exit    Year: 2018";
  img = loadImage("silence.jpg");
  count = 1;
  currentVolume = 1;
  mute = false;

  // Start First Song
  currentSong.loop();
  
  fft = new FFT(this, numBands);
  fft.input(silence);
}


// Runs 60 times a second
void draw() { 
  
  background(50);

  image(img, 30, 30, 180, 180);

  fill(255);
  textSize(32);
  textAlign(CENTER, CENTER);
  text(song, 120, 235);

  textSize(20);
  textAlign(LEFT);
  text(artist, 240, 250);
 
  stroke(255);
  strokeWeight(2);
 
  fft.analyze();    // Analyse the current sound being played.
 
  beginShape();
  for (int i=0; i<fft.spectrum.length*0.4; i=i+1)
  {
    float xPos = map(i, 0, fft.spectrum.length*0.4, 240, width - 30);
    float yPos = map(sqrt(fft.spectrum[i]) / 2, 0, 1, 210, 30);
    vertex(xPos, yPos);
  }
  endShape();
 
  // Move the baseline down the screen every frame until it gets to bottom.
  baseLine++;
  if (baseLine > height-10)
  {
    baseLine = 20;
  }
  
  if (help) {
    
    helpMenu();
  }

}

void keyPressed() {
  // All Work

  switch (key) {

    // S = Skip
  case 's':
    count += 1;
    changeSong();
    break;

  case 'a':
    if (count > 0) {
      count -= 1;
      changeSong();
    } else {
      count = 0;
    }
    break;

    // Mute
  case 'm':
    if (mute == false) {
      s.volume(0);
      mute = true;
    } else {
      s.volume(currentVolume);
      mute = false;
    }
    break;

    // , = currentVolume down
  case ',':
    if (!(currentVolume <= 0)) {
      currentVolume -= 0.1;
    } else {
      currentVolume = 0;
    }
    s.volume(currentVolume);
    break;

    // . = currentVolume up
  case '.':
    if (!(currentVolume >= 1)) {
      currentVolume += 0.1;
    } else {
      currentVolume = 1;
    }
    s.volume(currentVolume);
    break;

    // p = Pause
  case 'p':
    pause = !pause;
    if (pause == true) {
      currentSong.pause();
    } else {
      currentSong.play();
    }
    break;
    
  case 'h':
    help = !help;
  }
}
