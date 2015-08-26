// Dave Robertson - 2013 dhrobertson.com
//
// Simple E-mail Checking - tweaked from // Daniel Shiffman http://www.shiffman.net
//
// This code requires the Java mail library - current version 1.4.7
// All jars in the code folder 
// Download: http://www.oracle.com/technetwork/java/javasebusiness/downloads/java-archive-downloads-eeplat-419426.html#javamail-1.4.7-oth-JPR
// Best to google it

import java.util.Properties;
import java.io.*;
import java.util.*;
import javax.mail.*;
import javax.mail.Flags.Flag;
import javax.mail.internet.*;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;


// A function to check a mail account - IMAP
void checkMail() {
  try {

    IMAPFolder folder = null;
    Store store = null;
    String subject = null;
    Flag flag = null;
    try 
    {
      Properties props = System.getProperties();
      props.setProperty("mail.store.protocol", "imaps");
      props.put("mail.imaps.host", "imap.gmail.com");

      // Create authentication object
      Auth auth = new Auth();

      // Make a session
      Session session = Session.getDefaultInstance(props, auth);
      store = session.getStore("imaps");

      store.connect();

      folder = (IMAPFolder) store.getFolder("Inbox"); 

      if (!folder.isOpen())
        folder.open(Folder.READ_WRITE);

      Message[] messages = folder.getMessages();
      System.out.println("No of Messages : " + folder.getMessageCount());
      System.out.println("No of Unread Messages : " + folder.getUnreadMessageCount());
      System.out.println(messages.length);

      for (int i=0; i < 10;i++)
        //for (int i=0; i < messages.length;i++) 
      {

        System.out.println("*****************************************************************************");
        System.out.println("MESSAGE " + (i + 1) + ":");
        Message msg =  messages[i];
        //System.out.println(msg.getMessageNumber());
        //Object String;
        //System.out.println(folder.getUID(msg)

        subject = msg.getSubject();

        System.out.println("Subject: " + subject);
        System.out.println("From: " + msg.getFrom()[0]);
        System.out.println("To: "+msg.getAllRecipients()[0]);
        System.out.println("Date: "+msg.getReceivedDate());
        System.out.println("Size: "+msg.getSize());
        System.out.println(msg.getFlags());
        System.out.println("Body: \n"+ msg.getContent());
        System.out.println(msg.getContentType());
      }
    }
    finally 
    {
      if (folder != null && folder.isOpen()) { 
        folder.close(true);
      }
      if (store != null) { 
        store.close();
      }
    }
  }


  // This error handling isn't very good
  catch (Exception e) {
    System.out.println("Failed to connect to the store");
    e.printStackTrace();
  }
}


// Function to send email - IMAP

void sendMail() 

{
  try {

    Properties props = new Properties();

    props.put("mail.smtp.host", "smtp.gmail.com");
    props.put("mail.smtp.socketFactory.port", "465");
    props.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
    props.put("mail.smtp.auth", "true");
    props.put("mail.smtp.port", "465");
  
    // Create authentication object
    Auth auth = new Auth();

    Session session = Session.getDefaultInstance(props, auth);

    try {

      Message message = new MimeMessage(session);
      message.setFrom(new InternetAddress("FROM EMAIL HERE"));
      message.setRecipients(Message.RecipientType.TO, InternetAddress.parse("YOUR EMAIL HERE"));
      message.setSubject("Email from Processing! Woot!");
      message.setText("Hello World!");

      Transport.send(message);

      System.out.println("Done");
    } 

    finally 
    {
      //session.close();
    }
  }
  catch (MessagingException e) 
  {
    throw new RuntimeException(e);
  }
}

