class Draw {
  void circles() {
    pushMatrix();

    translate(width / 2, height / 2);
    strokeWeight(2);
    stroke(Constant.CircleColor);
    noFill();

    for (float R : Constant.RadiusList) {
      circle(0, 0, R);
    }

    popMatrix();
  }

  void RedLine() {
    pushMatrix();

    float lineVar = (height * 44.4 / 100);

    translate(width / 2, height / 2);
    strokeWeight(1);

    stroke(Constant.RedLineColor); // Red

    pixelDistance =
      cmDistance * 22.5; // Converting real distance in centimeters to pixels.
    // Limiting the distance to 40 cm
    if (cmDistance < 40) {
      line(pixelDistance * cos(radians(degreeAngle)), 
        -pixelDistance * sin(radians(degreeAngle)), 
        lineVar * cos(radians(degreeAngle)), 
        -lineVar * sin(radians(degreeAngle)));
    }

    popMatrix();
  }

  void infoText() {
    pushMatrix();

    noObject = cmDistance > 40 ? "Out of Range" : "In Range";
    fill(Constant.InfoTextColor);

    textAlign(LEFT);
    textSize(bigger * 2.08 / 100);
    textLeading(3);

    translate(width / 2, height / 2);
    text("Object: " + noObject, -width / 2 * 95 / 100, -height / 2 * 90 / 100);
    text("Angle: " + nfs(rotateAngle, 3, 2) + " °", -width / 2 * 95 / 100, 
      -height / 2 * 80 / 100);
    text("Distance:", -width / 2 * 95 / 100, -height / 2 * 70 / 100);

    if (cmDistance < 40) {
      text(cmDistance + " cm", -width / 2 * 75 / 100, -height / 2 * 70 / 100);
    }

    popMatrix();
  }

  void lines() {
    pushMatrix();
    fill(Constant.LineColor);
    float lineVar = Constant.LineLength;
    translate(width / 2, height / 2);

    for (int i = 30; i <= 360; i += 30) {
      line(0, 0, -(lineVar)*cos(radians(i)), -(lineVar)*sin(radians(i)));
    }

    popMatrix();
  }


  void distanceNumbers() {
    pushMatrix();

    translate(width / 2, height / 2);

    fill(Constant.TextColor);
    textSize(width * 1.10 / 100);
    textAlign(CENTER);

    for (int i = 0; i < Constant.RadiusList.length; i++) {
      text((i + 1) * Constant.DistanceK, Constant.RadiusList[i] / 2, 
        height * 3 / 100);
    }

    popMatrix();
  }

  void DegreeNumbers() {
    pushMatrix();

    float lineVar = Constant.LineLong;

    translate(width / 2, height / 2);

    textSize(smaller * 1.90 / 100);
    textAlign(CENTER);
    textLeading(0);
    fill(Constant.TextColor);

    float transConstantX = 1.1;
    float transConstantY = 1.1;

    for (int i = 0; i < 360; i += 30) {
      pushMatrix();

      translate(lineVar * cos(radians(i)) * trans_constant_x, 
        -lineVar * sin(radians(i)) * trans_constant_y);
      // rotate(180 - degrees);
      text(i + "°", 0, 0);
      popMatrix();
    }

    popMatrix();
  }

  void drawRotatingLine() {
    pushMatrix();

    float lineVar = Constant.LineLength;

    stroke(Constant.RotateLineColor);

    translate(width / 2, height / 2);
    strokeWeight(2);
    for (int i = 0; i < Constant.FollowerNumber; i++) {
      line(0, 0, lineVar * cos(radians(rotateAngle - i)), -lineVar * sin(radians(rotateAngle - i)));
    }

    strokeWeight(6);
    line(0, 0, lineVar * cos(radians(rotateAngle)), 
      -lineVar * sin(radians(rotateAngle)));

    rotateAngle = (rotateAngle + 0.80) % 360;

    popMatrix();
  }
}
