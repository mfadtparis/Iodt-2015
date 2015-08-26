// Dave Robertson - 2013 dhrobertson.com
//
// Simple E-mail Checking - tweaked from // Daniel Shiffman http://www.shiffman.net
//
// This code requires the Java mail library - current version 1.4.7
// All jars in the code folder 
// Download: http://www.oracle.com/technetwork/java/javasebusiness/downloads/java-archive-downloads-eeplat-419426.html#javamail-1.4.7-oth-JPR
// Best to google it

// Simple Authenticator          
// Careful, this is still terribly unsecure!!

import javax.mail.Authenticator;
import javax.mail.PasswordAuthentication;

public class Auth extends Authenticator {

  public Auth() {
    super();
  }

  public PasswordAuthentication getPasswordAuthentication() {
    String username, password;
    username = "YOUR EMAIL ADDRESS";
    password = "YOUR PASSWORD";
    System.out.println("authenticating. . ");
    return new PasswordAuthentication(username, password);
  }
}
