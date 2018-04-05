import processing.serial.*; //import serial communication classes
import cc.arduino.*; //import Arduino classes

Arduino arduino; //declare an Arduino object

float xball;
float yball;

float xrect;
float yrect;

float xdelta;
float ydelta;

void setup() // runs once at start
{
  size(400,700);
  background(0);
  xball=200;
  yball=200;
  
  xrect=200;
  yrect=600;
  
  xdelta=6;
  ydelta=-3;
}

void draw() //loops forever
{
  background(0);
  move();
  rebond();
  ballraquette();
}

void ballraquette(){
  rect(xrect, yrect, 100, 10);
  ellipse(xball,yball,10,10);
}

void move(){
  xball += xdelta;
  yball += ydelta;
  xrect = (mouseX);
}

void rebond(){
 
  if( xball > width-10 && xdelta > 0){ // droite
    xdelta = -xdelta; 
  }
  
  if( xball < 10 && xdelta < 0){ // gauche
    xdelta = abs(xdelta); 
  }
  
  if( yball < 10 && ydelta < 0){ // haut
    ydelta = abs(ydelta);
  }
  
  if( yball > yrect-10 && xball > xrect-100 && xball < xrect+100){ // bas
    ydelta = -ydelta;
  }
  
  if(yball > yrect + 100){
    noLoop();
    println("GAME OVER");
  }
}
