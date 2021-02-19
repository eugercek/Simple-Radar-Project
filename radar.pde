import processing.sound.*;
 
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
  
  soundFile = new SoundFile(this, "radar_sound.mp3");
  //soundFile.loop();

  smaller = displayWidth < displayHeight ? width : height;
  bigger =  displayWidth > displayHeight ? width : height;
  
  Constant.RadiusList = new float[]{
    smaller * 0.26  ,
    smaller * 0.44  ,
    smaller * 0.63  ,
    smaller * 0.815
  };
  Constant.CircleColor     = color(98,245,31);
  Constant.LineColor       = color(98,245,31);
  Constant.TextColor       = color(255,255,255);
  Constant.RedLineColor    = color(255,10,10);
  Constant.RotateLineColor = color(30,250,60);
  
  Constant.LineLong       = Constant.RadiusList[3] * 0.533 ;
  
  Constant.DistanceK      = 10;
  Constant.FollowerNumber = 5;
 }
 
void draw() 
{

  fill(0);
  noStroke();
  rect(0, 0, width, height);
  drawCircle();
  drawLines();
  drawInfoTtext();
  drawDegreeNumbers();
  drawDistanceNumbers();
  //drawRedLine();
  drawRotate();
  
}

void drawCircle() 
{ 
  pushMatrix();
  
  translate(width/2,height/2);
  strokeWeight(2);
  stroke(Constant.CircleColor);
  noFill();
 
  for(float R : Constant.RadiusList){
    circle(0,0,R);
  }
  popMatrix();
}


void drawRedLine() 
{
  pushMatrix();
  float lineVar = (height*44.4/100);
  
  translate(width/2,height/2); 
  strokeWeight(1);
  
  stroke(Constant.RedLineColor); //Red
  
  pixelDistance = cmDistance*22.5; //Converting real distance in centimeters to pixels.
  //Limiting the distance to 40 cm
  if(cmDistance < 40)
  { 
    line(pixelDistance*cos(radians(degreeAngle)), -pixelDistance*sin(radians(degreeAngle)), lineVar*cos(radians(degreeAngle)), -lineVar*sin(radians(degreeAngle))); 
  } 
  popMatrix(); 
} 


void drawInfoTtext() 
{ 
  pushMatrix();
   noObject = cmDistance > 40 ?   "Out of Range" : "In Range";
  fill(Constant.TextColor);
  
  textAlign(LEFT);
  textSize(bigger*2.08/100);
  textLeading(3);
  
  translate(width/2, height/2);
  text("Object: " + noObject, -width/2*95/100, -height/2*90/100);
  text("Angle: " + nfs(rotateAngle,3,2) +" °", -width/2*95/100, -height/2*80/100);
  text("Distance:", -width/2*95/100, -height/2*70/100);
  
  if(cmDistance<40) 
  {
    text(cmDistance +" cm", -width/2*75/100, -height/2*70/100);
  }
  
  
  
  popMatrix(); 
}

void drawLines()
{
  pushMatrix();
  fill(Constant.LineColor);
  float lineVar = Constant.LineLong;
  translate(width/2, height/2);
  
  for(int i = 30; i <= 360; i+=30){
    line(0,0, -(lineVar)*cos(radians(i)),-(lineVar)*sin(radians(i)));
  }
  
  popMatrix();
}   

void drawDistanceNumbers(){
  pushMatrix();
  
  translate(width/2, height/2);
  
  fill(Constant.TextColor);
  textSize(width*1.10/100);
  textAlign(CENTER);
  
  for(int i = 0 ; i < Constant.RadiusList.length; i++){
    text((i + 1) * Constant.DistanceK, Constant.RadiusList[i] / 2, height*3/100);
  }

  popMatrix();
}

void drawDegreeNumbers(){  
  float lineVar = Constant.LineLong;

  pushMatrix();
  
  translate(width/2,height/2);
  
  textSize(smaller*1.90/100);
  textAlign(CENTER);
  textLeading(0);
  fill(Constant.TextColor);

  float trans_constant_x = 1.1;
  float trans_constant_y = 1.1;

  for(int i = 0; i < 360; i +=30){
    pushMatrix();
    
      
    translate(lineVar * cos(radians(i)) * trans_constant_x, -lineVar*sin(radians(i)) * trans_constant_y);
    //rotate(180 - degrees);
    text(i + "°", 0, 0);
    popMatrix();
  }
  
  popMatrix();
}

void drawRotate(){
  pushMatrix();
  float lineVar = Constant.LineLong;

  
  stroke(Constant.RotateLineColor);
  
  
  translate(width/2, height/2);
  strokeWeight(2);
  for(int i = 0; i < Constant.FollowerNumber; i++){
    line(0,0,lineVar*cos(radians(rotateAngle - i)),-lineVar*sin(radians(rotateAngle -i)));
  }
 
  strokeWeight(6);
  line(0,0,lineVar*cos(radians(rotateAngle)),-lineVar*sin(radians(rotateAngle)));
  
  rotateAngle = (rotateAngle + 0.80) % 360;
  
  
  popMatrix();
}

int digitNumber(int num){
  if( num < 10)
    return 1;
    
  return 1 + digitNumber ( num / 10 );
}
