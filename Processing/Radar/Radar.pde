import processing.sound.*;
import processing.serial.*;

Serial myPort;

String noObject;
float pixelDistance;
int cmDistance;

float rotateAngle = 0;// TODO If error occurs change to float 

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
  myPort.bufferUntil('\n');// For packet structure look at send_packet() in Radar.ino
}

void serialEvent(Serial myPort)
{ 
  String packet = myPort.readStringUntil('\n');
  println(packet);
  packet = packet.substring(0, packet.length() - 1); // Removes \n form end
  
  int  delimiterIndex = packet.indexOf(',');
  
  rotateAngle = Integer.parseInt(packet.substring(0, delimiterIndex -1));// TODO Could add exception handling for non-number input
  cmDistance  = Integer.parseInt(packet.substring(delimiterIndex + 1, packet.length())); // \n Is already stripped
}

void draw() 
{
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
