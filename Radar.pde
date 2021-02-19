import processing.sound.*;

String noObject;
float pixelDistance;
int degreeAngle, cmDistance;


float rotateAngle = 0;

int smaller;
int bigger;

Constant Constant = new Constant();
Draw Draw = new Draw();
SoundFile soundFile;

void setup() 
{

  fullScreen();
  smooth(16);

  soundFile = new SoundFile(this, "radar_sound.mp3");
  //soundFile.loop();

  smaller = displayWidth < displayHeight ? width : height;
  bigger =  displayWidth > displayHeight ? width : height;

  Constant.RadiusList = new float[]{
    smaller * 0.26, 
    smaller * 0.44, 
    smaller * 0.63, 
    smaller * 0.815
  };

  Constant.LineLong       = Constant.RadiusList[3] * 0.533 ;

  Constant.DistanceK      = 10;
  Constant.FollowerNumber = 5;
}

void draw() 
{

  fill(0);
  noStroke();
  rect(0, 0, width, height);
  Draw.Circle();
  Draw.Lines();
  Draw.InfoTtext();
  Draw.DegreeNumbers();
  Draw.DistanceNumbers();
  //drawRedLine();
  Draw.Rotate();
}
