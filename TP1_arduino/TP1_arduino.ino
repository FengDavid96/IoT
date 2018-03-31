int SensorPressurePin = A0; // select the input pin for the pressure sensor

void setup() {
  Serial.begin(9600);
}

void loop() {
  int SensorValue = analogRead(SensorPressurePin);
  Serial.println(SensorValue);
  delay(200);
}
