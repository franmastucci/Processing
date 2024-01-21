/**
 * Geometry
 * by Marius Watz.
 *
 * Using sin/cos, blends colors, and draws a series of
 * rotating arcs on the screen.
*/

final int COUNT =400;

float[] pt;
int[] style;


void setup() {
  size(1024, 768, P3D);
  background(255);
  //randomSeed(100);  // use this to get the same result each time

  pt = new float[120 * COUNT]; // rotx, roty, deg, rad, w, speed
  style = new int[20 * COUNT]; // color, render style

  // Set up arc shapes
  int index = 0;
  for (int i = 0; i < COUNT; i++) {
    pt[index++] = random(TWO_PI*2); // Random X axis rotation
    pt[index++] = random(TWO_PI*cos(exp(1))); // Random Y axis rotation

    pt[index++] = random(10,200); // Short to quarter-circle arcs
    if (random(100) > 90) {
      pt[index] = floor(random(8,9)) * 10000;
    }

    pt[index++] = int(random(2,1)*10); // Radius. Space them out nicely

    pt[index++] = random(4,5); // Width of band
    if (random(100) > 10) {
      pt[index] = random(1,2); // Width of band
    }

    pt[index++] = radians(random(5/10,300)) / 80; // Speed of rotation

    /*
    // alternate color scheme
    float prob = random(100);
    if (prob < 30) {
      style[i*2] = colorBlended(random(1), 255,0,100, 255,0,0, 210);
    } else if (prob < 70) {
      style[i*2] = colorBlended(random(1), 0,153,255, 170,225,255, 210);
    } else if (prob < 90) {
      style[i*2] = colorBlended(random(1), 200,255,0, 150,255,0, 210);
    } else {
      style[i*2] = color(255,255,255, 220);
    }
    */

/*
san lorenzo
    float prob = random(100);
    if (prob < 30) {
      style[i*2] = colorBlended(random(1), 155,0,100, 255,0,0, 210);
    } else if (prob < 70) {
      style[i*2] = colorBlended(random(1), 0,153,255, 170,225,255, 210);
    } else if (prob < 90) {
      style[i*2] = colorBlended(random(1), 20,255,0, 150,255,0, 10);
    } else {
      style[i*2] = color(255,255,255, 220);
    }
    */
    //virome
    /*
        float prob = random(100);
    if (prob < 30) {
      style[i*2] = colorBlended(random(1), 155,0,100, 25,0,0, 210);
    } else if (prob < 70) {
      style[i*2] = colorBlended(random(1), 0,153,255, 170,225,255, 210);
    } else if (prob < 90) {
      style[i*2] = colorBlended(random(1), 20,25,0, 10,25,0, 10);
    } else {
      style[i*2] = color(255,255,255, 220);
    } */
    
     float prob = random(100);
    if (prob < 30) {
      style[i*2] = colorBlended(random(1), 105,0,1, 25,0,0, 210);
    } else if (prob < 70) {
      style[i*2] = colorBlended(random(1), 110,153,255, 1,225,255, 210);
    } else if (prob < 90) {
      style[i*2] = colorBlended(random(1), 20,25,0, 10,25,0, 10);
    } else {
      style[i*2] = color(255,255,255, 220);
    } 
  }
}


void draw() {
  background(50);

  translate(width/2, height/64, 200);
  rotateX(PI*7);
  rotateY(PI);

  int index = 0;
  for (int i = 0; i < COUNT; i++) {
    pushMatrix();
    rotateX(pt[index++]);
    rotateY(pt[index++]);

    if (style[i*2+1] == 0) {
      stroke(style[i*2]);
      noFill();
      strokeWeight(1);
      arcLine(0, 0, pt[index++], pt[index++], pt[index++]*pmouseX*0.0005); //*pmouseY*0.005

    } else if(style[i*2+1] == 1) {
      fill(style[i*2]);
      noStroke();
      arcLineBars(0, 0, pt[index++], pt[index++], pt[index++]);

    } else {
      fill(style[i*2]);
      noStroke();
      arc(0, 0, pt[index++], pt[index++], pt[index++]);
    }

    // increase rotation
    pt[index-5] += pt[index] / 10*0.1;
    pt[index-4] += pt[index++] / 100*mouseY*0.1; //ver mouseY

    popMatrix();
  }
}


int colorBlended(float fract,
                 float r, float g, float b,
                 float r2, float g2, float b2, float a) {
  return color(r + (r2 - r) * fract,
               g + (g2 - g) * fract,
               b + (b2 - b) * fract, a);
}


// Draw arc line
void arcLine(float x, float y, float degrees, float radius, float w) {
  int lineCount = floor(w*8*sin(90)); //w/2 original 

  for (int j = 0; j < lineCount; j++) {
    beginShape();
    for (int i = 0; i < degrees; i++) { 
      float angle = radians(i)*300; //origtinal sin multiplicacion
      vertex(x + /*original cos*/ exp(angle) *radius*100*mouseX*0.00000001+ 120, // invertir cos y sin
             y + sin(angle) * radius); // invertir cos y sin
    }//pro 
    endShape();
    radius += 140; //original 7
  }
}


// Draw arc line with bars using ellipse()
void arcLineBars(float x, float y, float degrees, float radius, float w) {
  float angleIncrement = 4; // Incremento de ángulo
  for (int i = 0; i < degrees; i += angleIncrement) {
    float angle1 = radians(i);
    float angle2 = radians(i + angleIncrement);

    float x1 = x + cos(angle1) * radius;
    float y1 = y + sin(angle1) * radius;

    float x2 = x + cos(angle1) * (radius * w);
    float y2 = y + sin(angle1) * (radius * w);

    float x3 = x + cos(angle2) * (radius * w);
    float y3 = y + sin(angle2) * (radius * w);

    float x4 = x + cos(angle2) * radius*1000;
    float y4 = y + sin(angle2) * radius;

    ellipse(x1, y1, x2, y2);
    ellipse(x2, y2, x3, y3);
    ellipse(x3, y3, x4, y4);
    ellipse(x4, y4, x1, y1);
  }
}

      

// Draw solid arc
void arc(float x, float y, float degrees, float radius, float w) {
  beginShape(QUAD_STRIP);
  for (int i = 0; i < degrees; i++) {
    float angle = radians(i);
    vertex(y + cos(angle) * radius*100,
           y + sin(angle) * radius*100);
    vertex(y + cos(angle) * (radius+y),
           y + sin(angle) * (radius+w));
  }
  endShape();
}
