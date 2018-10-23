// o/p interior light
// l/m exterior light
// s/r msg
// n get lux sensor value
// c/v/h call/receive/hang up a phone call
// i informations
// T all combinations
// w/x open/close garage door

// motor
#include <Stepper.h>
#define STEPS 2038 // the number of steps in one revolution of your motor (28BYJ-48)
Stepper stepper(STEPS, 4, 6, 5, 7);

#include <SoftwareSerial.h>
//TXD,RXD,GRD
SoftwareSerial mySerial(9, 10);
char msg;
char call;
String phoneNumber = "33620951231";

int ExteriorLightStatus = 0;
int InteriorLightStatus = 0;
String LuxSensorValue;
int GarageDoorStatus = 0;

//Interior light, led 13
int led13 = 13;

//Exterior light, led 2
int led2 = 2;
  
//Lux sensor
#include <Wire.h>
#include <Adafruit_Sensor.h>
#include <Adafruit_TSL2561_U.h>
Adafruit_TSL2561_Unified tsl = Adafruit_TSL2561_Unified(TSL2561_ADDR_FLOAT, 12345);

// phone number of the sms/call received
String phoneNumberReceived;

// phone number known
String phoneNumberRef1="33620951231";
String phoneNumberRef2="0620951231";

// content of the sms received
String buf;
String buftemp;

void setup()
{
  // Setting the baud rate of Serial Monitor (Arduino)
  Serial.begin(9600);
  
  // Interior light
  pinMode(led13, OUTPUT);
  // Exterior light
  pinMode(led2, OUTPUT);

  // GSM SIM900 configuration
  mySerial.begin(9600);   // Setting the baud rate of GSM Module  
  delay(100);

  // Lux sensor
  /* Initialise the sensor */
  //use tsl.begin() to default to Wire, tsl.begin(&Wire2) directs api to use Wire2, etc.
  if(!tsl.begin())
  {
    /* There was a problem detecting the TSL2561 ... check your connections */
    Serial.print("Ooops, no TSL2561 detected ... Check your wiring or I2C ADDR!");
    while(1);
  }
  configureSensor(); /* We're ready to go! */
  Serial.println("");

  // functionnalities command
  /*Serial.println("GSM SIM900 BEGIN");
  Serial.println("Enter character for control option:");
  
  Serial.println("c : to make a call");
  Serial.println("v : to receive a call");
  Serial.println("h : to disconnect a call");
  
  Serial.println("s : to send message");
  Serial.println("r : to read message");
  
  Serial.println("o : to put interior light on");
  Serial.println("p : to put interior light off");
  Serial.println("l : to put exterior light on");
  Serial.println("m : to put exterior light off");
  Serial.println("a : to shut down all lights");
  Serial.println("z : to turn on all lights");
  
  Serial.println("n : to get lux sensor value");
  Serial.println("i : to get all informations");*/
  Serial.println();
  delay(100);
}

