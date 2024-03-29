# Plot Complex Functions
Dynamicly plot various functions on complex domain.

Plot complex function  
  *z2 = f(z1)*  
where the value of *z1* is provided by the position of the mouse  
  (with fine adjustments performed with keyboard arrows)  
    
Set the function to be plotted (and title) at @@@ eyecatcher

## cpxFunPlot1
Plot the domain value *z* and its function value *f(z)* 
on the same complex plane. Out of bounds values will not be 
shown; scale may be adjusted at appropriate line of code.
### Keyboard Operations
The arrow keys may be used to adjust the cursor value (from which 
the *z.real* and *z-imag* values are derived) by small amounts.
This adjustment value *delta* is equivalent to 1 pixel.
- left arrow: decrease X-cursor value by *delta* pixels
- right arrow: increase X-cursor value by *delta* pixels
- up arrow: decrease Y-cursor value by *delta* pixels
- down arrow: increase Y-cursor value by *delta* pixels

## cpxFunPlot2
Plot the domain value *z* and its function value *f(z)* 
side by side on two separate complex planes.  
Allows for compression of *f(z)* side to allow all values to
be displayed.  
(See images cfp2_ZexpZ-11.tif, cfp2_ZexpZ-22.tif.)  
### Keyboard Operations
Arrow keys to adjust cursor value as above; plus facility to
adjust the *delta* adjustment.
- \+ plus key: increase (double) the *delta* value 
- \- minus key: decrease (halve) the *delta* value

## cpxFunPlot3@ (where @ = L or C)
Plot a domain locus of values *z* and their corresponding function 
values *f(z)* side by side on two separate complex planes.  
Allow various forms of compression of *f(z)* to be selected - 
None (linear); Rectangular (atan of real and imag parts); and Polar 
(atan of the radius in polar form). 
(See images cfp3l_ZexpZ-1636P.tif, etc.)  
### Keyboard Operations
As well as arrows and plus and minus keys to adjust cursor value as above:
- **c** to cycle through Compression mode (N/R/P)
- **p** to increase the number of Points for the *z* locus
- **x** to extend the domain locus
- **j** to join the dots (flip on/off)
- **o** to enable origin to be moved (flip on/off)
- **s** to Save the current frame 
### ...3L (locus ~ Line)
- option **o** allows the anchor point to be moved using arrow keys
### ...3C (locus ~ arc of Circle)
- option **x** extends arc by 5 degrees
- option **o** allows centre of circle to be moved using arrow keys
