import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import gab.opencv.*; 
import SimpleOpenNI.*; 
import oscP5.*; 
import netP5.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class kinect_tracking extends PApplet {






OscP5 oscP5;
NetAddress myAddress;

SimpleOpenNI kinect;
int kWidth  = 640;
int kHeight = 480;

PImage depthImg;
PImage bgImage;
int minDepth =  60;
int maxDepth = 1300;


boolean takeSnapshot = false;

float closestCenter = 1000000;
float blendClosest = 0;
int totalBlobs = 0;



PVector plinthCenter;

OpenCV opencv;

public void setup() {
  size(kWidth, kHeight);

  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();

  opencv = new OpenCV(this, 640, 480);

  depthImg = new PImage(kWidth, kHeight);
  bgImage = new PImage(kWidth, kHeight);
  plinthCenter = new PVector(width/2, height/2 - 50);

  oscP5 = new OscP5(this, 12345);
  myAddress = new NetAddress("127.0.0.1", 12345); // 127.0.0.1 is localhost

 
}

public void draw() {

  background(255*(totalBlobs/10.0f), 0, 0);
  kinect.update();

  // get array of all depth values
  int[] rawDepth = kinect.depthMap();

  // loop through each depth value and if it is within the threshold
  // set the depthImage pixel to white, if not to black
  for (int i=0; i < kWidth*kHeight; i++) {
    if (rawDepth[i] >= minDepth && rawDepth[i] <= maxDepth) {
      depthImg.pixels[i] = color(255);
    } else {
      depthImg.pixels[i] = 0;
    }
  }
  depthImg.updatePixels();


  // open cv processsing
  opencv.loadImage(depthImg);

  if (takeSnapshot) {
    bgImage = opencv.getSnapshot();
    takeSnapshot = false;
  }

  opencv.diff(bgImage);
  opencv.threshold(49);
  opencv.erode();
  opencv.dilate();
  opencv.dilate();

  // draw the thresholded image
  image(kinect.depthImage(), 0, 0);

  noFill();
  stroke(255, 0, 0);
  strokeWeight(3);
  /*
  // Another way to loop through contrours
   for (Contour contour : opencv.findContours ()) {
   contour.draw();
   }
   */

  ArrayList<Contour>contours = opencv.findContours(false, true);
  totalBlobs = 0;
  closestCenter = 1000;

  for (int i = 0; i < contours.size (); i++) {
    Contour contour = contours.get(i);

    if ( contour.area() < 300 ) {
      break;
    }

    totalBlobs++;

    float centerX = contour.getBoundingBox().x + contour.getBoundingBox().width*.5f;
    float centerY = contour.getBoundingBox().y + contour.getBoundingBox().height*.5f;
    float distToPlinth = dist(plinthCenter.x, plinthCenter.y, centerX, centerY);
    if (distToPlinth < closestCenter) {
      closestCenter = distToPlinth;
    }
    contour.draw();
  }

  fill(0, 255, 255);
  text("THRESHOLD: [" + minDepth + ", " + maxDepth + "]", 10, 36);
  text("a/s: adjust minDepth, z/x: adjust maxDepth", 10, 56);
  //println(frameRate);
  noFill();
  //float radius = map(closestCenter,100,640,100,640);
  println(closestCenter);
  closestCenter = map(closestCenter, 50, 500, 0, 1);
  if (blendClosest == 0) blendClosest = map(closestCenter, 0, 1024, 0, 1);
  blendClosest = .8f * blendClosest + .2f * closestCenter;

  //println(blendClosest);
  stroke(0, 255, 0);
  ellipse(plinthCenter.x, plinthCenter.y, blendClosest*100, blendClosest*100);
  stroke(0, 255, 255);
  ellipse(plinthCenter.x, plinthCenter.y, 100, 100);

  OscMessage myMessage = new OscMessage("/closestBlob");
  myMessage.add(blendClosest); /* add an int to the osc message */
  oscP5.send(myMessage, myAddress); 

  OscMessage myMessage2 = new OscMessage("/numBlobs");
  myMessage.add(totalBlobs); /* add an int to the osc message */
  oscP5.send(myMessage2, myAddress);
}

public void keyPressed() {
  if (key == 'a') {
    minDepth+=2;
  } else if (key == 's') {
    minDepth-=2;
  } else if (key == 'z') {
    maxDepth+=2;
  } else if (key =='x') {
    maxDepth-=2;
  } else if (key == ' ') {
    takeSnapshot = true;
  }
}

public void stop() {
  //kinect.quit();
  super.stop();
}

  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "kinect_tracking" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
