import processing.serial.*;

Serial myPort;  // Create object from Serial class
String val;     // Data received from the serial port

PrintWriter output;

void setup() {
  String portName = Serial.list()[0];
  myPort = new Serial(this, portName, 9600);
  output = createWriter( "data.txt" );
}

void draw()
{
  if (myPort.available() > 0 ) {
         String val = myPort.readString();
         println(val);
         output.println(val);
    }
}

void keyPressed() {
  output.flush(); // Writes the remaining data to the file
  output.close(); // Finishes the file
  exit(); // Stops the program
}