void loop()
{
  if (Serial.available()>0)
   switch(Serial.read())
  {
    case 's':
     SendMsg();
     break;

    case 'r':
     ReadMsg();
     break;

    case 'c':
     MakeCall();
     break;

    case 'v':
     ReceiveCall();
     break;

    case 'h':
     HangUpCall();
     break;

    case 'o':
     InteriorLightOn();
     break;

    case 'p':
     InteriorLightOff();
     break;

    case 'l':
     ExteriorLightOn();
     break;

    case 'm':
     ExteriorLightOff();
     break;

    case 'n':
     getLuxSensorValue();
     break;

    case 'i':
     getInfo();
     break;

    case 'a':
     shutDownLights();
     break;

    case 'z':
     turnOnLights();
     break;

    case 'w':
     openGarageDoor();
     break;

    case 'x':
     closeGarageDoor();
     break;
     
  }

  if (mySerial.available()>0)
  {
    //Serial.write(mySerial.read());
    buf = readSIM900();
    buftemp = buf;
    if (buf.startsWith("\r\n+CMT: "))
    {
        // Remove first 10 characters
        buftemp.remove(0,10);
        int len1 = buftemp.length();
        buftemp.remove(11,len1-11);
        phoneNumberReceived=buftemp;
        
        // Remove first 50 characters
        buf.remove(0, 50);
        int len = buf.length();
        // Remove \r\n from tail
        buf.remove(len - 2, 2);
        
        /*Serial.println("*** RECEIVED SMS FROM: +" + phoneNumberReceived + " ***"); 
        Serial.println(buf);
        Serial.println("*** END SMS ***");*/

        if (phoneNumberReceived==phoneNumberRef1 || phoneNumberReceived==phoneNumberRef2 ){
          if (buf=="T"){
            SendMsgCombination1(phoneNumberReceived);
            delay(5000);
            SendMsgCombination2(phoneNumberReceived); 
          }
          if (buf=="o"){
            InteriorLightOn();
          }
          if (buf=="p"){
            InteriorLightOff();
          }
          if (buf=="l"){
            ExteriorLightOn();
          }
          if (buf=="m"){
            ExteriorLightOff();
          }
          if (buf=="a"){
            shutDownLights();
          }
          if (buf=="z"){
            turnOnLights();
          }
          if (buf=="i"){
            getInfo();
          }
          if (buf=="w"){
            openGarageDoor();
          }
          if (buf=="x"){
            closeGarageDoor();
          }
        }
    }
    // incoming call phone number
    // index boucle for
    int i;
    if (buf.startsWith("\r\nRING"))
    {
        buf.remove(0,18);
        int len2 = buf.length();
        buf.remove(10,len2-10);
        phoneNumberReceived=buf;
        Serial.println("*** RING FROM " + phoneNumberReceived + " ***");

        if (phoneNumberReceived==phoneNumberRef1 || phoneNumberReceived==phoneNumberRef2 ){
          openGarageDoor();
          delay(10000); // wait for ten seconds
          closeGarageDoor();
          delay(1000); // wait for one second
        }
     }
  }
  getLuxSensorValue();
}

void openGarageDoor()
{
  stepper.setSpeed(3); // 3 rpm
  stepper.step(1019); // do 2038 steps -- corresponds to one revolution in one minute
  GarageDoorStatus=1;
}

void closeGarageDoor()
{
  stepper.setSpeed(3); // 3 rpm
  stepper.step(-1019); // same as above but counter clockwise
  GarageDoorStatus=0;
}

void SendMsgCombination1(String incomingPhoneNumber)
{
   mySerial.println("AT+CMGF=1");    //Sets the GSM Module in Text Mode
   delay(1000);  // Delay of 1 second
   mySerial.println("AT+CMGS=\"+" + incomingPhoneNumber + "\"\r");
   delay(1000);
   // The SMS text you want to send
    mySerial.println("o : put interior light on");
    mySerial.println("p : put interior light off");
    mySerial.println("l : put exterior light on");
    mySerial.println("m : put exterior light off");
    delay(100);
    mySerial.println((char)26);// ASCII code of CTRL+Z for saying the end of sms to  the module 
    delay(1000);
    Serial.println("message sent");
}
void SendMsgCombination2(String incomingPhoneNumber)
{
   mySerial.println("AT+CMGF=1");    //Sets the GSM Module in Text Mode
   delay(1000);  // Delay of 1 second
   mySerial.println("AT+CMGS=\"+" + incomingPhoneNumber + "\"\r");
   delay(1000);
   // The SMS text you want to send
    mySerial.println("a : shut down all lights");
    mySerial.println("z : turn on all lights");
    mySerial.println("i : get all informations");
    delay(100);
    mySerial.println((char)26);// ASCII code of CTRL+Z for saying the end of sms to  the module
    delay(1000);
    Serial.println("message sent");
}

String readSIM900()
{
    String buffer;
    while (mySerial.available())
    {
        char c = mySerial.read();
        buffer.concat(c);
        delay(10);
    }
    return buffer;
}

void SendMsg()
{
   mySerial.println("AT+CMGF=1");    //Sets the GSM Module in Text Mode
   delay(1000);  // Delay of 1 second
   mySerial.println("AT+CMGS=\"+" + phoneNumber + "\"\r");
   delay(1000);
   mySerial.println("HEY, THIS IS FROM GSM SHIELD.");// The SMS text you want to send
   delay(100);
   mySerial.println((char)26);// ASCII code of CTRL+Z for saying the end of sms to  the module 
   delay(1000);
   Serial.println("message sent");
}

