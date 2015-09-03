import cc.arduino.*;
import org.firmata.*;

import processing.serial.*;
import processing.sound.*;

/*
Be Careful with your speaker volume, you might produce a painful 
 feedback. We recommend to wear headphones for this example.
 
 */

Arduino arduino;


AudioIn input;
Amplitude rms;
int scale=1;
int wheelThresh = 40;
int lastWheel  = 0;
int lastTime  = 0;
boolean wheelState = false;
boolean lastWheelState = false;
float ampVal = 0;
SoundFile soundfile;   
SoundFile soundfile2;   

void setup() {

  //Load a soundfile
  soundfile = new SoundFile(this, "SCREAMmono.aiff");
  soundfile.loop();
  soundfile.amp(0);

  soundfile2 = new SoundFile (this, "Ayahuasca_mono.aiff");
  soundfile2.loop();
  soundfile2.amp(0);

  size(640, 360);
  background(255);

  //Create an Audio input and grab the 1st channel
  input = new AudioIn(this, 0);

  // start the Audio Input
  input.start();

  // create a new Amplitude analyzer
  rms = new Amplitude(this);

  // Patch the input to an volume analyzer
  rms.input(input);

  println(Arduino.list());
  arduino = new Arduino(this, Arduino.list()[5], 57600);
  arduino.pinMode(9, Arduino.SERVO);

  arduino.pinMode(13, Arduino.OUTPUT);
}      


void draw() {
  background(125, 255, 125);

  // adjust the volume of the audio input
  input.amp(map(mouseY, 0, height, 0.0, 1.0));

  // rms.analyze() return a value between 0 and 1. To adjust
  // the scaling and mapping of an ellipse we scale from 0 to 0.5
  scale=int(map(rms.analyze(), 0, 0.5, 1, 180));
  noStroke();

  arduino.servoWrite(9, scale);

  fill(255, 0, 150);
  // We draw an ellispe coupled to the audio analysis
  ellipse(width/2, height/2, 1*scale, 1*scale);


  // screaming purse part
  float inByteTemp = arduino.analogRead(0);
  println(inByteTemp);
  inByteTemp = map(inByteTemp, 0, 300, 0, 1);
  inByteTemp = constrain(inByteTemp, 0, 1);

  soundfile.amp(inByteTemp); 

  // turning wheel
  int inWheelByte = arduino.analogRead(1);
  println(inWheelByte + " last "+lastWheel);

  if (inWheelByte < 100) {
    // off
    //println("off");
    wheelState = false;
  } else if (inWheelByte > 150) {
    // on
    //println("on");
    wheelState = true;
  }

  if (lastWheelState != wheelState) {
    lastTime = millis();
  }

  float speedNow = millis() - lastTime;

  float inByteTemp2 = speedNow;
  inByteTemp2 = 1 - map(inByteTemp2, 0, 10200, 0, 1);
  inByteTemp2 = constrain(inByteTemp2, 0, 1);

  if (speedNow < 800 ) {
    if (ampVal < 1) ampVal+=.1;
  } else {
    if (ampVal > 0) ampVal-=.1;
  }
  soundfile2.amp(ampVal);

  //println("speed " + speedNow + " "  + ampVal);

  lastWheelState = wheelState;

  arduino.digitalWrite(13, Arduino.HIGH);
}