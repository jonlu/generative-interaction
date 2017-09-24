//Jonathan Lu DES 37
//This sketch uses the HE_Mesh library to create a floral/geode object
//this iteration allows for complete interaction with the object
//controls for keypresses:
// capitalized controls will reverse what the keypress does
// z: toggles between custom lighting w/ spotlight and random lighting
// r/g/b: controls rgb values for the direct light
// e/f/v: controls rgb values for the spotlight
// x: controls lowerbound of the z-point randomization on the mesh
// c: controls the upperbound of the z-point randomization on the mesh
// arrow keys: move the camera left/right
// ,/.: move the camera along z axis
// l/;/': rotates the camera along z/y/x axis respectively.
// backspace: returns everything to default.




import wblut.math.*;
import wblut.processing.*;
import wblut.core.*;
import wblut.hemesh.*;
import wblut.geom.*;

HE_Mesh spiralMesh;
WB_Render spiralRender;
HE_Mesh gemMesh;
WB_Render gemRender;

int numPoints = 21;
int gridSize = 20; //must be at least 1 less than num
int upperBound = 140;
int lowerBound = 0;
void setup() {
  fullScreen(OPENGL);
  smooth(8);
  create();
  createGem();
  

}

void create() {

  //defines an array of points for use with the mesh library
   WB_Point[] points=new WB_Point[int(pow(numPoints,2))];
  int index = 0; //keeps index on a 1d points array
  for (int j = 0; j < numPoints; j++) {
    for (int i = 0; i < numPoints; i++) {
      points[index]=new WB_Point(-1000+ i * 100,-1000+j * 100, (random(lowerBound,upperBound)));
      index++;
    }
  }
  
  //create triangles from point grid
  WB_Triangle[] tris=new WB_Triangle[int(pow(gridSize, 2)) * 2];

  for(int i=0;i<gridSize;i++){
   for(int j=0;j<gridSize;j++){
    tris[2*(i+gridSize*j)]=new WB_Triangle(points[i+numPoints*j],points[i+1+numPoints*j],points[i+numPoints*j+numPoints]);
    tris[2*(i+gridSize*j)+1]=new WB_Triangle(points[i+1+numPoints*j],points[i+numPoints*j+numPoints+1],points[i+numPoints*j+numPoints]);
   }  
  }

  //mesh data structure from triangle points
  HEC_FromTriangles creator=new HEC_FromTriangles();
  creator.setTriangles(tris);
  spiralMesh=new HE_Mesh(creator); // makes mesh
  spiralRender=new WB_Render(this);// render in prep for draw function 

  //wraps on interior of points
  //since i don't have a sphere, it turns out very chunky, like a crystal
  HEM_SphereInversion modifier=new HEM_SphereInversion();
  modifier.setRadius(350);
  spiralMesh.modify(modifier);
}
void createGem(){

  //instantiates a sphere creator
  HEC_Sphere creator=new HEC_Sphere();
  creator.setRadius(200); //radius of sphere
  creator.setUFacets(6);  //longitudinal lines, 6 makes it a hexagon when viewed from above
  creator.setVFacets(8);  //latitudinal lines, 8 because i like the number
  gemMesh=new HE_Mesh(creator); // makes mesh
  HET_Diagnosis.validate(gemMesh); // validation for sphereical calculations 
  gemRender=new WB_Render(this);// render in prep for draw function 

}
float rotateX = 0.0;
float rotateY = 0.0;
float rotateZ = 0; //rotates view so it looks like flower/geode is rotating
float r = 40.0;
float g = 40.0;
float b = 40.0;
float e = 100.0;
float f = 0.0;
float v = 0.0;
float moveX = 0.0;
float moveY = 0.0;
float moveZ = 0.0;
int seeder = int(random(100));

boolean spotToggle = true;
boolean randToggle = true;

