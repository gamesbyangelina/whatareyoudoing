import org.gamecontrolplus.gui.*;
import org.gamecontrolplus.*;
import net.java.games.input.*;

import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

int gridSizeX = 15;
int gridSizeY = 15;
int tileSize = 40;
int sidebarSizeX = 300;
int borderSize = 1;
int statusBarSize = 100;
int turn = 0;

boolean gameOver = false;

TileType[][] world;
color groundColor = color(183, 72, 72);
color riverColor = color(44, 245, 240);
color stoneColor = color(198, 192, 192);
color strawberryColor = color(34, 42, 85);
color textColor = color (255, 255, 255);
color ERROR_COLOR = color(252, 10, 252); 

boolean renderArt = true;
PImage backdrop;

boolean playSFX = true;
Minim minim;
AudioPlayer sfx_splash;
ArrayList<AudioPlayer> sfx_learnNewRule = new ArrayList<AudioPlayer>();
AudioPlayer sfx_understanding;
AudioPlayer sfx_whee;
ArrayList<AudioPlayer> sfx_snip = new ArrayList<AudioPlayer>();
AudioPlayer sfx_cutthatout;

Parent parent;
ArrayList<Child> children;
int numChildren = 2;

InputHandler inputHandler;



Command walkLeft, walkRight, walkUp, walkDown, pickup, drop;

void setup()
{
  size(gridSizeX*tileSize+sidebarSizeX, gridSizeY*tileSize + statusBarSize);

  world = new TileType[gridSizeX][gridSizeY];
  for (int i = 0; i < gridSizeX; i++) {
    for (int j = 0; j < gridSizeY; j++) {
      world[i][j] = (random(1) < 0.1) ? TileType.RIVER : null;
    }
  }

  world = GenerateWorld(gridSizeX, gridSizeY, 2);

  int xPos, yPos;
  do {
    xPos = int(random(0, gridSizeX));
    yPos = int(random(0, gridSizeY));
  } 
  while (world[xPos][yPos] != null);
  parent = new Parent(xPos, yPos);

  children = new ArrayList<Child>();
  for (int i = 0; i < numChildren; i++)
  {
    do {
      xPos = int(random(parent.xPos - 5, parent.xPos + 5));
      yPos = int(random(parent.yPos - 5, parent.yPos + 5));
    } 
    while (!inBounds (xPos, yPos) || ((world[xPos][yPos] != null && xPos != parent.xPos && yPos != parent.yPos)));
    Child child = new Child(xPos, yPos);
    children.add(child);
  }

  walkLeft = new WalkLeftCommand();
  walkRight = new WalkRightCommand();
  walkUp = new WalkUpCommand();
  walkDown = new WalkDownCommand();
  pickup = new PickupCommand();
  drop = new DropCommand();

  smooth();
  
  //Load in graphics
  backdrop = loadImage("img/Backdrop2.png");
  
  //Set up the input handler.
  //inputHandler = InputHandler.getInstance();
  inputHandler = new InputHandler(this);
  
  //Load the audio stuff
  minim = new Minim(this);
  sfx_splash = minim.loadFile("assets/splash.wav");
  sfx_learnNewRule.add(minim.loadFile("assets/newrule1.mp3"));
  sfx_learnNewRule.add(minim.loadFile("assets/newrule2.mp3"));
  sfx_learnNewRule.add(minim.loadFile("assets/newrule3.mp3"));
  sfx_learnNewRule.add(minim.loadFile("assets/newrule4.mp3"));
  sfx_snip.add(minim.loadFile("assets/snip1.mp3"));
  sfx_snip.add(minim.loadFile("assets/snip2.mp3"));
  sfx_understanding = minim.loadFile("assets/ohh.mp3");
  sfx_whee = minim.loadFile("assets/wee.mp3");
  sfx_cutthatout = minim.loadFile("assets/cutthatout.mp3");
}


