import processing.serial.*; //import serial communication classes
import cc.arduino.*; //import Arduino classes

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

Serial myPort;  // Create object from Serial class
String val;     // Data received from the serial port
float finalvalue;

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
  //arduino = new Arduino(this, Arduino.list()[0], 57600); //instanciate own Arduino object
  // COM port number and baudrate
  //arduino.pinMode(sensorPin, Arduino.INPUT);
  
  String portName = Serial.list()[0]; //change the 0 to a 1 or 2 etc. to match your port
  myPort = new Serial(this, portName, 115200);
  
}

void draw() //loops forever
{
  background(0);
  
  if ( myPort.available() > 0) 
  {  // If data is available,
    val = myPort.readString();         // read it and store it in val
  }
  if(val != null){
    finalvalue = float(val);
    println(finalvalue);
    sensorValue = map(finalvalue, 0, 2000, 0, width);
  }
  move(sensorValue);
  rebond();
  ballraquette();
}

void ballraquette(){
  rect(xrect, yrect, 100, 10);
  ellipse(xball,yball,10,10);
}

void move(float localSensorValue){
  xball += xdelta;
  yball += ydelta;
  
  //sensor = arduino.analogRead(sensorPin);
  //sensorValue = map(sensor, 0, 5000, 0, width);
  xrect = (localSensorValue);
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
  }
}
