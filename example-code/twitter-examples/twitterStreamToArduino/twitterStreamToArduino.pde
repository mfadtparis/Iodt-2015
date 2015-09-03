/*
* Twitter4j streaming that sends message to serial (arduino)
 */

import processing.serial.*;

static String OAuthConsumerKey = "";
static String OAuthConsumerSecret = "";
static String AccessToken = "";
static String AccessTokenSecret = "";

// if you enter keywords here it will filter, otherwise it will sample
String keywords[] = {
  "#parsons",
  "parsons"
};

TwitterStream twitter = new TwitterStreamFactory().getInstance();

PFont font;

Serial myPort;  // Create object from Serial class
boolean ledOn = false;
float lastTimeOn = 0;

void setup() {

  size(700, 200);
  background(0);
  smooth();

  font = createFont("Helvetica-bold", 22);

  String portName = Serial.list()[11];
  myPort = new Serial(this, portName, 9600);

  connectTwitter();
  twitter.addListener(listener);
  if (keywords.length==0) twitter.sample();
  else twitter.filter(new FilterQuery().track(keywords));
}

void draw() {

  if ( ledOn ) {
    myPort.write('H');
    if ( millis() - lastTimeOn > 500) {
      ledOn = false;
    }
  } else {
    myPort.write('L');
  }
}

void mousePressed() {
  ledOn = true;
  lastTimeOn = millis();
}

//-------------------------------- 
// Initial connection
void connectTwitter() {
  twitter.setOAuthConsumer(OAuthConsumerKey, OAuthConsumerSecret);
  AccessToken accessToken = loadAccessToken();
  twitter.setOAuthAccessToken(accessToken);
}

// Loading up the access token
private static AccessToken loadAccessToken() {
  return new AccessToken(AccessToken, AccessTokenSecret);
}

// This listens for new tweet
StatusListener listener = new StatusListener() {
  public void onStatus(Status status) {

    //println("@" + status.getUser().getScreenName() + " - " + status.getText());
    displayTw(status);
  }


  public void onDeletionNotice(StatusDeletionNotice statusDeletionNotice) {
    //System.out.println("Got a status deletion notice id:" + statusDeletionNotice.getStatusId());
  }
  public void onTrackLimitationNotice(int numberOfLimitedStatuses) {
    //  System.out.println("Got track limitation notice:" + numberOfLimitedStatuses);
  }
  public void onScrubGeo(long userId, long upToStatusId) {
    System.out.println("Got scrub_geo event userId:" + userId + " upToStatusId:" + upToStatusId);
  }

  public void onException(Exception ex) {
    ex.printStackTrace();
  }
  public void onStallWarning(StallWarning w) {
  }
};


/// my dirt test method for displaying tweets
void displayTw (Status s)
{

  ledOn = true;
  lastTimeOn = millis();

  String who = "";
  String time = "";
  String txt = "";
  String where = "";
  who = s.getUser().getScreenName();
  time = s.getCreatedAt().toString();
  txt = s.getText();
  GeoLocation g =s.getGeoLocation();
  if (g!=null)where = g.toString();

  fill(0);
  noStroke();
  rect(0, 0, width, height);
  fill(255, 200, 50);
  textFont(font, 40);
  text("from: @"+ who, 10, height-150);

  textSize(20);
  text(txt, 10, height-130, width-10, 100);
  //text("when: "+ time, 10, height-10);
  //text("where: "+ where, 10, height-50);
}



/*
  // Wiring/Arduino code:
 // Read data from the serial and turn ON or OFF a light depending on the value
 
 char val; // Data received from the serial port
 int ledPin = 13; // Set the pin to digital I/O 4
 
 void setup() {
 pinMode(ledPin, OUTPUT); // Set pin as OUTPUT
 Serial.begin(9600); // Start serial communication at 9600 bps
 }
 
 void loop() {
 if (Serial.available()) { // If data is available to read,
 val = Serial.read(); // read it and store it in val
 }
 if (val == 'H') { // If H was received
 digitalWrite(ledPin, HIGH); // turn the LED on
 } else {
 digitalWrite(ledPin, LOW); // Otherwise turn it OFF
 }
 delay(100); // Wait 100 milliseconds for next reading
 }
 
 */

