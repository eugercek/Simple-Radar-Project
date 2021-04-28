#include <Servo.h>

#define trigPin   5
#define echoPin   4

#define motorPin 3

#define soundConstant 0.034

Servo motor;
int distanceCm ;

void setup()
{

  #define ROTATE_ANGLE 180


  motor.attach(motorPin);
 
  pinMode(trigPin, OUTPUT); 
  pinMode(echoPin, INPUT);
  Serial.begin(9600);
}

void loop()
{
  if(Serial.available() > 0)
    standByVal = Serial.read();

  for (int i = 0; i <= ROTATE_ANGLE; i++)
    mainEvent();

  for (int i = ROTATE_ANGLE; i >= 0; i--)
    mainEvent();
}


int distCalc()
{

  long timeVal;
  digitalWrite(trigPin, LOW);
  delayMicroseconds(2);
  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);

  timeVal = pulseIn(echoPin, HIGH);
  
  distanceCm = timeVal * soundConstant / 2;
  return distanceCm;
}

void mainEvent()
{
  motor.write(i);
  distCalc();
  Serial.println(distanceCm);
}
