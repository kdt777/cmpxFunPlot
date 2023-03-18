/**
 * Plot complex function:  z2 = f(z1)
 *   for an array of domain values on the arc of a circle (radius z1)
 *   onto an infinite complex plane (using arctangential compression) 
 * where the value of z1 is provided by the position of the mouse
 *   (with fine adjustments performed with keyboard arrows;
 *      and vary stepsize using plus/minus keys)
 * Option to "join the dots" on the function's graph of values (j key).
 * Set the function to be plotted (and title) below at ll 154 ~ 160   @@@
 *   - and the centre of circle of arc of domain values at line 27    @@@
 **/
 
float zXadj = 0.0;          // globals to finesse cursor value
float zYadj = 0.0;          //     (using arrow keys)
float adjDelta = 1.0;       //   - step size (1 pixel initially)

int pixW = 1280; int pixH = 640;   // window size in pixels
int zR0 = pixH / 2; int zI0 = pixH / 2;
int fzR0 = pixW - zR0 ; int fzI0 = zI0;
float scale = pixH / 16.0;        // best set this to 8 or 16 or 8*N
int degArc = 180;                 // degrees of arc of circle

char comprMode = 'N';             // N=none; P=atan(polar); R=atan(rect) 
boolean shiftO = false;           // to move centre of arc of circle 
boolean joinFz = false;           // join the dots f(z) values

float zRorig = 0.0; float zIorig = 0.0;    // origin for domain circle   @@@

int nPoints = 40;                          // number of values on arc

void setup() {
  size(1280, 640);       // can't use variables here!
  cursor(CROSS);
}

void keyPressed() {
  if (key == CODED) {
    switch(keyCode) {
      case LEFT:
        //println("Left arrow pressed");
        if (shiftO)
          { zRorig -= adjDelta/4.0; }
        else
          { zXadj -= adjDelta; }
        break;
      case RIGHT:
        //println("Right arrow pressed");
        if (shiftO)
          { zRorig += adjDelta/4.0; }
        else
          { zXadj += adjDelta; }
        break;
      case UP:
        //println("Up arrow pressed");
        if (shiftO)
          { zIorig += adjDelta/4.0; }
        else
          { zYadj -= adjDelta; }
        break;
      case DOWN:
        //println("Down arrow pressed");
        if (shiftO)
          { zIorig -= adjDelta/4.0; }
        else
          { zYadj += adjDelta; }
        break;
    }
  }
  else {
    switch (key) {
      case '+': 
        adjDelta *= 2.0;
        //println("  + Delta = ", adjDelta);
        break;
      case '-': 
        adjDelta /= 2.0;
        //println("  - Delta = ", adjDelta);
        break;
      case 'c':    // cycle compression mode: None/Rect-atan/Polar-atan
        if (comprMode == 'N')
          { comprMode = 'R';}
        else if (comprMode == 'R')
          { comprMode = 'P';}
        else 
          { comprMode = 'N';}
        break;
      case 'p':     // increase number of points
        nPoints += 5;
        break;
      case 's':
        saveFrame();
        break;
      case 'o':     // flip Shift Origin mode
        shiftO = !shiftO;
        break;
      case 'x':     // extend arc of z domain (by 5 degrees)
        degArc += 5;
        break;
      case 'j':     // draw lines between function values
        joinFz = !joinFz;
        break;
    }
  }
}

