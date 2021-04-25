#include <Servo.h>

#define echoPin   5
#define trigPin   13

#define redPin    11
#define bluePin   9
#define greenPin  8

#define buzzerPin 7

#define motorPin 3

#define DEBUG
 

#define soundConstant 0.034

Servo motor;
int distanceCm ;
bool standByVal = true;

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
  	Serial.begin(9600);
  #endif
  
  pinMode(redPin, OUTPUT);
  pinMode(greenPin, OUTPUT);
  pinMode(bluePin, OUTPUT);
  
  pinMode(buzzerPin, OUTPUT);
  
  pinMode(trigPin, OUTPUT); 
  pinMode(echoPin, INPUT);   
}

void loop()
{
  for (int i = 0; i <= 360; i++)
  {
    motor.write(i);
    distCalc();
    ledRedOrGreen();
    buzzOrNot(distanceCm);
    #ifndef DEBUG
    	standBy();
    #endif
  }

  for (int i = 360; i >= 0; i--)
  {
    motor.write(i);
    distCalc();
    ledRedOrGreen();
    buzzOrNot(distanceCm);
    #ifndef DEBUG
    	standBy();
    #endif
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
  // TODO Find Real Life Value for 320
  if (distanceCm > 320) // Out of Range 
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
   if (distanceCm < 320)
   	tone(7, 220, 100); // TOOD find good tone
}


void standBy()
{
  analogWrite(bluePin, 255);
  while(1)
  {
    if(standByVal == false)
      break;
    
    delay(300);
  } 	
  analogWrite(bluePin, 0);
}
