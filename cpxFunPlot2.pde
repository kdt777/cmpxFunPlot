/**
 * Plot complex function:  z2 = f(z1)
 *   onto an infinite complex plane (using arctangential compression) 
 * where the value of z1 is provided by the position of the mouse
 *   (with fine adjustments performed with keyboard arrows;
 *      and vary stepsize using plus/minus keys)
 * Set the function to be plotted (and title) below at ll 74 ~ 82  @@@
 **/
 
float zXadj = 0;          // globals to finesse cursor value
float zYadj = 0;
float adjDelta = 1.0;     //   - step size (1 pixel initially)

int pixW = 1280; int pixH = 640;   // window size in pixels
int zR0 = pixH / 2; int zI0 = pixH / 2;
int fzR0 = pixW - zR0 ; int fzI0 = zI0;

float scale = pixH / 16.0;      // best set this to 8 or 16 or 8*N   @@@
boolean fzComp = true;          // compress f(z)   

void setup() {
  size(1280, 640);       // can't use variables here!
  cursor(CROSS);
}

void keyPressed() {
  if (key == CODED) {
    switch(keyCode) {
      case LEFT:
        //println("Left arrow pressed");
        zXadj -= adjDelta;
        break;
      case RIGHT:
        //println("Right arrow pressed");
        zXadj += adjDelta;
        break;
      case UP:
        //println("Up arrow pressed");
        zYadj -= adjDelta;
        break;
      case DOWN:
        //println("Down arrow pressed");
        zYadj += adjDelta;
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
      case 's':  
        saveFrame();
        break;
    }
  }
}

void draw() {
    background(60);   // grey
    
    if (fzComp) {
      noFill(); 
      strokeWeight(20); stroke(40);
      rectMode(CENTER);
      int NN = int(HALF_PI * 180);           // 180 pixels
      square(fzR0, fzI0, (2 * NN + 20));     // infinite horizon - rect
      stroke(100); textSize(8); 
      text("infinity", width*0.9, height*0.05); 
      strokeWeight(1); stroke(200);
    }
    
    float zX = mouseX + zXadj;
    float zY = mouseY + zYadj;
    float zR = (mouseX + zXadj - zR0) / scale;   
    float zI = (zI0 - mouseY - zYadj) / scale;   
    
    //                                   @@@ complex function follows... @@@ 
    //float[] fz = cpxMult(zR, zI, zR, zI);         // z^2  
    //float[] fz = cpxDivn(1.0, 0.0, zR, zI);       // 1/z
    //float[] fz = cpxExpn(2.718282, 0.0, zR, zI);  // e^z
    float[] fz = cpxExpn(zR, zI, zR, zI);         // z^z
    //float[] fz = cpxExpn(zR, zI, 0.0, 1.0);       // z^i
    //float[] fz = cpxMult(zR, zI, -1.0, 0.0);      // z*-1
    String plotTitle = "f(z) = z^z"; 
    
    float fzR = fz[0];
    float fzI = fz[1];
    
    int fzX = fzR0 + int(fzR * scale); 
    int fzY = fzI0 - int(fzI * scale);
    if (fzComp) {
      fzX = fzR0 + int(atan(fzR) * 180);
      fzY = fzI0 - int(atan(fzI) * 180);
      }
    
    stroke(212);
    line(5, zI0, zR0*2 - 5, zI0);                   // R axis
    line(zR0, 5, zR0, pixH - 5);                    // I axis
    line(fzR0 - zR0 + 5, fzI0, width - 5, fzI0);    // fR axis
    line(fzR0, 5, fzR0, pixH - 5);                  // fI axis
    
    noCursor(); 
    rectMode(CENTER);
    fill(255, 200, 200);    // set fill to pink
    square(zX, zY, 8);      //   plot z value
    fill(255, 0, 0);        // set fill to red
    circle(fzX, fzY, 8);    //   plot f(z) value
    //text("f", fzX, fzY);
    
    String zStr = "z = " + nf(zR,1,3) + nfp(zI,1,3) + "i"; 
    String fzStr = "fz = " + nf(fzR,1,3) + nfp(fzI,1,3) + "i";
    float absfz = sqrt(fzR * fzR + fzI * fzI);
    String afzStr = "magnitude  " + nf(absfz,1,4);
    textSize(15); fill(255);
    text(zStr, 8, height - 20);
    text(fzStr, width - 140, height - 20);
    textSize(12);
    text(afzStr, width - 140, height - 5);
    
    String aDeltaStr = "Delta  = " + nf(adjDelta,1,4);
    text(aDeltaStr, width * 0.4, height - 5);
    
    drawTicks(1, scale);
    drawTicks(2, scale);
    drawTicks(3, scale);
    drawTicks(4, scale);
    if (fzComp)
      { drawTicks(0, scale); }  // infinity ∞
  
    PFont font;
    //font = createFont("Courier New Italic", 16);  
    font = createFont("Arial Italic", 16); 
    textFont(font);
    text("I", zR0 + 5, 20);
    text("R", height - 20, zI0); 
    text("I", fzR0 + 5, 20);
    text("R", width - 20, zI0); 
    
    font = createFont("Arial Italic", 18);
    fill(200,200,0);
    text(plotTitle, width/2 - 50, 30); 
    surface.setTitle(plotTitle);   
    
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
    //float zQr = 0.0; float zQi = 0.0;
    }
  else 
    {   
    float denom = z2r * z2r + z2i * z2i;
    zQr = (z1r * z2r + z1i * z2i) / denom;
    zQi = (z2r * z1i - z1r * z2i) / denom;
    }
  float[] zQ = { zQr, zQi };
  return zQ;
}

float[] cpxExpn(float z1r, float z1i, float z2r, float z2i) {
  // Return the power of 2 complex numbers; zX = z1 ^ z2
  float z1abs = sqrt((z1r * z1r + z1i * z1i));    // abs value of base
  float z2abs = sqrt((z2r * z2r + z2i * z2i));    // abs value of exp
  float zXr = 0.0; float zXi = 0.0; float z1theta = 0.0;

  if (z1r == 0.0) 
    {
    if (z1i < 0.0) {
      z1theta = -HALF_PI;}
    else {
      z1theta = HALF_PI;}
    }
  else
    {
    float tanz1 = z1i / z1r;
    z1theta = atan(tanz1);
    if (z1r < 0.0)
      if (z1i < 0.0)
        {z1theta -= PI;}
      else
        {z1theta += PI;}
    }
  if (z1abs == 0.0)
    {
    if (z2abs== 0.0) 
      {zXr = 1.0; zXi = 0.0;}
    else 
      {zXr = 0.0; zXi = 0.0;}
    }
  else
    {
    float Xpointr = z2i * log(z1abs) + z2r * z1theta;    // the Directorant
    float Xscaler = pow(z1abs, z2r) / exp(z2i * z1theta); 
    zXr = cos(Xpointr) * Xscaler;
    zXi = sin(Xpointr) * Xscaler;
    }
  float[] zX = { zXr, zXi };
  return zX;
}

void drawTicks(int N, float scale) {
  if (N > 0)
    {
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
  if (fzComp) 
    { 
    if (N > 0)
      {NN = int(atan(N) * 180);}
    else
      {NN = int(HALF_PI * 180);
      posNtag = "∞";   //str(char(236));
      negNtag = "-∞";} 
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