void draw() {
  background(60);   // grey
    
  int zXorig = int(zR0 + zRorig * scale); 
  int zYorig = int(zI0 - zIorig * scale);
  
  if (comprMode != 'N') {       // draw the horizon
    noFill(); //color(100,0,0);
    strokeWeight(20); stroke(40);
    int NN = int(HALF_PI * 180);
    if (comprMode == 'P') {
      circle(fzR0, fzI0, (2 * NN + 20));    //infinite horizon
      stroke(100); textSize(8);
      text("infinity", width*0.92, height*0.2); }
    else {
      rectMode(CENTER);
      square(fzR0, fzI0, (2 * NN + 20));    //infinite horizon
      stroke(100); textSize(8); 
      text("infinity", width*0.9, height*0.05); }
    
    strokeWeight(1); stroke(200);
  }
  
  float zX = mouseX + zXadj;
  float zY = mouseY + zYadj;
  float zR = (mouseX + zXadj - zR0) / scale;   
  float zI = (zI0 - mouseY - zYadj) / scale;  
  
  float zXYradius = sqrt(sq(zX - zXorig) + sq(zY - zYorig));
  float zRadius = sqrt(sq(zR-zRorig) + sq(zI-zIorig));
  float zAngle = atan2(zI-zIorig, zR-zRorig);
  float zAstep = PI * degArc / 180 / nPoints;     // 1*pi for semicircle; 2*pi full circle
  
  float fzR = 0.0; float fzI = 0.0;
  float mkrsz = 10;   // marker size
  String plotTitle = "Funky Functions"; 
  
  float zRlast = 0.0; float zIlast = 0.0;
  float fzRlast = 0.0; float fzIlast = 0.0;
  int fzXprev = 0; int fzYprev = 0; 
    
  for (int i = 0; i <= nPoints; i = i+1) {
    float zXp = zXorig + zXYradius * cos(zAngle + i * zAstep);   
    float zYp = zYorig - zXYradius * sin(zAngle + i * zAstep);   
    float zRp = zRorig + zRadius * cos(zAngle + i * zAstep);      
    float zIp = zIorig + zRadius * sin(zAngle + i * zAstep);      
    
    //                                     @@@ complex function follows... @@@ 
    //float[] fz = cpxMult(zRp, zIp, zRp, zIp);         // z^2  
    //float[] fz = cpxDivn(1.0, 0.0, zRp, zIp);         // 1/z
    float[] fz = cpxExpn(2.718282, 0.0, zRp, zIp);    // e^z
    //float[] fz = cpxExpn(zRp, zIp, zRp, zIp);         // z^z
    //float[] fz = cpxExpn(zRp, zIp, 0.0, 1.0);         // z^i
    //float[] fz = cpxMult(zRp, zIp, -1.0, 0.0);        // z*-1
    plotTitle = "f(z) = e^z"; 
    
    float fzRp = fz[0];
    float fzIp = fz[1];
    
    int fzX = 0; int fzY = 0; 
    if (comprMode == 'N') {                // no atan compression
      fzX = fzR0 + int(fzRp * scale);       
      fzY = fzI0 - int(fzIp * scale);
      }
    else {                                 // compress f(z) value
      if (comprMode == 'R') {                 //  arctangent rectanguar
        fzX = fzR0 + int(atan(fzRp) * 180);
        fzY = fzI0 - int(atan(fzIp) * 180); }
      if (comprMode == 'P') {                 //  arctangent polar
        float fzRadius = sqrt(sq(fzRp) + sq(fzIp));    // convert fz to polar
        float fzScale = atan(fzRadius) / fzRadius;     //   ...and scale
        fzX = fzR0 + int(fzRp * fzScale * 180);
        fzY = fzI0 - int(fzIp * fzScale * 180); }
      }
    
    if (i == 0) 
      { fzR = fzRp; fzI = fzIp; mkrsz = 10;}
    else
      { mkrsz = 15.0 / (i + 2) + 2; } 
      
    if (i == nPoints) {
     zRlast = zRp; zIlast = zIp; 
     fzRlast = fzRp; fzIlast = fzIp; 
     }
      
    //noCursor(); 
    rectMode(CENTER);
    fill(255, 200, 200);        // set fill to pink
    square(zXp, zYp, mkrsz);    //   plot z value
    fill(255, 0, 0);            // set fill to red
    circle(fzX, fzY, mkrsz);    //   plot f(z) value
    //text("f", fzX, fzY);
    
    if ((joinFz) && (i > 0)) 
      { line(fzX, fzY, fzXprev, fzYprev); }
    fzXprev = fzX; fzYprev = fzY; 
  }
  
  stroke(212);
  line(5, zI0, zR0*2 - 5, zI0);                   // R axis
  line(zR0, 5, zR0, pixH - 5);                    // I axis
  line(fzR0 - zR0 + 5, fzI0, width - 5, fzI0);    // fR axis
  line(fzR0, 5, fzR0, pixH - 5);                  // fI axis
    
  textSize(12); fill(255);
  String zStr; String fzStr; 
  zStr = "z = " + nf(zR,1,3) + nfp(zI,1,3) + "i"; 
  text(zStr, 8, height - 20);
  zStr = "  to  " + nf(zRlast,1,3) + nfp(zIlast,1,3) + "i";   
  text(zStr, 8, height - 5);
  
  fzStr = "fz = " + nf(fzR,1,3) + nfp(fzI,1,3) + "i";
  text(fzStr, width - 160, height - 20);
  fzStr = "  to  " + nf(fzRlast,1,3) + nfp(fzIlast,1,3) + "i";
  text(fzStr, width - 160, height - 5);
  
  textSize(10);
    
  String aDeltaStr = "Delta  = " + nf(adjDelta,1,4);
  text(aDeltaStr, width * 0.4, height - 5);
  String nPointsStr = "Points  = " + str(nPoints+1);
  text(nPointsStr, width * 0.4, height - 15);
  String degArcStr = "degArc  = " + str(degArc);
  text(degArcStr, width * 0.4, height - 25);

  if (comprMode != 'N')
    { text("compr = " + comprMode, width * 0.6 + 5, 30); }
  
  circle(zXorig, zYorig, 3.0);
  text("O", zXorig - 10, zYorig + 10);
    
  drawTicks(1, scale);
  drawTicks(2, scale);
  drawTicks(3, scale);
  drawTicks(4, scale);
  if (comprMode != 'N')
    { drawTicks(0, scale); }  // infinity ∞
  
  PFont font;
  //font = createFont("Courier New Italic", 16);  
  font = createFont("Arial Italic", 16); 
  textFont(font);
  text("I", zR0 + 5, 20);
  text("R", height - 20, zI0); 
  text("I", fzR0 + 5, 20);
  text("R", width - 20, zI0); 
  
  font = createFont("Arial Italic", 20);
  fill(200,200,0);
  text(plotTitle, width/2 - 50, 25); 
  surface.setTitle(plotTitle); 
  
  if (shiftO) {
    text("Shift O using arrows", width/2 - 80, 60); 
    text("Centre at " + zRorig + " + " + zIorig + "i", width/2 - 80, 75); 
  }
    
  delay(250);     // to prevent app becoming CPU bound
}

