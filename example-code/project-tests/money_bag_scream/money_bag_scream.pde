import processing.sound.*;
import processing.serial.*;

SoundFile soundfile;   
Serial myPort;        // The serial port

float inByte = 0;

void setup () {
  // set the window size:
  size(400, 300);        
  
  //Load a soundfile
  soundfile = new SoundFile(this, "SCREAM.mp3");
  
    // Play the file in a loop
    soundfile.loop();

  // List all the available serial ports
  // use this to find which one you are on
  println(Serial.list());

  // Open whatever port is the one you're using (may not be 7)
  myPort = new Serial(this, Serial.list()[5], 9600);

  // don't generate a serialEvent() unless you get a newline character: gets rid of noise in beginning 
  myPort.bufferUntil('\n');
}


void draw () {
  
  //if( inByte < 800 ){
  //  // playing the file
  //   background(255,0,0);
  //   soundfile.amp(1);
  //}else{
  //  // not playing the file
  //   background(0);
  //   soundfile.amp(0);
  //}
  
 soundfile.amp(inByte);

  stroke(255);
  noFill();
  ellipse(width/2, height/2, inByte, inByte);
}

void serialEvent (Serial myPort) {

  // get the ASCII string:
  String inString = myPort.readStringUntil('\n');

  if (inString != null) {
    // trim off any whitespace:
    inString = trim(inString);

    // convert to an int 
    inByte = int(inString);
    println(inByte);
    // map the data to our range (350-650 will change depending 
    // on sensor readings)
    inByte = 1 - map(inByte, 700, 900, 0, 1);
    inByte = constrain(inByte,0,1);
    
  }
}