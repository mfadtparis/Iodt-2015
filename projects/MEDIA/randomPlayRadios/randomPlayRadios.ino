/*
  Blink
  Turns on an LED on for one second, then off for one second, repeatedly.

  Most Arduinos have an on-board LED you can control. On the Uno and
  Leonardo, it is attached to digital pin 13. If you're unsure what
  pin the on-board LED is connected to on your Arduino model, check
  the documentation at http://www.arduino.cc

  This example code is in the public domain.

  modified 8 May 2014
  by Scott Fitzgerald
 */

int timer1 = 3000;
int timer2 = 1000;
int timer3 = 2000;
long lastTime1 = 0;
long lastTime2 = 0;
long lastTime3 = 0;
boolean radio1On = false;
boolean radio2On = false;
boolean radio3On = false;

// the setup function runs once when you press reset or power the board
void setup() {
  // initialize digital pin 13 as an output.
  pinMode(4, OUTPUT);
  pinMode(3, OUTPUT);
  pinMode(2, OUTPUT);
  Serial.begin(9600);
  lastTime1 = millis();
  lastTime2 = millis();
  lastTime3 = millis();
  timer1 = random(1500, 5000);
  timer2 = random(1500, 5000);
  timer3 = random(1500, 5000);
  Serial.begin(9600);
}

// the loop function runs over and over again forever
void loop() {

long currMillis = millis();

  // random on and off timing for each pin
  if ( currMillis - lastTime1 > timer1) {

    lastTime1 =currMillis;
    timer1 = random(1500, 5000);
    radio1On = !radio1On;

    if (radio1On) digitalWrite(2, HIGH);
    else digitalWrite(2, LOW);

    Serial.println("radio 1");
    Serial.println(radio1On);
    Serial.println(timer1);
  }


  if (currMillis - lastTime2 > timer2) {
    lastTime2 = currMillis;
    timer2 = random(1500, 5000);
    radio2On = !radio2On;

    if (radio2On) digitalWrite(3, HIGH);
    else digitalWrite(3, LOW);
    Serial.println("radio2");
    Serial.println(radio2On);
    Serial.println(timer2);
  }


  if (currMillis - lastTime3 > timer3) {
    lastTime3 = currMillis;
    timer3 = random(1500, 5000);
    radio3On = !radio3On;

    if (radio3On) digitalWrite(4, HIGH);
    else digitalWrite(4, LOW);
    Serial.println("radio3");
    Serial.println(radio3On);
    Serial.println(timer3);
  }


  delay(100);
  //  digitalWrite(3, HIGH);   // turn the LED on (HIGH is the voltage level)
  //  digitalWrite(2, HIGH);
  //  delay(3000);              // wait for a second
  //  Serial.println("high");
  //  digitalWrite(3, LOW);    // turn the LED off by making the voltage LOW
  //  digitalWrite(2, LOW);    // turn the LED off by making the voltage LOW
  //  delay(3000);              // wait for a second
  //  Serial.println("low");
}
