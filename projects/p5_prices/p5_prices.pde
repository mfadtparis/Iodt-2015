import processing.serial.*;
import cc.arduino.*;

Arduino arduino;
int priceShoe = 5;
boolean shoeOff = false;

void setup() {
  size(470, 280);

  // Prints out the available serial ports.
  println(Arduino.list());
  
  // Modify this line, by changing the "0" to the index of the serial
  // port corresponding to your Arduino board (as it appears in the list
  // printed by the line above).
  arduino = new Arduino(this, Arduino.list()[11], 57600);
  
 
}

void draw() {
  background(0);
 
  int val = arduino.analogRead(0);
  println(val);
  
  if( val > 700 ){
    if(shoeOff == false){ 
      priceShoe+=10; 
    }
    shoeOff = true;
  }else{
    shoeOff = false;
  }
  
  fill(255);
  textSize(24);
  text("Shoe $ "+priceShoe,50,50);
}
