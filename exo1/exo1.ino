int led13 = 13;

void setup() {
  pinMode(led13, OUTPUT);
  Serial.begin(9600);
}

void loop() {
  digitalWrite(led13, HIGH);
  delay(13);
  digitalWrite(led13, LOW);
  delay(13);
  Serial.println("Hello Debug");
}
