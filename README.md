# Plot Complex Functions
Dynamicly plot various functions on complex domain.

Plot complex function  
  **z2 = f(z1)**  
where the value of z1 is provided by the position of the mouse  
  (with fine adjustments performed with keyboard arrows)  
    
Set the function to be plotted (and title) at @@@ eyecatcher

## cpxFunPlot1
Plot the domain value *z* and its function value *f(z)* 
on the same complex plane. Out of bounds values will not be 
shown; scale may be adjusted at appropriate line of code.
### Keyboard Operations
The arrow keys may be used to adjust the cursor value (from 
which the *z.real* and *z-imag* values are derived) by smal amounts.
This adjustment value *delta* defaults to 1 pixel.
- left arrow: decrease X-cursor value by *delta* pixels
- right arrow: increase X-cursor value by *delta* pixels
- up arrow: decrease Y-cursor value by *delta* pixels
- down arrow: increase Y-cursor value by *delta* pixels

## cpxFunPlot2
Plot the domain value *z* and its function value *f(z)* 
side by side on two separate complex planes.
### Keyboard Operations
Arrow keys to adjust cursor value as above; plus facility to
adjust the *delta* adjustment.
- \+ plus key: increase (double) the *delta* value 
- \- minus key: decrease (halve) the *delta* value

## cpxFunPlot3
