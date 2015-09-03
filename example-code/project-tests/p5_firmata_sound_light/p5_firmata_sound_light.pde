import processing.sound.*;
import processing.serial.*;
import cc.arduino.*;

Arduino arduino;

int totalObjects = 5;
//Soundfile [] soundfiles = new Soundfile[totalObjects];
int [] analogReads = new int[totalObjects];
int [] thresholds = new int[totalObjects];

void setup() {
  size(470, 280);

  // Prints out the available serial ports.
  println(Arduino.list());
  arduino = new Arduino(this, Arduino.list()[11], 57600);
  
  for( int i = 0; i < analogReads.length; i++){
    analogReads[i] = 1024;
    thresholds[i] = 800;
  }
  
  //for( int i = 0; i < soundfiles.length; i++){
  //  String filename = "clip_"+i+".mp3";
  //  soundfiles[i] = new SoundFile(this, filename);
  //  soundfiles[i].loop();
  //  soundfiles[i].amp(0);
  //}
}


void draw() {
  background(0);
  
  for( int i = 0; i < analogReads.length; i++){
    analogReads[i] = arduino.analogRead(i);
    if(analogReads[i] > threshold[i]){
          //soundfiles[i].amp(0);
    }else{
          //soundfiles[i].amp(1);
    }
    
  }
  
  
  
}