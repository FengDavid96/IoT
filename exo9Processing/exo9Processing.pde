import processing.serial.*; //import serial communication classes
import cc.arduino.*; //import Arduino classes

Arduino arduino; //declare an Arduino object
int ledPin = 13;

void setup() // runs once at start
{
//println(Arduino.list()); // use this to get port#
arduino = new Arduino(this, Arduino.list()[0], 57600); //instanciate own Arduino object
// COM port number and baudrate
arduino.pinMode(ledPin, Arduino.OUTPUT);
}

void draw() //loops forever
{
arduino.digitalWrite(ledPin, Arduino.HIGH);
delay(1000);
arduino.digitalWrite(ledPin, Arduino.LOW);
delay(1000);
}
