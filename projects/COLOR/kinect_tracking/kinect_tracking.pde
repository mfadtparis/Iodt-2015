import org.openkinect.freenect.*;
import org.openkinect.tests.*;
import org.openkinect.processing.*;
import org.openkinect.freenect2.*;

import gab.opencv.*;
import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myAddress;

Kinect kinect;
int kWidth  = 640;
int kHeight = 480;

PImage depthImg;
PImage bgImage;
int minDepth =  60;
int maxDepth = 830;


boolean takeSnapshot = false;

float closestCenter = 1000000;
float blendClosest = 0;
int totalBlobs = 0;



PVector plinthCenter;

OpenCV opencv;

void setup() {
  size(kWidth, kHeight);

  kinect = new Kinect(this);
  kinect.initDepth();

  opencv = new OpenCV(this, 640, 480);

  depthImg = new PImage(kWidth, kHeight);
  bgImage = new PImage(kWidth, kHeight);
  plinthCenter = new PVector(width/2, height/2 - 50);

  oscP5 = new OscP5(this, 12344);
  myAddress = new NetAddress("127.0.0.1", 12345); // 127.0.0.1 is localhost

 
}

void draw() {

  background(255*(totalBlobs/10.0), 0, 0);
  //kinect.update();

  // get array of all depth values
  int[] rawDepth = kinect.getRawDepth();

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
  image(kinect.getDepthImage(), 0, 0);

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

    float centerX = contour.getBoundingBox().x + contour.getBoundingBox().width*.5;
    float centerY = contour.getBoundingBox().y + contour.getBoundingBox().height*.5;
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
  if (blendClosest == 0) blendClosest = map(closestCenter, 50, 1024, 0, 1);
  blendClosest = .8 * blendClosest + .2 * closestCenter;

  //println(blendClosest);
  stroke(0, 255, 0);
  ellipse(plinthCenter.x, plinthCenter.y, blendClosest*400, blendClosest*400);
  stroke(0, 255, 255);
  ellipse(plinthCenter.x, plinthCenter.y, 100, 100);

  OscMessage myMessage = new OscMessage("/closestBlob");
  myMessage.add(blendClosest); /* add an int to the osc message */
  oscP5.send(myMessage, myAddress); 

  OscMessage myMessage2 = new OscMessage("/numBlobs");
  myMessage.add(totalBlobs); /* add an int to the osc message */
  oscP5.send(myMessage2, myAddress);
}

void keyPressed() {
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

void stop() {
  //kinect.quit();
  super.stop();
}

