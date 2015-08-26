// Dave Robertson - 2013 dhrobertson.com
//
// Simple E-mail Checking - tweaked from // Daniel Shiffman http://www.shiffman.net
//
// This code requires the Java mail library - current version 1.4.7
// All jars in the code folder 
// Download: http://www.oracle.com/technetwork/java/javasebusiness/downloads/java-archive-downloads-eeplat-419426.html#javamail-1.4.7-oth-JPR
// Best to google it
// Note: for gmail you will need to allow less secure apps access to work (at your own risk!)

import javax.mail.*;
import javax.mail.internet.*;

void setup() {
  
  size(200,200);
  
  // Function to check mail
  //checkMail();
  
  // Function to send mail
  sendMail();
  
  noLoop();
}
