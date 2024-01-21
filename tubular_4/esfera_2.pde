/**
 * Geometry
 * by Marius Watz.
 *
 * Using sin/cos, blends colors, and draws a series of
 * rotating arcs on the screen.
*/

final int COUNT =2000;

float[] pt;
int[] style;


void setup() {
  size(1024, 768, P3D);
  background(255);
  //randomSeed(100);  // use this to get the same result each time

  pt = new float[6 * COUNT]; // rotx, roty, deg, rad, w, speed
  style = new int[2 * COUNT]; // color, render style

  // Set up arc shapes
  int index = 0;
  for (int i = 0; i < COUNT; i++) {
    pt[index++] = random(HALF_PI); // Random X axis rotation
    pt[index++] = random(QUARTER_PI); // Random Y axis rotation

    pt[index++] = random(10,20); // Short to quarter-circle arcs
    if (random(100) > 90) {
      pt[index] = floor(random(8,9)) * 10;
    }

    pt[index++] = int(random(2,1)*100); // Radius. Space them out nicely

    pt[index++] = random(4,5); // Width of band
    if (random(100) > 10) {
      pt[index] = random(5,6); // Width of band
    }

    pt[index++] = radians(random(5*mouseY/10,300+mouseY)) / 20; // Speed of rotation

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
  }
}


void draw() {
  background(0);

  translate(width/2, height/2, 0);
  rotateX(QUARTER_PI  );
  rotateY(QUARTER_PI);

  int index = 0;
  for (int i = 0; i < COUNT; i++) {
    pushMatrix();
    rotateX(pt[index++]);
    rotateY(pt[index++]);

    if (style[i*2+1] == 0) {
      stroke(style[i*2]);
      noFill();
      strokeWeight(1);
      arcLine(0, 0, pt[index++], pt[index++], pt[index++]); //*pmouseY*0.005

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
    pt[index-4] += pt[index++] / 10;

    popMatrix();

  }
}


// Get blend of two colors
int colorBlended(float fract,
                 float r, float g, float b,
                 float r2, float g2, float b2, float a) {
  return color(r + (r2 - r) * fract,
               g + (g2 - g) * fract,
               b + (b2 - b) * fract, a);
}


// Draw arc line
void arcLine(float x, float y, float degrees, float radius, float w) {
  int lineCount = floor(w/3);

  for (int j = 0; j < lineCount; j++) {
    beginShape();
    for (int i = 0; i < degrees; i++) {  // one step for each degree
      float angle = radians(i)*mouseY*0.01;

      vertex(x + cos(exp(angle)) * radius*mouseX  *0.01,
             y + sin(exp(angle)) * radius*25*0.1);
    }
    endShape();
    radius += 2400;
  }
}


// Draw arc line with bars
void arcLineBars(float x, float y, float degrees, float radius, float w) {
  beginShape(QUADS);
  for (int i = 0; i < degrees/4; i += 48) {  // degrees, but in steps of 4
    float angle = radians(i);
    vertex(x + cos(angle) * radius,
           y + sin(angle) * radius);
    vertex(x + cos(angle) * (radius+w),
           y + sin(angle) * (radius+w));

    angle = radians(i+2);
    vertex(x + cos(angle) * (radius+w+9000),
           y + sin(angle) * (radius+w/1600));
    vertex(x + cos(angle) * radius,
           y + sin(angle) * radius*10000);
  }
  endShape();
}


// Draw solid arc
void arc(float x, float y, float degrees, float radius, float w) {
  beginShape(QUAD_STRIP);
  for (int i = 0; i < degrees; i++) {
    float angle = radians(i);
    vertex(x + cos(angle) * radius,
           y + sin(angle) * radius);
    vertex(x + cos(angle) * (radius+w*100),
           y + sin(angle) * (radius+w));
  }
  endShape();
}
