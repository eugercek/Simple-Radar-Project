class Drawer
{
  public void drawCircles() 
  { 
    pushMatrix();
  
    translate(width/2, height/2);
    strokeWeight(2);
    stroke(Constant.CircleColor);
    noFill();
  
    for (float R : Constant.RadiusList)
      circle(0, 0, R);
    popMatrix();
  }
  
  public void drawRedDot(float currentPos) 
  {
    pushMatrix();
    float dotVar = Constant.LineLength;
  
    strokeWeight(1);
  
    stroke(Constant.RedLineColor); //Red
    fill(255,0,0);
  
    popMatrix();
  } 
  
  public void drawInfoText() 
  { 
    pushMatrix();
    noObject = cmDistance > Constant.MaxRange ? "Out of Range" : "In Range";
    fill(Constant.InfoTextColor);
  
    textAlign(LEFT);
    textSize(bigger*2.08/100);
    textLeading(3);
  
    translate(width/2, height/2);
    text("Object: " + noObject, -width/2*95/100, -height/2*90/100);
    text("Angle: " + nfs(rotateAngle, 3, 2) +" °", -width/2*95/100, -height/2*80/100);
    text("Distance:", -width/2*95/100, -height/2*70/100);
    
    int printedDistance = cmDistance > Constant.MaxRange ? 0 : cmDistance;
    text(printedDistance +" cm", -width/2*75/100, -height/2*70/100);
    popMatrix();
  }
  
  public void drawLines()
  {
    pushMatrix();
    fill(Constant.LineColor);
    float lineVar = Constant.LineLength;
    translate(width/2, height/2);
  
    for (int i = 30; i <= 360; i+=30)
      line(0, 0, -(lineVar)*cos(radians(i)), -(lineVar)*sin(radians(i)));

    popMatrix();
  }   
  
  public void drawDistanceNumbers()
  {
    pushMatrix();
  
    translate(width/2, height/2);
  
    fill(Constant.TextColor);
    textSize(width*1.10/100);
    textAlign(LEFT);
    for (int i = 0; i < Constant.RadiusList.length; i++)
      text((i + 1) * Constant.DistanceK, Constant.RadiusList[i] / 2 + bigger * 0.00260, height*3/100); //bigger * 0.00260 is for simulating a five pixel addition on any resolution.
  
    popMatrix();
  }
  
  public void drawDegreeNumbers()
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
  
  public void drawRotate()
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
      
      if(cmDistance < Constant.MaxRange)
        drawRedDot(rotateAngle);
      line(0, 0, lineVar * cos(radians(rotateAngle - followerControl/5)), -lineVar * sin(radians(rotateAngle - followerControl/5)));
      stroke(Constant.LineColor, alpha - i);
    }
    rotateAngle = (rotateAngle + 0.8) % 360;
    popMatrix();
  }
}
