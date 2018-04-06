import javax.mail.*;
import javax.mail.internet.*;
import java.util.*;
import javax.mail.Authenticator;
import javax.mail.PasswordAuthentication;

import javax.mail.search.*;
import com.sun.mail.imap.*;
import java.io.*;
 
import java.util.Properties;
import javax.mail.Folder;
import javax.mail.Session;
import javax.mail.Store;

void setup() {
  
  noLoop();
  // Function to check mail
  //checkMail();
  // Function to send mail
  //sendMail();
}
 
public class Auth extends Authenticator {
 
  public Auth() {
    super();
  }
 
  public PasswordAuthentication getPasswordAuthentication() {
    String username, password;
    username = "fyhdavid@gmail.com";
    password = "mdp";
    System.out.println("authenticating. . ");
    return new PasswordAuthentication(username, password);
  }
}

// A function to check mail
void checkMail() { 
  try {
    Properties props = System.getProperties();
    props.put("mail.store.protocol", "imaps");
    props.put("mail.imaps.host", "imap.gmail.com");
    
    // These are security settings required for gmail
    // May need different code depending on the account
    props.put("mail.imaps.port", "993");

    //create a session  
   Session session = Session.getDefaultInstance(props, null);
   //SET the store for IMAPS
   Store store = session.getStore("imaps");
 
   System.out.println("Connection initiated......");
   //Trying to connect IMAP server
   store.connect("fyhdavid@gmail.com", "mdp");
   System.out.println("Connection is ready :)");
 
 
   //Get inbox folder 
   Folder inbox = store.getFolder("inbox");
   //SET readonly format (*You can set read and write)
   inbox.open(Folder.READ_ONLY);
 
   //Inbox email count
   int messageCount = inbox.getMessageCount();
   System.out.println("Total Messages in INBOX:- " + messageCount);
 
   //Print Last 10 email information
   for (int i = 10; i > 0; i--) {
    System.out.println("Mail Subject:- " + inbox.getMessage(messageCount - i).getSubject());
    System.out.println("Mail From:- " + inbox.getMessage(messageCount - i).getFrom()[0]);
    System.out.println("Mail Content:- " + inbox.getMessage(messageCount - i).getContent().toString());
    System.out.println("------------------------------------------------------------");
   }
 
   inbox.close(true);
   store.close();
    }
  catch(Exception e)
  {
    e.printStackTrace();
  }
}



// A function to send mail
void sendMail() {
  // Create a session
  String host="smtp.gmail.com";
  Properties props=new Properties();
 
  // SMTP Session
  props.put("mail.smtp.from", "fyhdavid@gmail.com");
  props.put("mail.smtp.host", host);
  props.put("mail.smtp.ssl.trust", host);
  props.put("mail.smtp.port", "587");
  props.put("mail.smtp.auth", "true");
  // We need TTLS, which gmail requires
  props.put("mail.smtp.starttls.enable","true");
 
  // Create a session
  Session session = Session.getDefaultInstance(props, new Auth());
 
  try
  {
    // Make a new message
    MimeMessage message = new MimeMessage(session);
 
    // Who is this message from
    message.setFrom(new InternetAddress("fyhdavid@gmail.com", "Feng David"));
 
    // Who is this message to (we could do fancier things like make a list or add CC's)
    message.setRecipients(Message.RecipientType.TO, InternetAddress.parse("feng_yu_hui_david@hotmail.fr", false));
 
    // Subject and body
    message.setSubject("New update !");
    message.setText("Feng David scored with the FSR sensor as paddle controller !");
 
    // We can do more here, set the date, the headers, etc.
    Transport.send(message);
    println("Mail sent!");
  }
  catch(Exception e)
  {
    e.printStackTrace();
  }
 
}
