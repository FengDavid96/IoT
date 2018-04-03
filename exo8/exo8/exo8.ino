

int SensorPressurePin = A0; // select the input pin for the pressure sensor
int LED = 8;
int LEDbrightness;

void setup() {
  Serial.begin(9600);
  pinMode(LED, OUTPUT);
}

void loop() {
  int SensorValue = analogRead(SensorPressurePin);
  LEDbrightness = map(SensorValue, 0, 1023, 1, 255);
  if(SensorValue>0){
    digitalWrite(LED, LEDbrightness);
  }else{
    digitalWrite(LED, 0);
  }
  Serial.println(SensorValue);
  delay(200);

}
