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
  drawCircles();
  drawLines(); 
  drawInfoText();
  drawDegreeNumbers();
  drawDistanceNumbers();
  drawRotate();
  int end = millis();
  println(1000/(end - start));
}

void drawCircles() 
{ 
  pushMatrix();

  translate(width/2, height/2);
  strokeWeight(2);
  stroke(Constant.CircleColor);
  noFill();

  for (float R : Constant.RadiusList)
  {
    circle(0, 0, R);
  }
  popMatrix();
}

void drawRedDot(float currentPos) 
{
  pushMatrix();
  float dotVar = (height*44.4/100);

  translate(width/2, height/2); 
  strokeWeight(1);

  stroke(Constant.RedLineColor); //Red
  fill(255,0,0);

  pixelDistance = cmDistance*22.5; //Converting real distance in centimeters to pixels.
  //Limiting the distance to 40 cm
  if (cmDistance < 40)
  { 
    float circleX = (pixelDistance*cos(radians(currentPos)) + dotVar*cos(radians(currentPos))) / 2;
    float circleY = (-pixelDistance*sin(radians(currentPos)) - dotVar*sin(radians(currentPos))) / 2;
    circle(circleX, circleY, 30);// 30 is a random value
  } 
  popMatrix();
} 

void drawInfoText() 
{ 
  pushMatrix();
  noObject = cmDistance > 40 ? "Out of Range" : "In Range";
  fill(Constant.InfoTextColor);

  textAlign(LEFT);
  textSize(bigger*2.08/100);
  textLeading(3);

  translate(width/2, height/2);
  text("Object: " + noObject, -width/2*95/100, -height/2*90/100);
  text("Angle: " + nfs(rotateAngle, 3, 2) +" °", -width/2*95/100, -height/2*80/100);
  text("Distance:", -width/2*95/100, -height/2*70/100);

  if (cmDistance<40) 
  {
    text(cmDistance +" cm", -width/2*75/100, -height/2*70/100);
  }

  popMatrix();
}

void drawLines()
{
  pushMatrix();
  fill(Constant.LineColor);
  float lineVar = Constant.LineLength;
  translate(width/2, height/2);

  for (int i = 30; i <= 360; i+=30)
  {
    line(0, 0, -(lineVar)*cos(radians(i)), -(lineVar)*sin(radians(i)));
  }

  popMatrix();
}   

void drawDistanceNumbers()
{
  pushMatrix();

  translate(width/2, height/2);

  fill(Constant.TextColor);
  textSize(width*1.10/100);
  textAlign(LEFT);
  for (int i = 0; i < Constant.RadiusList.length; i++)
  {
    text((i + 1) * Constant.DistanceK, Constant.RadiusList[i] / 2 + bigger * 0.00260, height*3/100); //bigger * 0.00260 is for simulating a five pixel addition on any resolution.
  }

  popMatrix();
}

void drawDegreeNumbers()
{  
  float lineVar = Constant.LineLength;

  pushMatrix();

  translate(width/2, height/2);

  textSize(smaller*1.90/100);
  textAlign(CENTER);
  textLeading(0);
  fill(Constant.TextColor);

  float transConstantX = 1.1;
  float transConstantY = 1.1;

  for (int i = 0; i < 360; i +=30)
  {
    pushMatrix();
    translate(lineVar * cos(radians(i)) * transConstantX, -lineVar*sin(radians(i)) * transConstantY);
    if (i <= 180)
      rotate(radians(90 - i));
    else
      rotate(radians(270 - i));
    text(i + "°", 0, 0);
    popMatrix();
  }

  popMatrix();
}

void drawRotate()
{
  pushMatrix();
  float lineVar = Constant.LineLength;
  int alpha = 130;
  float followerControl;
  stroke(Constant.RotateLineColor);

  translate(width/2, height/2);
  strokeWeight(6);
  line(0, 0, lineVar* cos(radians(rotateAngle)), -lineVar*sin(radians(rotateAngle)));
  stroke(Constant.LineColor, alpha); 
  for (int i = 0; i < 130; i++)
  {
    followerControl = i;
    strokeWeight(2);
    if(cmDistance < 320)
      drawRedDot(rotateAngle);
    line(0, 0, lineVar * cos(radians(rotateAngle - followerControl/5)), -lineVar * sin(radians(rotateAngle - followerControl/5)));
    stroke(Constant.LineColor, alpha - i);
  }
  rotateAngle = (rotateAngle + 0.8) % 360;
  popMatrix();
}
