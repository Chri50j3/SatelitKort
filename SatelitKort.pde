JSONObject j;

PVector Yakse = new PVector(0,1,0);
PVector RotateSat;

float angle = 0, angleAll = 1.3, angleAll2=0, O=0;
float r = 200;
PVector lok = new PVector();
float lokMag;
float x2,y2,z2;
float speed = 1;
float time;

PImage earth;
PShape globe;

void setup(){
  frameRate(120);
  size(700,700, P3D);
  earth = loadImage("earth.jpg");
  
  noStroke();
  globe = createShape(SPHERE, r);
  globe.setTexture(earth);
  
  requestData();
  
  textSize(15);
  
}

void draw(){
  
  background(25);
  
  push();
  translate(width*0.5, height*0.5);
  rotate(angleAll2,Yakse.x,Yakse.y,Yakse.z);
  angleAll2 += angleAll;
  angleAll *= O;
  angle += 0.005;
  
  noStroke();
  shape(globe);
  
  rotate(angle,RotateSat.x,RotateSat.y,RotateSat.z);
  lok.setMag(lokMag);
  translate(lok.x,lok.y,lok.z);
  box(10);
  
  pop();
  
  text("Brug A og D til at dreje verden", 10,20);
  text("SPACE STATION", 10,45);
  text("Timestamp: " + time, 10,60);

}

//Henter dataen én gang
void requestData() {
  j = loadJSONObject("https://api.n2yo.com/rest/v1/satellite/positions/25544/41.702/-76.014/0/2/&apiKey=6XEBDW-PLE4D2-JPJPLW-4SQ3");

  JSONArray positionsJson = j.getJSONArray("positions");

  JSONObject pos1 = positionsJson.getJSONObject(0);
  JSONObject pos2 = positionsJson.getJSONObject(1);
  
  float sat1Lon = pos1.getFloat("satlongitude");
  float sat1Lat = pos1.getFloat("satlatitude");
  
  float sat2Lon = pos2.getFloat("satlongitude");
  float sat2Lat = pos2.getFloat("satlatitude");
  
  time = pos1.getFloat("timestamp");
  
  float theta1 = radians(sat1Lat);
  float phi1 = radians(sat1Lon) + PI;
  
  lok.x = (r+50) * cos(theta1) * cos(phi1);
  lok.y = -(r+50) * sin(theta1);
  lok.z = -(r+50) * cos(theta1) * sin(phi1);
  
  lokMag = lok.mag();
  
  float theta2 = radians(sat2Lat);
  float phi2 = radians(sat2Lon) + PI;
  
  x2 = (r+50) * cos(theta2) * cos(phi2);
  y2 = -(r+50) * sin(theta2);
  z2 = -(r+50) * cos(theta2) * sin(phi2);
  
  RotateSat = new PVector(lok.x-x2,lok.y-y2,lok.z-z2);
    
}

// kode til at få verden til at rotere
void keyPressed(){  
  switch(key){
    case 'a':
      O = 1;
      angleAll += 0.005;
      break;
    case 'd':
      O = 1;
      angleAll -= 0.005;
      break;
  }
}

//reducere rotationshastigheden
void keyReleased(){
  O = 0.99;
}