float[] cpxMult(float z1r, float z1i, float z2r, float z2i) {
  // Return the product 2 complex numbers; zP = z1 * z2
  float zPr = (z1r * z2r - z1i * z2i);
  float zPi = (z1r * z2i + z1i * z2r);
  float[] zP = { zPr, zPi };  // Alternate syntax
  return zP;
}

float[] cpxDivn(float z1r, float z1i, float z2r, float z2i) {
  // Return the quotient of 2 complex numbers; zQ = z1 / z2
  float zQr = 0.0; float zQi = 0.0;
  if (z2r == 0.0 && z2i == 0.0) 
    { 
    zQr = 999999999.0; zQi = 999999999.0;
    }
  else 
    {   
    float denom = z2r * z2r + z2i * z2i;
    zQr = (z1r * z2r + z1i * z2i) / denom;
    zQi = (z2r * z1i - z1r * z2i) / denom;
    //zQr = (z1r * z2r + z1i * z2i) / denom
    //zQi = (z2r * z1i - z1r * z2i) / denom 
    }
  float[] zQ = { zQr, zQi };
  return zQ;
}

float[] cpxExpn(float z1r, float z1i, float z2r, float z2i) {
  // Return the power of 2 complex numbers; zX = z1 ^ z2
  float z1abs = sqrt((z1r * z1r + z1i * z1i));    // abs value of base
  float z2abs = sqrt((z2r * z2r + z2i * z2i));    // abs value of exp
  float zXr = 0.0; float zXi = 0.0; float z1theta = 0.0;
  if (z1r == 0.0) {
    if (z1i < 0.0) {
      z1theta = -HALF_PI;}
    else {
      z1theta = HALF_PI;}
    }
  else {
    float tanz1 = z1i / z1r;
    z1theta = atan(tanz1);
    if (z1r < 0.0)
      if (z1i < 0.0)
        z1theta -= PI;
      else
        z1theta += PI;
    }
  if (z1abs == 0.0) {
    if (z2abs== 0.0) 
      {zXr = 1.0; zXi = 0.0;}
    else 
      {zXr = 0.0; zXi = 0.0;}
    }
  else {
    float Xpointr = z2i * log(z1abs) + z2r * z1theta;    // the Directorant
    float Xscaler = pow(z1abs, z2r) / exp(z2i * z1theta); 
    zXr = cos(Xpointr) * Xscaler;
    zXi = sin(Xpointr) * Xscaler;
    }
  float[] zX = { zXr, zXi };
  return zX;
}

void drawTicks(int N, float scale) {
  if (N > 0) {
    stroke(240);
    text(str(N), zR0 + N * scale, zI0 - 2);       // pos N.real - domain
    line(zR0 + N * scale, zI0, zR0 + N * scale, zI0 + 8); 
    text(str(-N), zR0 - N * scale, zI0 - 2);      // neg N.real
    line(zR0 - N * scale, zI0, zR0 - N * scale, zI0 + 8); 
    text(str(N), zR0 + 2, zI0 - N * scale);       // pos N.imag
    line(zR0 - 8, zI0 - N * scale, zR0, zI0 - N * scale); 
    text(str(-N), zR0 + 2, zI0 + N * scale);      // neg N.imag
    line(zR0 - 8, zI0 + N * scale, zR0, zI0 + N * scale);
    }
    
  stroke(250);
  int NN = int(N * scale);
  String posNtag = str(N);
  String negNtag = str(-N);
  if (comprMode != 'N') { 
    if (N > 0)
      { NN = int(atan(N) * 180); }
    else {
      NN = int(HALF_PI * 180);
      posNtag = "∞";   //str(char(236));
      negNtag = "-∞";
      textSize(14);
      } 
    }  
  text(posNtag, fzR0 + NN, fzI0 - 2);               // pos N.real - range
  line(fzR0 + NN, fzI0, fzR0 + NN, fzI0 + 8); 
  text(negNtag, fzR0 - NN - 4, fzI0 - 2);           // neg N.real
  line(fzR0 - NN, fzI0, fzR0 - NN, fzI0 + 8); 
  text(posNtag, fzR0 + 2, fzI0 - NN);               // pos N.imag
  line(fzR0 - 8, fzI0 - NN, fzR0, fzI0 - NN); 
  text(negNtag, fzR0 + 2, fzI0 + NN);               // neg N.imag
  line(fzR0 - 8, fzI0 + NN, fzR0, fzI0 + NN);
}