void draw() {
  background(255);

  randomSeed(seeder);

    
  // some default colors that i think look nice
  // shininess(255);
  
  if (randToggle) {
    directionalLight(random(50, 255), random(50, 255), random(50, 255), 0, -100,-1);
    directionalLight(random(50, 255), random(50, 255), random(50, 255), -.5, 1, -1);
  }
  else {
    //turn on the lights!

    spotLight(e, f, v,pmouseX, pmouseY, 400, 
                0, 0, -100, PI,1);
    directionalLight(r, g, b, 0, 0, -1);
  }
  if (keyPressed) { // this is in draw function so that it is a constant input
    switch (key) {
      //controls colors
      case 'R' : // shape's red
        r -= .5;
        break;
      case 'r' :
        r += .5;
        break;
      case 'G' : // shape's green
        g -= .5;
        break;
      case 'g' :
        g += .5;
        break;
      case 'B' : // shape's blue
        b -= .5;
        break;
      case 'b' : 
        b += .5;
        break;
      case 'E' : // spotlight red
        e -= .5;
        break;  
      case 'e' :
        e += .5;
        break;
      case 'F' : // spotlight green
        f -= .5;
        break; 
      case 'f' :
        f += .5;
        break;   
      case 'V' : // spotlight blue
        v -= .5;
        break;  
      case 'v' :
        v += .5;
      break;  

      //controls camera
      case ',' : // negatively translates z 
        moveZ -= 4;
        break;  
      case '.' : // positively translates z
        moveZ += 4;
        break;  
      case 'l' : // rotates z positively
        rotateZ += .01;
        break;  
      case ';' : 
        rotateY += .01;
        break;  
      case '\'' :
        rotateX += .01;
        break;  
      case 'L' :
        rotateZ -= .01;
        break;  
      case ':' :
        rotateY -= .01;
        break;  
      case '\"' :
        rotateX -= .01;
        break;

      //control for actual object
      case 'x' : //lowers the mesh point lower bound for j
        lowerBound -= 1;
        create();
        break; 
      case 'X' : //raises mesh point lower bound for j
        lowerBound += 1;
        create();
        break;
      case 'c' : //raises the mesh point upper bound for j
        upperBound += 1;
        create();
        break;  
      case 'C' : //lowers the mesh point upper bound for j
        upperBound -= 1;
        create();
        break;  

    }

    switch (keyCode) { // keycode for arrow keys
      case UP :
        moveY += 4;
        break; 
      case DOWN : 
        moveY -= 4;
        break;
      case LEFT :
         moveX -= 4;
        break;  
      case RIGHT :
        moveX += 4;
        break;   
    }
  }
  pushMatrix();
  //shifts the center backwards on the z axis and into the middle 
  translate(width/2 + moveX, height/2 + moveY, -350 + moveZ);
   
  
  //rotates in a defined pattern in last version
  // rotateZ(rotator);
  // rotateX(-sin(frameCount/100.0) / 6.0);
  // rotateY(-cos(frameCount/100.0) / 6.0);

  //rotates based on user interaction
  rotateZ(rotateZ);
  rotateY(rotateY);
  rotateX(rotateX);
  rotateY(sin(map(mouseX, 0, height, -.1, .1)));
  rotateX(sin(map(mouseY,0,width,-.1,.1)));

  gemRender.drawFaces(gemMesh);

  //shifts the center back forwards to draw the spiral inwards
  translate(0, 0, 135);

  //actually draws the spiral with mesh library
  noStroke();
  spiralRender.drawFaces(spiralMesh);
  popMatrix();

  // pushMatrix();
  // translate(20, height/2, 500);
  // displayText();
  // popMatrix();

  
}
void keyPressed() {
  switch (key) {

    case 'z' : //toggles between randomly generated lighting or user interactive lighting
      randToggle = !randToggle;
      break;  
    
  }

  switch (keyCode) { // reset to default
    case BACKSPACE :
      seeder += 1;
      lowerBound = 0;
      upperBound = 140;
      rotateX = 0.0;
      rotateY = 0.0;
      rotateZ = 0; //rotates view so it looks like flower/geode is rotating
      r = 128.0;
      g = 128.0;
      b = 128.0;
      e = 100.0;
      f = 0.0;
      v = 0.0;
      moveX = 0.0;
      moveY = 0.0;
      moveZ = 0.0;
      create();
    break;  
  }

}
void mouseReleased() {
  seeder += 1;
  create();
}
