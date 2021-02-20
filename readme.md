# Rules
## Functions shouldn't change global origin
### Example
`draw_a_square_in_center` should only draw a square in center.
But it also change the global state of origin.
Now poor circle is at right-bottom of scren.
```processing
void setup() {
  size(800, 600);
  background(236, 226, 225);
}

void draw() {
  draw_a_rectagle_in_center();
  circle(width/2, height/2, 50);
  
}

void draw_a_square_in_center() {
  translate(width/2, height/2);
  rect(0, 0, 100,100);
}

```
- Functions don't depend on another
### Solution
Use `pushMatrix` everywhre.
```processing
void setup() {
  size(800, 600);
  background(236, 226, 225);
}

void draw() {
  draw_a_rectagle_in_center();
  circle(width/2, height/2, 50);
  
}

void draw_a_square_in_center() {
  pushMatrix();
    translate(width/2, height/2);
    rect(0, 0, 100,100);
  popMatrix();
}

```
## Functions shouldn't depend on another functions state
f(x) = y means y is only depend on x, and global variable in our case :(.
A function can operate with global variables, but it shouldn't need caller function's state.
Beacuse it's hard for extracting specific part later from that chapter.
### Example
Wait what?
Why `bar` didn't centered the circle. When I call from `foo` it did.
```processing
void setup() {
  size(800, 600);
  background(236, 226, 225);
}

void draw() {
  foo();
  bar();
}

void foo() {
  translate(width/2, height/2);
  circle(0, 0, 100);
  bar();
}

void bar(){
  circle(0, 0, 50);
}
```
### Solution
TODO
# Style
## Function Template
```processing
void foo(){
    pushMatrix();

    // Matrix must made sandwich

    popMatrix();
}
```
## Format
Use auto-format from processing's ide.
It's bound to C-t (Control-t)
## Assign values for visuals in `setup()`
# Info

Processing doesn't follow [Cartesian coordinate system](https://en.wikipedia.org/wiki/Cartesian_coordinate_system).

<p align="center">
 <img width="460" height="300" src="https://processing.org/tutorials/drawing/imgs/drawing-03.svg">
</p>
    
    
It uses `translate(x,y)` to temporarirly changing orign.
Each changing lives untill
- Another `translate(x,y)`
- Popped Matrix

