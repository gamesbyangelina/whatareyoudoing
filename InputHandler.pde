import org.gamecontrolplus.gui.*;
import org.gamecontrolplus.*;
import net.java.games.input.*;
import java.util.*;
import java.util.HashMap;

class InputHandler {

  //Commented out because persistence is a barrel of evil fucking monkeys.
  //private static InputHandler instance;

  //TODO: This will probably break when you run it on Mac.
  private final String deviceName = "Controller (XBOX 360 For Windows)";

  //We can play around with this value and change it depending on our needs.
  private final double joystickThreshold = 0.5;
  private final double joystickDeadzone = 0.2;

  // This one is essential
  ControlIO control;
  // A ControlDevice might be a joystick, gamepad, mouse etc.
  ControlDevice gamePad;

  // All buttons, hats and sliders we are using.
  ControlButton button1, button2, button3, button4;
  ControlHat hat;
  ControlSlider leftSliderX, leftSliderY;
  ControlSlider rightSliderX, rightSliderY;

  Map<InputButtons, Boolean> buttonPressed;
  Map<InputAxis, Float> joystickActive;

  //Change from protected to public because processing is as accepting as the UKIP party.
  public InputHandler(PApplet sketch) {
    initialSetup(sketch);
    resetInputState();
  }

  /**
   * Singleton pattern baby! Aw yeah...
   *
   * EDIT: Processing is a baw...
   */
   /*
  public static InputHandler getInstance() {
    if (instance == null) {
      return new InputHandler();
    } else {
      return instance;
    }
  } */

  private void initialSetup(PApplet sketch) {
    println("Attempting to acquire ControlIO Instance.");

    /* Initialise the game control library.
     * NOTE: This is rather interesting in that it can cause an exception
     * to appear in the debug console.  However, the exception is NOT being
     * thrown by the ControlIO class.  It appears to be deeper within the
     * device control layers.  As such, you cannot catch any of these exceptions
     * as they occur. 
     **/

    control = ControlIO.getInstance(sketch);

    /* Now find the specific controller instance.
     * It's a preset collection of device names that are available.
     * This is found using the Pcp_ShowDevices example from the GameControlPlus
     * library.
     */
    println("Attempting to acquire Xbox 360 controller.");
    gamePad = control.getDevice(deviceName);
  }

  private void resetInputState() {
    buttonPressed = new HashMap<InputButtons, Boolean>();
    joystickActive = new HashMap<InputAxis, Float>();
  }

  public void updateInput() {

    resetInputState();

    /*Check all of the input buttons, see if they are currently pressed and
     *set it to the appropriate value.
     */
    for (InputButtons buttonKey : InputButtons.values ()) {
      ControlButton currentButton = gamePad.getButton(buttonKey.getIDNumber());
      buttonPressed.put(buttonKey, currentButton.pressed());
    }

    /**
     * Next, we check whether a stick has been moved over on a given axis and then
     * whether it returned to the central point.
     */
    for (InputAxis inputAxis : InputAxis.values ()) {
      ControlSlider currentAxis = gamePad.getSlider(inputAxis.getIDString());

      float axisValue = currentAxis.getValue();

      if (axisValue >= joystickThreshold) {
        joystickActive.put(inputAxis, axisValue);
      } else if (axisValue < joystickDeadzone) {
        joystickActive.put(inputAxis, 0.0);
      }
    }
  }

  /**
   * Quick and easy method to check whether an input button
   * on the game pad is being pressed this frame.
   */
  public boolean buttonPressed(InputButtons button) {
    if (buttonPressed.containsKey(button)) {
      return buttonPressed.get(button);
    } else {
      println("Button Press Request Failed - Button Not Recognised: "+button);
      return false;
    }
  }

  /**
   * Quick and easy method to check whether an input button
   * on the game pad is being pressed this frame.
   */
  public float axisValue(InputAxis axis) {
    if (joystickActive.containsKey(axis)) {
      return joystickActive.get(axis);
    } else {
      println("Joystick Axis Request Failed - Axis Not Recognised: "+axis);
      return 0.0;
    }
  }
}

