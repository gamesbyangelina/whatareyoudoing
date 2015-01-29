import org.gamecontrolplus.gui.*;
import org.gamecontrolplus.*;
import net.java.games.input.*;

// This one is essential
ControlIO control;
// You will need some of the following depending on the sketch.

// A ControlDevice might be a joystick, gamepad, mouse etc.
ControlDevice device;

// A device will have some combination of buttons, hats and sliders
ControlButton button1, button2, button3, button4;
ControlHat hat;
ControlSlider leftSliderX, leftSliderY;
ControlSlider rightSliderX, rightSliderY;

void setup() {

  println("Attempting to acquire ControlIO Instance.");

  /* Initialise the game control library.
   * NOTE: This is rather interesting in that it can cause an exception
   * to appear in the debug console.  However, the exception is NOT being
   * thrown by the ControlIO class.  It appears to be deeper within the
   * device control layers.  As such, you cannot catch any of these exceptions
   * as they occur. 
   **/

   control = ControlIO.getInstance(this);

  /* Now find the specific controller instance.
   * It's a preset collection of device names that are available.
   * This is found using the Pcp_ShowDevices example from the GameControlPlus
   * library.
   */
  println("Attempting to acquire Xbox 360 controller.");
  device = control.getDevice("Controller (XBOX 360 For Windows)");
}

void draw() {

  /**
   *We check whether a given button is being pressed.
   *This is checked against button indices 0-3 which
   *correspond to the xbox 360 controllers A, B, X & Y.
   */
  println("\n*****\nUpdate!");
  button1 = device.getButton("Button 0");
  println("Button 0 (A) Pressed: "+button1.pressed());
  button2 = device.getButton("Button 1");
  println("Button 1 (B) Pressed: "+button2.pressed());
  button3 = device.getButton("Button 2");
  println("Button 2 (X) Pressed: "+button3.pressed());
  button4 = device.getButton("Button 3");
  println("Button 3 (Y) Pressed: "+button4.pressed());

  /**
   * The d-pad of the game pad is known as a hat.  We 
   * query the hat to get the current status of all four
   * directions.  Note that I have identified the hat as 
   * input index 10 of the game pad, given that the text
   * identifier was not being recognised.
   */
  hat = device.getHat(10);
  
  print("D-Pad: ");
  
  if(hat.up()){
    print("UP ");
  }
  else if(hat.down()){
    print("DOWN ");
  }
  
  if(hat.left()){
    print("LEFT");
  }
  else if(hat.right()){
    print("RIGHT");
  }
  
  println();
  
  /**
   * Finally, we check the values of the X and Y sliders on both analog sticks.
   */
  
  leftSliderX = device.getSlider("X Axis");
  leftSliderY = device.getSlider("Y Axis");
  println("Left Stick Position: ("+leftSliderX.getValue()+","+leftSliderY.getValue()+")");
  
  leftSliderX = device.getSlider("X Rotation");
  leftSliderY = device.getSlider("Y Rotation");
  println("Right Stick Position: ("+leftSliderX.getValue()+","+leftSliderY.getValue()+")");
  
  println("\n*****");
}

