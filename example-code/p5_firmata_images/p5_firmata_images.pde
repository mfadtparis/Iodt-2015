/*
Install standard firmata on arduino
 
 In the data folder of this sketch are the images. You can replace these with new images but keep the filenames the same:
 image_0.png
 image_1.png
 etc
 
 To add more images change the value of totalObjects below (currently set to 2)
 For example: int totalObjects = 3;
(the number of images must be at least the number of totalbjects)

 Set the correct serial port for your computer changing 0 to whatever your port number is:
 For example, for port 7: arduino = new Arduino(this, Arduino.list()[7], 57600);
 
 Change the screen size to your screen res:
 For example:   size(1280, 800);
 
 To go full screen, instead of run/play, use Sketch --> Present
 
 To run in Demo Mode: Press Space bar (you will see a white do in the corner)
 Press any key 0 to 5 to toggle images 0 to 5
 */

import processing.sound.*;
import processing.serial.*;
import cc.arduino.*;

Arduino arduino;

int totalObjects = 3; // num inputs

PImage [] infoImages = new PImage[totalObjects];
int [] analogReads = new int[totalObjects];
int [] thresholds = new int[totalObjects];
float [] alphas = new float[totalObjects];

boolean debugMode = false;

void setup() {
  size(1280, 800);

  // Prints out the available serial ports.
  println(Arduino.list());
  arduino = new Arduino(this, Arduino.list()[0], 57600);

  for ( int i = 0; i < analogReads.length; i++) {
    analogReads[i] = 1024;
    thresholds[i] = 200;
    alphas[i] = 0;
  }



  for ( int i = 0; i < infoImages.length; i++) {
    String filename = "image_"+i+".png";
    infoImages[i] = loadImage(filename);
  }
}


void draw() {
  background(0);

  imageMode(CENTER);

  for ( int i = 0; i < analogReads.length; i++) {
    analogReads[i] = arduino.analogRead(i);
    if (analogReads[i] > thresholds[i]) {
      if (alphas[i] < 255) alphas[i] += 2;
    } else {
      if (alphas[i] > 0) alphas[i] -= 2;
    }

    tint(255, alphas[i]);
    image(infoImages[i], width/2, height/2);
  }

  if (debugMode) {
    fill(255);
    ellipse(10, 10, 4, 4);
  }
}

void keyPressed() {


  if ( key == ' ') {
    debugMode = !debugMode;
    if (!debugMode) {
      for ( int i = 0; i < thresholds.length; i++) {
        thresholds[i] = 200;
      }
    }
  }

  if ( debugMode) {
    if (key == '0') {
      for ( int i = 0; i < thresholds.length; i++) {
        thresholds[i] = 1000;
      }
      if (thresholds.length > 0) thresholds[0] = -1;
    } else if (key == '1') {
      for ( int i = 0; i < thresholds.length; i++) {
        thresholds[i] = 1000;
      }
      if (thresholds.length > 1) thresholds[1] = -1;
    } else if (key == '2') {
      for ( int i = 0; i < thresholds.length; i++) {
        thresholds[i] = 1000;
      }
      if (thresholds.length > 2) thresholds[2] = -1;
    } else if (key == '3') {
      for ( int i = 0; i < thresholds.length; i++) {
        thresholds[i] = 1000;
      }
      if (thresholds.length > 3) thresholds[3] = -1;
    } else if (key == '4') {
      for ( int i = 0; i < thresholds.length; i++) {
        thresholds[i] = 1000;
      }
      if (thresholds.length > 4) thresholds[4] = -1;
    } else if (key == '5') {
      for ( int i = 0; i < thresholds.length; i++) {
        thresholds[i] = 1000;
      }
      if (thresholds.length > 5) thresholds[5] = -1;
    }
  }
}