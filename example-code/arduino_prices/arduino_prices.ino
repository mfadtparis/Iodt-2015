
// include the library code:
#include <LiquidCrystal.h>

// initialize the library with the numbers of the interface pins
LiquidCrystal lcd(12, 11, 5, 4, 3, 2);
LiquidCrystal lcd2(12, 10, 5, 4, 3, 2);

// array of prices
float prices[]  = {
  5.0,10.0,25.0};
  
boolean objectOnPlinthe[]  = {true,true,true};

void setup() {
  // set up the number of columns and rows on the LCD 
  lcd.begin(16, 2);
  lcd.setCursor(0, 1);
  
  lcd2.begin(16, 2);
  lcd2.setCursor(0, 1);

  Serial.begin(9600);
}

void loop() {

  // check each sensor or reading
  for( int i = 0; i < 3; i++){
    if( analogRead(i) > 800){
      if(objectOnPlinthe[i] == true){
        prices[i] += 10.0;  
        objectOnPlinthe[i] = false;
        // send message to p5 to take photo
      }
    }else{
      objectOnPlinthe[i] = true;
    }

  }
  
  String nike = "Nike: $";//+prices[0]+".00";
  lcd.clear();
  lcd.print(nike);
  
  String glove = "Glove: $";//+prices[1]+".00";
  lcd2.clear();
  lcd2.print(glove);
  
  delay(10);
  
}



