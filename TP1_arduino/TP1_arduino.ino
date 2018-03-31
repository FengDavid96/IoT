int SensorPressurePin = A0; // select the input pin for the pressure sensor
int count = 100;
void setup() {
  Serial.begin(9600);
}

void loop() {
  delay(3000);
  while(count != 0){
    int SensorValue = analogRead(SensorPressurePin);
    Serial.println(SensorValue);
    count = count - 1;
    delay(200);
  }
  Serial.println("finish");
}