void getInfo()
{
  mySerial.println("AT+CMGF=1");    //Sets the GSM Module in Text Mode
   delay(1000);  // Delay of 1 second
   mySerial.println("AT+CMGS=\"+" + phoneNumber + "\"\r");
   delay(1000);
   
   if(ExteriorLightStatus==0){
    mySerial.println("Exterior Light Off");
   }else{
    mySerial.println("Exterior Light On");
   }
   
   if(InteriorLightStatus==0){
    mySerial.println("Interior Light Off");
   }else{
    mySerial.println("Interior Light On");
   }

   mySerial.println("Light Sensor: " + LuxSensorValue + " lux");

   if(GarageDoorStatus==0){
    mySerial.println("Garage Door Closed");
   }else{
    mySerial.println("Garage Door Opened");
   }
    
   delay(100);
   mySerial.println((char)26);// ASCII code of CTRL+Z for saying the end of sms to  the module 
   delay(1000);
   Serial.println("message sent");
}

void ReadMsg()
{
   mySerial.println("AT+CNMI=2,2,0,0,0"); // AT Command to receive a live SMS
   if (mySerial.available()>0)
  {
    msg=mySerial.read();
    Serial.print(msg);
  }
}

void MakeCall()
{
  //watch out here for semicolon at the end!!
  mySerial.println("ATD+" + phoneNumber + ";");
  Serial.println("Calling  "); // print response over serial port
  delay(1000);
}

void ReceiveCall()
{
  mySerial.println("ATA");
  delay(1000);
  {
    call=mySerial.read();
    Serial.print(call);
  }
}

void HangUpCall()
{
  mySerial.println("ATH");
  Serial.println("Hangup Call");
  delay(1000);
}

void InteriorLightOn()
{
  digitalWrite(led13, HIGH);
  InteriorLightStatus=1;
  Serial.println("light interior on");
}

void InteriorLightOff()
{
  digitalWrite(led13, LOW);
  InteriorLightStatus=0;
  Serial.println("light interior off");
}

void ExteriorLightOn()
{
  digitalWrite(led2, HIGH);
  ExteriorLightStatus=1;
  Serial.println("light exterior on");
}

void ExteriorLightOff()
{
  digitalWrite(led2, LOW);
  ExteriorLightStatus=0;
  Serial.println("light exterior off");
}

void configureSensor()
{
  /* You can also manually set the gain or enable auto-gain support */
  // tsl.setGain(TSL2561_GAIN_1X);      /* No gain ... use in bright light to avoid sensor saturation */
  // tsl.setGain(TSL2561_GAIN_16X);     /* 16x gain ... use in low light to boost sensitivity */
  tsl.enableAutoRange(true);            /* Auto-gain ... switches automatically between 1x and 16x */
  
  /* Changing the integration time gives you better sensor resolution (402ms = 16-bit data) */
  //tsl.setIntegrationTime(TSL2561_INTEGRATIONTIME_13MS);      /* fast but low resolution */
  tsl.setIntegrationTime(TSL2561_INTEGRATIONTIME_101MS);  /* medium resolution and speed   */
  // tsl.setIntegrationTime(TSL2561_INTEGRATIONTIME_402MS);  /* 16-bit data but slowest conversions */
}

void getLuxSensorValue()
{
  /* Get a new sensor event */ 
  sensors_event_t event;
  tsl.getEvent(&event);
 
  /* Display the results (light is measured in lux) */
  if (event.light)
  {
    /*Serial.print("Lux Sensor: ");
    Serial.print(event.light);
    Serial.println(" lux");*/
    LuxSensorValue = event.light;
  }
  else
  {
    /* If event.light = 0 lux the sensor is probably saturated and no reliable data could be generated! */
    Serial.println("Sensor overload");
  }
}

void shutDownLights()
{
  digitalWrite(led13, LOW);
  InteriorLightStatus=0;
  digitalWrite(led2, LOW);
  ExteriorLightStatus=0;
  Serial.println("light interior off");
  Serial.println("light exterior off");
}

void turnOnLights()
{
  digitalWrite(led13, HIGH);
  InteriorLightStatus=1;
  digitalWrite(led2, HIGH);
  ExteriorLightStatus=1;
  Serial.println("light interior on");
  Serial.println("light exterior on");
}