void draw()
{
  background(0);
  
  if(renderArt)
    image(backdrop, 0, 0, tileSize*gridSizeX, tileSize*gridSizeY);
  
  //handleInput();

  //draw the base tile grid
  for (int i = 0; i < gridSizeX; i++) {
    for (int j = 0; j < gridSizeY; j++) {
      pushMatrix();
      translate(i*tileSize, j*tileSize);
      noStroke();
      if (world[i][j] == TileType.RIVER) {
        fill(riverColor);
      } else if (world[i][j] == TileType.STONE) {
        fill(stoneColor);
      } else if (world[i][j] == TileType.STRAWBERRY) {
        fill(strawberryColor);
      } else {
        fill(groundColor);
      }
      if(world[i][j] != null || !renderArt)
        rect(borderSize, borderSize, tileSize - 2*borderSize, tileSize - 2*borderSize);
      noFill();
      stroke(50);
      strokeWeight(1.75);
      rect(borderSize, borderSize, tileSize - 2*borderSize, tileSize - 2*borderSize);
      strokeWeight(1);

      popMatrix();
    }
  }

  //draw the status bar
  fill(255);
  String holdingString = "Parent is holding: ";
  holdingString += (parent.inventory != null && parent.inventory == TileType.STONE) ? "a stone!" : "nothing";
  text(holdingString, 10, gridSizeY*tileSize + 20);
  for (int i = 0; i < numChildren; i++)
  {
    holdingString = "Child " + str(i+1) + " is holding: ";
    holdingString += (children.get(i).inventory != null && children.get(i).inventory == TileType.STONE) ? "a stone!" : "nothing";
    text(holdingString, 10, gridSizeY*tileSize + 50 + i*25);
  }

  parent.render();
  for (Child child : children) child.render();

  // draw the current set of rules
  List<Rule> childRules = children.get(0).gitRules();
  //List<Rule> childRules = testRules;
//  println (childRules.size ());
  final int xOffset = gridSizeX * tileSize + tileSize;
  final int yOffset = 0;
  int line = 1;
  final int linewidth = tileSize*3 + tileSize/2;
  textFont(createFont("Arial", 14, true));
  fill (textColor);
  for (Rule rule : childRules) {
    rule.draw(xOffset, yOffset+line*linewidth);
    text(""+line, xOffset, yOffset+line*linewidth);
    //text(text, xOffset, yOffset+line*linewidth);  
    line++;
  }
}

/**
 * This method handles all of the input handling for the gamepad.
 * Note that unlike the traditional input methods such as the keyPressed
 * method, we need to call this every frame in the main game code.
 */
void handleInput()
{
  Event event = new Event();
  ArrayList<Condition> conditions = checkConditions(parent);
  event.addPreconditions(conditions);

  println("Grabbing Input...");  
  /**
   * Next, let us focus on the actions, such as picking up, dropping etc.
   * Not to mention all of the movement.  This is reliant upon the buttons on the game pad.
   */
  Action occurredAction = null;
  
  //Grab the input handler and update for the current frame.
  inputHandler.updateInput();
  
  if(inputHandler.buttonPressed(InputButtons.A)){
    pickup.perform(parent);
  }
  else if(inputHandler.buttonPressed(InputButtons.B)){
    drop.perform(parent);  
  }
  
  if(inputHandler.buttonPressed(InputButtons.DPAD_LEFT)){
    occurredAction = walkLeft.perform(parent);
  }
  else if(inputHandler.buttonPressed(InputButtons.DPAD_RIGHT)){
    occurredAction = walkRight.perform(parent);
  }
  
  if(inputHandler.buttonPressed(InputButtons.DPAD_UP)){
    occurredAction = walkUp.perform(parent);
  }
  else if(inputHandler.buttonPressed(InputButtons.DPAD_DOWN)){
    occurredAction = walkDown.perform(parent);
  }
  
  
  //add the action to the event
  for (Child child : children) {
    if (occurredAction != null) {
      event.addAction(occurredAction);
      println(event);
      child.addEventToMemory(event);
    }

    ArrayList<Condition> childConditions = checkConditions(child);
    //execute the next command in the child's queue
    child.executeNextCommand(childConditions);
    child.learn();
  }
  
  turn++;
}


void keyPressed()
{
  Event event = new Event();

  //what is true about the world before the action takes place?
  ArrayList<Condition> conditions = checkConditions(parent);
  event.addPreconditions(conditions);

  Action occurredAction = null;
  if (keyCode == LEFT) occurredAction = walkLeft.perform(parent);
  else if (keyCode == RIGHT) occurredAction = walkRight.perform(parent);
  else if (keyCode == UP) occurredAction = walkUp.perform(parent);
  else if (keyCode == DOWN) occurredAction = walkDown.perform(parent);
  else if (key == 'p') occurredAction = pickup.perform(parent);
  else if (key == 'd') occurredAction = drop.perform(parent);
  else if (key == 'r') setup();
  // now, the numbers that refer to rules
  else if (key >= '1' && key < '9') removeRuleRequest(key - '0');

  //add the action to the event
  if (occurredAction != null) {
    event.addAction(occurredAction);
    println(event);
    for (Child child : children)
      child.addEventToMemory(event);
  }
  
  for (Child child : children) {
    ArrayList<Condition> childConditions = checkConditions(child);
    //execute the next command in the child's queue
    child.executeNextCommand(childConditions);
    child.learn();
  }
  turn++;
  
  if (gameOver) {
    // TODO    
  }
}

void removeRuleRequest(int which) {
  which = which - 1;
  println ("I want to remove rule " + which);
  // more logic here to use resources etc
  for (Child child : children) {
    List<Rule> rules = child.gitRules ();
    if (which >= rules.size ()) {
      println ("There are only " + rules.size () + " rules");
    } else { 
      println("removing a rule");
      child.removeRuleFromMemory(child.gitRules().get(which));
      if(playSFX){
        int index = int(random(2));
         sfx_snip.get(index).rewind();
         sfx_snip.get(index).play(); 
         if(int(random(10)) < 2){
            sfx_cutthatout.rewind();
            sfx_cutthatout.play(); 
         }
      }
    }
  }
}

