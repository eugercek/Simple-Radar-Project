import processing.sound.*;
import processing.serial.*;
import java.awt.event.KeyEvent;
import java.io.IOException;

String noObject;
float pixelDistance;
int cmDistance;

float rotateAngle = 0;// TODO If error occurs change to float 

int smaller;
int bigger;

Constant Constant = new Constant();
SoundFile soundFile;
Drawer drawer = new Drawer();
Fake fake = new Fake();

void setup() 
{
  fullScreen();
  smooth(16);
  
  soundFile = new SoundFile(this, "radar_sound.mp3");
  // soundFile.loop(); // No need for sound in debugging

  // These two variables are for supporting both portrait and landscape mode
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

  Constant.LineLength      = Constant.RadiusList[3] * 0.533;

  Constant.DistanceK       = 80;
  Constant.FollowerNumber  = 5;
  
  Constant.MaxRange = 320;
}

void draw() 
{
  fill(0);
  noStroke();
  rect(0, 0, width, height);
  
  // Only for this Branch
  fake.serialEvent();
  cmDistance = fake.getCmDistance();
  rotateAngle = fake.getRotateAngle();
  // Only for this branch End
  println("(main)Angle: ", rotateAngle, "    ", "Distance: ", cmDistance, "\n");
  drawer.drawCircles();
  drawer.drawLines(); 
  drawer.drawInfoText();
  drawer.drawDegreeNumbers();
  drawer.drawDistanceNumbers();
  drawer.drawRotate();
}
