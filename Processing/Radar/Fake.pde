class Fake{
  private int rotateAngle;
  private int cmDistance;
  
  public Fake(){
    rotateAngle = 0;
  }
  void serialEvent()
  { 
    String packet = arduinoInput();
    packet = packet.substring(0, packet.length() - 1); // Remove \n
    int delimiterIndex = packet.indexOf(",");
    rotateAngle = int(packet.substring(0,delimiterIndex));
    cmDistance  = int(packet.substring(delimiterIndex + 1, packet.length()));
    println("(serialEvent)Degree: ", rotateAngle, "    ", "Distance: ", cmDistance);
  }
  
  int getRotateAngle(){return rotateAngle;}
  int getCmDistance(){return cmDistance;}
  
  private String arduinoInput()
  {
    tick();
    String packet = str(rotateAngle) + "," + str(int(random(0,3200))) + "\n";// +320 is not possible to read from out sensor, it means no object in range. 
    // %10 Probability for object detection
    print("Arduino sent" ,packet);// Packet already have \n'
    return packet;
  }
  
  private void tick(){rotateAngle++;}
  
}
