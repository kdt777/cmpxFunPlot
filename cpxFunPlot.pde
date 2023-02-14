/**
 * Plot complex function
 *   z2 = f(z1)
 * where the value of z1 is provided by the position of the mouse
 *   (with fine adjustments performed with keyboard arrows)
 * Set the function to be plotted (and title) below at ll 51 ~ 58
 **/
 
int zXadj = 0;    // globals to finesse cursor value
int zYadj = 0;

void setup() {
   size(640, 640);
   cursor(CROSS);
}

void keyPressed() {
  if (key == CODED) {
    switch(keyCode) {
      case LEFT:
        //println("Left arrow pressed");
        zXadj -= 1;
        break;
      case RIGHT:
        //println("Right arrow pressed");
        zXadj += 1;
        break;
      case UP:
        //println("Up arrow pressed");
        zYadj -= 1;
        break;
      case DOWN:
        //println("Down arrow pressed");
        zYadj += 1;
        break;
    }
  }
}

void draw() {
    background(40);   // grey
    //loadPixels();
    int zR0 = width / 2;
    int zI0 = height / 2;
    float scale = width / 16.0;      // best set this to 8 or 16 or 8*N
    float zX = mouseX + zXadj;
    float zY = mouseY + zYadj;
    float zR = (mouseX + zXadj - zR0) / scale;   
    float zI = (zI0 - mouseY - zYadj) / scale;   
    
    //                                   *** complex function follows... ***
    //float[] fz = cpxMult(zR, zI, zR, zI);         // z**2  
    //float[] fz = cpxDivn(1.0, 0.0, zR, zI);       // 1/z
    float[] fz = cpxExpn(2.718282, 0.0, zR, zI);    // e^z
    //float[] fz = cpxExpn(zR, zI, zR, zI);         // z^z
    //float[] fz = cpxExpn(zR, zI, 0.0, 1.0);       // z^i
    surface.setTitle("f(z) = e^z");
    
    float fzR = fz[0];
    float fzI = fz[1];
    
    int fzX = zR0 + int(fzR * scale); 
    int fzY = zI0 - int(fzI * scale);
    
    stroke(212);
    line(1, zR0, width, zR0);     // R axis
    line(zI0, 1, zI0, height);    // I axis
    
    noCursor(); 
    rectMode(CENTER);
    fill(255, 200, 200);    // set fill to pink
    square(zX, zY, 12);     //   plot z value
    fill(255, 0, 0);        // set fill to red
    circle(fzX, fzY, 6);    //   plot f(z) value
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
    //textSize(10);
    //text(str(zXadj), 200, 580); 
    //text(str(zYadj), 200, 595); 
    
    drawTicks(1, scale);
    drawTicks(2, scale);
    drawTicks(3, scale);
    drawTicks(4, scale);
  
    PFont font;
    //font = createFont("Courier New Italic", 16);  
    font = createFont("Arial Italic", 16); 
    textFont(font);
    text("I", zR0 + 5, 20);
    text("R", width - 20, zI0); 
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
  //z1abs = math.hypot(z1r, z1i) 
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
        z1theta -= PI;
      else
        z1theta += PI;
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
  int zR0 = width / 2;
  int zI0 = height / 2;
  text(str(N), zR0 + N * scale, zI0 - 2);       // pos N.real
  line(zR0 + N * scale, zI0, zR0 + N * scale, zI0 + 8); 
  stroke(255);
  text(str(-N), zR0 - N * scale, zI0 - 2);      // neg N.real
  line(zR0 - N * scale, zI0, zR0 - N * scale, zI0 + 8); 
  text(str(N), zR0 + 2, zI0 - N * scale);       // pos N.imag
  line(zR0 - 8, zI0 - N * scale, zR0, zI0 - N * scale); 
  text(str(-N), zR0 + 2, zI0 + N * scale);      // neg N.imag
  line(zR0 - 8, zI0 + N * scale, zR0, zI0 + N * scale);
}
