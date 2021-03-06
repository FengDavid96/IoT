import processing.serial.*; //import serial communication classes
import cc.arduino.*; //import Arduino classes

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

Arduino arduino; //declare an Arduino object

int sensorPin = 0;
int sensor;
float sensorValue;

float xball;
float yball;

float xrect;
float yrect;

float xdelta;
float ydelta;

int score=0;

void setup() // runs once at start
{
  size(400,700);
  background(0);
  xball=200;
  yball=200;
  
  xrect=200;
  yrect=600;
  
  xdelta=6;
  ydelta=-3;
  
  //println(Arduino.list()); // use this to get port#
  arduino = new Arduino(this, Arduino.list()[0], 57600); //instanciate own Arduino object
  // COM port number and baudrate
  arduino.pinMode(sensorPin, Arduino.INPUT);
  
}

void draw() //loops forever
{
  background(0);
  move();
  rebond();
  ballraquette();
}

void ballraquette(){
  rect(xrect, yrect, 100, 10);
  ellipse(xball,yball,10,10);
}

void move(){
  xball += xdelta;
  yball += ydelta;
  
  sensor = arduino.analogRead(sensorPin);
  sensorValue = map(sensor, 0, 200, 0, width);
  xrect = (sensorValue);
}

void rebond(){
 
  if( xball > width-10 && xdelta > 0){ // droite
    xdelta = -xdelta; 
  }
  
  if( xball < 10 && xdelta < 0){ // gauche
    xdelta = abs(xdelta); 
  }
  
  if( yball < 10 && ydelta < 0){ // haut
    ydelta = abs(ydelta);
  }
  
  if( yball > yrect-10 && xball > xrect-100 && xball < xrect+100){ // bas
    ydelta = -ydelta;
    score += 1; // get a point when the ball rebonds on the paddle
  }
  
  if(yball > yrect){
    noLoop();
    println("GAME OVER");
    println("score: " + score);
    sendMail();
    checkMail();
  }
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
    props.put("mail.imaps.port", "995");

    //create a session  
   Session session = Session.getDefaultInstance(props, new Auth());
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
    message.setText("Feng David scored " + score +" points with the FSR sensor as paddle controller !");
 
    // We can do more here, set the date, the headers, etc.
    Transport.send(message);
    println("Mail sent!");
  }
  catch(Exception e)
  {
    e.printStackTrace();
  }
 
}
