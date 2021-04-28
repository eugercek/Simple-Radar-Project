#include <Servo.h>

#define redPin    13
#define greenPin  12
#define bluePin   11

#define buzzerPin 10

#define trigPin   5
#define echoPin   4

#define motorPin 3

#define DEBUG
#define NO_PHONE
 
#define soundConstant 0.034

Servo motor;
int cmDistance ;
char standByVal = '1'; // MIT App Inventor will send '0' for pause radar

void setup()
{
/*
 * If DEBUG Below macro will simulate
 * 1 second stand by on start
 */
  #ifdef DEBUG
    analogWrite(bluePin, 255);
    delay(1000);
    analogWrite(bluePin, 0);
  #endif

  // For real world problems
  #ifdef DEBUG
    #define ROTATE_ANGLE 180
  #else
    #define ROTATE_ANGLE 360
  #endif

  motor.attach(motorPin);
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
  
  cmDistance = timeVal * soundConstant / 2;
  
  return cmDistance;
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

void buzzOrNot(int cmDistance)
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
  return cmDistance < 320; // TODO Find Real Life Value for 320
}

void mainEvent()
{
  motor.write(i);
  distCalc();
  ledRedOrGreen();
  builtinLed();
  #ifndef DEBUG
    buzzOrNot(cmDistance);
  #endif
  #ifndef NO_PHONE
    standBy();
  #endif
  if (objectInRange())
    Serial.write(cmDistance);
}
