#include <Servo.h>

#define redPin    13
#define greenPin  12
#define bluePin   11

#define buzzerPin 10

#define trigPin   5
#define echoPin   4

#define motorPin 3

#define DEBUG
 
#define soundConstant 0.034

Servo motor;
int distanceCm ;
int standByVal = '1'; //Standby '1' true anlam?nda Standbya '0' yollay?nca false olacak ve break �al??acak '0' da telefondan yollanacak.

void setup()
{
  
/*
 * If DEBUG Below macro will simulate
 * 1 second stand by on start
 */
  #ifdef DEBUG
    motor.attach(motorPin);
    analogWrite(bluePin, 255);
    delay(1000);
    analogWrite(bluePin, 0);
  #endif

  #ifdef DEBUG
    #define ROTATE_ANGLE 180
  #else
    #define ROTATE_ANGLE 360
  #endif

  pinMode(redPin, OUTPUT);
  pinMode(greenPin, OUTPUT);
  pinMode(bluePin, OUTPUT);
  
  pinMode(buzzerPin, OUTPUT);
  
  pinMode(trigPin, OUTPUT); 
  pinMode(echoPin, INPUT);
     
  pinMode(LED_BUILTIN, OUTPUT);
  Serial.begin(9600);
}

void loop()
{
  if(Serial.available() > 0)
  {
    standByVal = Serial.read();
  }
  for (int i = 0; i <= ROTATE_ANGLE; i++)
  {
    motor.write(i);
    distCalc();
    ledRedOrGreen();
    buzzOrNot(distanceCm);
    #ifndef DEBUG
      builtinLed();
      standBy();
    #endif
    if (objectInRange())
      Serial.write(distanceCm);
  }

  for (int i = ROTATE_ANGLE; i >= 0; i--)
  {
    motor.write(i);
    distCalc();
    ledRedOrGreen();
    buzzOrNot(distanceCm);
    #ifndef DEBUG
      builtinLed();
      standBy();
    #endif
    if (objectInRange())
      Serial.write(distanceCm);
  }
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
  
  #ifdef DEBUG
    Serial.print("Distance: ");
    Serial.println(distanceCm);
  #endif
  
  return distanceCm;

  
}

void ledRedOrGreen(void)
{
 
  if (objectInRange())
    rgbColor(255, 0, 0);
  else
    rgbColor(0, 255, 0);
  delay(100);
}

void rgbColor(int red, int green, int blue)
{
  analogWrite(redPin, red);
  analogWrite(greenPin, green);
  analogWrite(bluePin, blue);
}

void buzzOrNot(int distanceCm)
{
   if (objectInRange())
    tone(buzzerPin, 220, 100); // TOOD find good tone
}


void standBy()
{
  analogWrite(bluePin, 255);
  while(1)
  {
    if(standByVal == '0')
      break;
    
    delay(300);
  }   
  analogWrite(bluePin, 0);
}

void builtinLed()
{
  if (objectInRange()) // Out of Range
    digitalWrite(LED_BUILTIN, HIGH);
  else
    digitalWrite(LED_BUILTIN, LOW);
    
}

inline boolean objectInRange()
{
  return distanceCm < 320; // TODO Find Real Life Value for 320
}
