int SensorPressurePin = A0; // select the input pin for the pressure sensor
int Voltage; 

void setup() {
  Serial.begin(9600);
}

void loop() {

  int SensorValue = analogRead(SensorPressurePin);

  Serial.print("Analog reading = ");
  Serial.println(SensorValue);

  // analog voltage reading ranges from about 0 to 1023 which maps to 0V to 5V (= 5000mV)
  Voltage = map(SensorValue, 0, 1023, 0, 5000);
  Serial.print("Voltage reading in mV = ");
  Serial.println(Voltage);
  
  Serial.println("--------------------");
  delay(200);
}
