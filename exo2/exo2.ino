int led12 = 12;

void setup() {
  pinMode(led12, OUTPUT);
}

void loop() {
  flash(200); flash(200); flash(200);// s
  delay(300);
  flash(500); flash(500); flash(500);//o
  flash(200); flash(200); flash(200);//s
  delay(1000);
}

void flash(int duree){
  digitalWrite(led12,HIGH);
  delay(duree);
  digitalWrite(led12,LOW);
  delay(duree);
}

