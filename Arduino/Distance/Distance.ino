#include <Servo.h>

#define trigPin   5
#define echoPin   4

#define motorPin 3

#define DEBUG // Reduced rotation angle and mimics stand by
#define NO_PHONE // For testing without reading any serial input
 
#define soundConstant 0.034

Servo motor;
int cmDistance;
int rotateAngle = 0;
char standByVal = '1'; // MIT App Inventor will send '0' for pause radar

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
  for (rotateAngle = 0; rotateAngle <= ROTATE_ANGLE; rotateAngle++)
    mainEvent();

  for (rotateAngle = ROTATE_ANGLE; rotateAngle >= 0; rotateAngle--)
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
  // if (objectInRange()) // TODO Only send when object detected
  send_packet();
}
void send_packet()// TODO Maybe encapsulate with a struct
{
  Serial.print(rotateAngle);
  Serial.print(',');
  Serial.println(cmDistance);// println adds \n for indicating one packet has send
}
