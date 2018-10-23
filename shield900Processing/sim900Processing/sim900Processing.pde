import processing.serial.*;
Serial ComPort;

String inputExteriorLight[];
String inputInteriorLight[];
String inputGarageDoor[];

String val; 
String valInteriorLight; 
String valGarageDoor="0"; 

void setup(){
String portName=Serial.list()[0];
ComPort = new Serial(this, portName,9600);
ComPort.bufferUntil('\n');
}

void draw(){

if (ComPort.available() > 0) 
{  // If data is available,
  val = ComPort.readString();         // read it and store it in val
}
println(val);
String[] listOn = {"1"};
String[] listOff = {"0"};

if(val!= null && val.contains("light exterior on")){
  saveStrings("C:/xampp/htdocs/SIM900/Vue/actionExteriorLight.txt",listOn);
}
if(val!= null && val.contains("light interior on")){
  saveStrings("C:/xampp/htdocs/SIM900/Vue/actionInteriorLight.txt",listOn);
}

if(val!= null && val.contains("light exterior off")){
  saveStrings("C:/xampp/htdocs/SIM900/Vue/actionExteriorLight.txt",listOff);
}
if(val!= null && val.contains("light interior off")){
  saveStrings("C:/xampp/htdocs/SIM900/Vue/actionInteriorLight.txt",listOff);
}


inputExteriorLight =loadStrings("C:/xampp/htdocs/SIM900/Vue/actionExteriorLight.txt");
inputInteriorLight =loadStrings("C:/xampp/htdocs/SIM900/Vue/actionInteriorLight.txt");
inputGarageDoor =loadStrings("C:/xampp/htdocs/SIM900/Vue/actionGarageDoor.txt");

if(inputExteriorLight!=null || (inputInteriorLight!=null) || (inputGarageDoor!=null)){
  // Exterior Light
  String s_lastExteriorLight=inputExteriorLight[0];
  int lastExteriorLight =Integer.parseInt(s_lastExteriorLight);
  delay(1000);
  inputExteriorLight =loadStrings("C:/xampp/htdocs/SIM900/Vue/actionExteriorLight.txt");
  
  // Interior Light
  String s_lastInteriorLight=inputInteriorLight[0];
  int lastInteriorLight =Integer.parseInt(s_lastInteriorLight);
  delay(1000);
  inputInteriorLight =loadStrings("C:/xampp/htdocs/SIM900/Vue/actionInteriorLight.txt");
  
  // GarageDoor
  String s_lastGarageDoor=inputGarageDoor[0];
  int lastGarageDoor =Integer.parseInt(s_lastGarageDoor);
  delay(1000);
  inputGarageDoor =loadStrings("C:/xampp/htdocs/SIM900/Vue/actionGarageDoor.txt");
  
  if(inputExteriorLight.length!=0 || (inputInteriorLight.length!=0) || (inputGarageDoor.length!=0)){
    // Exterior Light
    String s_currentExteriorLight=inputExteriorLight[0];
    int currentExteriorLight =Integer.parseInt(s_currentExteriorLight);
    // Interior Light
    String s_currentInteriorLight=inputInteriorLight[0];
    int currentInteriorLight =Integer.parseInt(s_currentInteriorLight);
    // Garage Door
    String s_currentGarageDoor=inputGarageDoor[0];
    int currentGarageDoor =Integer.parseInt(s_currentGarageDoor);

    // Exterior Light
    println("ExteriorLight");
    println("current: " + currentExteriorLight);
    println("last: " + lastExteriorLight);
    if(currentExteriorLight==1){
      ComPort.write("l");
    }else{
      ComPort.write("m");
    }
    
    // Interior Light
    println("InteriorLight");
    println("current: " + currentInteriorLight);
    println("last: " + lastInteriorLight);
    if(currentInteriorLight==1){
      ComPort.write("o");
    }else{
      ComPort.write("p");
    }
    
    // GarageDoor
    println("GarageDoor");
    println("current: " + currentGarageDoor);
    println("last: " + lastGarageDoor);
    if(currentGarageDoor==1){
      ComPort.write("w");
      delay(10000);
    }else{
      ComPort.write("x");
      delay(10000);
    }
    
    println("------------------");
    

 }
}
}
