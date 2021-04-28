import processing.sound.*;
import processing.serial.*;

Serial myPort;

int cmDistance;

float rotateAngle = 0;// TODO If error occurs change to float 

void setup() 
{
  size(600,600);
  smooth(16);
  
  String portName = Serial.list()[0];
  myPort = new Serial(this, "COM4", 9600); // Maybe COM4 in your setup

  myPort.bufferUntil('\n');// For packet structure look at send_packet() in Radar.ino
}

void serialEvent(Serial myPort)
{ 
  String packet = myPort.readStringUntil('\n');
  packet = packet.substring(0, packet.length() - 1); // Removes \n form end
  
  int  delimiterIndex = packet.indexOf(',');
  
  rotateAngle = Integer.parseInt(packet.substring(0, delimiterIndex -1));// TODO Could add exception handling for non-number input
  cmDistance  = Integer.parseInt(packet.substring(delimiterIndex + 1, packet.length())); // \n Is already stripped
}

void draw() 
{
  fill(0);
  noStroke();
  String log =String.valueOf(rotateAngle) + "\t" + String.valueOf(rotateAngle);
  text(log, width/2, height/2);
 }
