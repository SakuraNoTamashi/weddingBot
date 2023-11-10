int IN3 = 5;    // Input3 conectada al pin 5
int IN4 = 4;    // Input4 conectada al pin 4 
int ENB = 2;    // ENB conectada al pin 3 de Arduino

int ENA = 9;
int IN1 = 6;  
int IN2 = 7;

int ENC = 10;


void setup() {
  Serial.begin(115200);

  pinMode(ENB, OUTPUT); 
  pinMode(IN3, OUTPUT);
  pinMode(IN4, OUTPUT);
  
  pinMode(ENA, OUTPUT); 
  pinMode(IN1, OUTPUT);
  pinMode(IN2, OUTPUT);

  pinMode(ENC,OUTPUT);
 
 }

void loop() {
  if (Serial.available()>0) {
    int enMotor1 = Serial.readStringUntil(',').toInt();
    int dirMotor1 = Serial.readStringUntil(',').toInt();
    int enMotor2 = Serial.readStringUntil(',').toInt();
    int dirMotor2 = Serial.readStringUntil(',').toInt();
    int toolBarM = Serial.readStringUntil(',').toInt();
    
    // Control the motors based on the parsed data
    moveMotor1(enMotor1, dirMotor1);
    moveMotor2(enMotor2, dirMotor2);
    moveMotor3(toolBarM);
  }
}

void moveMotor1(int a, int b){
  analogWrite(ENB,a == 1 ? 255:0 );
  digitalWrite(IN3,b == 1 ? HIGH : LOW);
  digitalWrite(IN4,b == 0 ? HIGH : LOW);
}

void moveMotor2(int a, int b){
  analogWrite(ENA,a == 1 ? 255:0 );
  digitalWrite(IN1,b == 1 ? HIGH : LOW);
  digitalWrite(IN2,b == 0 ? HIGH : LOW);
}

void moveMotor3(int a) {
  analogWrite(ENC, a == 1 ? 255 : 0);
}
