import processing.sound.*;
import processing.serial.*;

Serial myPort;

String noObject;
float pixelDistance;
int degreeAngle, cmDistance;

float rotateAngle = 0;

int smaller;
int bigger;
Constant Constant = new Constant();
SoundFile soundFile;
Drawer drawer = new Drawer();

void setup() 
{
  fullScreen();
  smooth(16);
  
  String portName = Serial.list()[0];
  myPort = new Serial(this, "COM4", 9600); // Maybe COM4 in your setup

  soundFile = new SoundFile(this, "radar_sound.mp3");
  soundFile.loop();

  smaller = displayWidth < displayHeight ? width : height;
  bigger =  displayWidth > displayHeight ? width : height;

  Constant.RadiusList = new float[]
  {
    smaller * 0.26, 
    smaller * 0.44, 
    smaller * 0.63, 
    smaller * 0.815
  };

  Constant.CircleColor     = color(98, 245, 31);
  Constant.LineColor       = color(98, 245, 31);
  Constant.TextColor       = color(98, 245, 31);
  Constant.RedLineColor    = color(255, 10, 10);
  Constant.RotateLineColor = color(30, 250, 60);
  Constant.InfoTextColor   = color(98, 245, 31);

  Constant.LineLength      = Constant.RadiusList[3] * 0.533 ;

  Constant.DistanceK       = 80;
  Constant.FollowerNumber  = 5;
}

void serialEvent(Serial myPort)
{ 
  cmDistance = myPort.read();
}
void draw() 
{
  int start = millis();
  fill(0);
  noStroke();
  rect(0, 0, width, height);
  drawer.drawCircles();
  drawer.drawLines(); 
  drawer.drawInfoText();
  drawer.drawDegreeNumbers();
  drawer.drawDistanceNumbers();
  drawer.drawRotate();
}
