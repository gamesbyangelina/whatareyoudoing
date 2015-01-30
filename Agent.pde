abstract class Agent
{
  public int xPos, yPos;
  public Facing direction;
  public TileType inventory;
  color renderColor;
  PImage agentImage;
  
  public Agent(int x, int y) {
    xPos = x;
    yPos = y;
    direction = Facing.LEFT;
    inventory = null;
  }
  
  public void render()
  {
    noStroke();
    //fill(renderColor);
    rect(xPos*tileSize + borderSize*2, yPos*tileSize + borderSize*2, 
          tileSize - borderSize*4, tileSize - borderSize*4);
    //fill(255);
    image (agentImage, xPos*tileSize, yPos*tileSize, tileSize, tileSize);
    
    if (direction == Facing.UP) 
      ellipse(xPos*tileSize + tileSize/2, yPos*tileSize + borderSize*4, 2, 2);
    else if (direction == Facing.RIGHT) 
      ellipse(xPos*tileSize + tileSize - borderSize*6, yPos*tileSize + tileSize/2, 2, 2);
    else if (direction == Facing.DOWN)
      ellipse(xPos*tileSize + tileSize/2, yPos*tileSize + tileSize - borderSize*6, 2, 2);
    else if (direction == Facing.LEFT)
      ellipse(xPos*tileSize + borderSize*4, yPos*tileSize + tileSize/2, 2, 2);
  }
  
  public PVector getFacingDirection()
  {
    int xDir = (direction == Facing.UP || direction == Facing.DOWN) ? 0 : (direction == Facing.RIGHT) ? 1 : -1;
    int yDir = (direction == Facing.RIGHT || direction == Facing.LEFT) ? 0 : (direction == Facing.UP) ? -1 : 1;
    return new PVector(xDir, yDir);
  }
  
  public Command moveTowardAgent(Agent a, int minSeparation)
  {
    int xDist = a.xPos - this.xPos;
    int yDist = a.yPos - this.yPos;
    
    Command returnCommand = null;
    if (Math.abs(xDist) + Math.abs(yDist) < minSeparation) {
      return returnCommand;
    }
    
    if (Math.abs(xDist) > Math.abs(yDist)) {
      // further on x-axis -> move on x-axis
      if (xDist > 0) {
        returnCommand = walkRight;
      } else {
        returnCommand = walkLeft;
      }
    } else {
      // further on y-axis -> move on y-axis
      if (yDist > 0) {
        returnCommand = walkDown;
      } else {
        returnCommand = walkUp;
      }
    }
    
    return returnCommand;  
  }
  
}

class Enemy extends Agent
{
  public Enemy(int x, int y)
  {
    super(x, y); 
    renderColor = color(250, 230, 50); 
  }
  
  public void act()
  {
      //pick a random child and move towards it
      
  }
}

class Parent extends Agent
{
  public Parent(int x, int y)
  {
    super(x, y);
    renderColor = color(77, 35, 219);
    agentImage = loadImage("img/R_Shrubs_Right.png");// parentImg;
  }
}

class Child extends Agent
{
  private LinkedList<Command> commandQueue;
  
  private LinkedList<Event> eventMemory; // memory of events in the past
  private List<Rule> rules; // learned rules
  
  private boolean isLearning; // whether child is learning
  private int learnFrequency; // number of turns before learning
  
  private Random rng = new Random();
  
  private int minSeparation = 4; // # of tiles separation to stop following

  final int memorylimit = 20;
  
 
  
  public Child(int x, int y)
  {
    super(x, y);
    renderColor = color(141, 115, 232);
    commandQueue = new LinkedList<Command>();
    eventMemory = new LinkedList<Event>();
    rules = new LinkedList<Rule>();
    learnFrequency = 5;
    isLearning = true;
    agentImage = loadImage("img/Y_Shrubs_Right.png");  // parentImg;
  }
  
  public Child(int x, int y, int learnFreq)
  {
    super(x, y);
    renderColor = color(141, 115, 232);
    commandQueue = new LinkedList<Command>();
    eventMemory = new LinkedList<Event>();
    // start with random rules

    rules = testRuleCreation ();// new LinkedList<Rule>();
    
    learnFrequency = learnFreq;
    isLearning = true;
  }
  
  public void addEventToMemory(Event e) 
  {
    //If this action type is not in our recent memory, be interested!
    if(playSFX && newActionType(e) && int(random(10)) < 3 && (e.action == Action.drop)){
         sfx_understanding.rewind();
         sfx_understanding.play();   
    }
    eventMemory.add(e);
    if (eventMemory.size () > memorylimit) {
      // forget the earliest event
      eventMemory.remove (0);
    }
  }
  
  public boolean newActionType(Event ev){
     for(Event e : eventMemory){
        if(e.action == ev.action)
            return false;
     } 
     return true;
  }
  
  public void addRuleToMemory(Rule r) 
  {
    rules.add(r);
  }
  
  public void removeEventFromMemory(Event e) 
  {
    eventMemory.remove(e);
  }
  
  public void removeRuleFromMemory(Rule r) 
  {
    rules.remove(r);
  }
  
  public List<Rule> gitRules() {
    return rules;
  }
  
  public void addCommandToQueue(Command c)
  {
    commandQueue.add(c);
  }
  
  public void addAllCommandsToQueue(ArrayList<Command> c)
  {
    commandQueue.addAll(c);
  }
  
  public void executeNextCommand(List<Condition> state)
  {
//    println("child is executing!");
    ArrayList<Action> nextActions = (ArrayList<Action>)gitActionSet(rules, state);
    if (nextActions.size() > 0) {
      Action a = nextActions.get(rng.nextInt(nextActions.size()));
      println("child next action: " + a);
      if (a == Action.move) {
//        Facing.UP, Facing.DOWN, Facing.LEFT, Facing.RIGHT
        if (this.direction == Facing.UP) {
         commandQueue.add(walkUp); 
        } else if (this.direction == Facing.RIGHT) {
          commandQueue.add(walkRight);
        } else if (this.direction == Facing.DOWN) {
          commandQueue.add(walkDown);
        } else if (this.direction == Facing.LEFT) {
          commandQueue.add(walkLeft);
        }
      } else if (a == Action.t_right) {
        // convert facing to use a move command to change without moving
        if (this.direction == Facing.UP) {
          commandQueue.add(walkRight);
        } else if (this.direction == Facing.RIGHT) {
          commandQueue.add(walkDown);
        } else if (this.direction == Facing.DOWN) {
          commandQueue.add(walkLeft);
        } else if (this.direction == Facing.LEFT) {
          commandQueue.add(walkUp);
        }
      } else if (a == Action.t_left) {
        // convert facing to use a move command to change without moving 
        if (this.direction == Facing.UP) {
          commandQueue.add(walkLeft);
        } else if (this.direction == Facing.RIGHT) {
          commandQueue.add(walkUp);
        } else if (this.direction == Facing.DOWN) {
          commandQueue.add(walkRight);
        } else if (this.direction == Facing.LEFT) {
          commandQueue.add(walkDown);
        }
      } else if (a == Action.t_back) {
        // convert facing to use a move command to change without moving
        if (this.direction == Facing.UP) {
          commandQueue.add(walkDown);
        } else if (this.direction == Facing.RIGHT) {
          commandQueue.add(walkLeft);
        } else if (this.direction == Facing.DOWN) {
          commandQueue.add(walkUp);
        } else if (this.direction == Facing.LEFT) {
          commandQueue.add(walkRight);
        }
      } else if (a == Action.pickup) {
        commandQueue.add(pickup);
      } else if (a == Action.drop) {
        commandQueue.add(drop);
        /*
        if(childIsCarryingSomething()){
          sfx_whee.rewind();
          sfx_whee.play();
        }
        */
      }
    } else {
      Command follow = moveTowardAgent(parent, minSeparation);
      if (follow != null) {
//        println("child moving toward parent!");
        commandQueue.add(follow);
      }
    }
    
    if (hasCommandsInQueue()) {
      Action a = commandQueue.remove().perform(this);
      println("child just: " + a);
    }
  }
  
  public boolean hasCommandsInQueue()
  {
    return commandQueue.size() > 0;
  }
  
  public void learn()
  {
    // only learn if child is in learning phase
    if (!isLearning) {
      return;
    }
    
    // learn only when memory increases
    if (turn % learnFrequency == 0) { 
    //if (eventMemory.size() % learnFrequency == 0) {
      //println("child is learning!");
      // re-learn rules, obliterating old knowledge
      int memory_before = rules.size();
      
      rules = (List<Rule>)simpleLearn(eventMemory);
      
      if(rules.size() != memory_before && playSFX){
          //Play a sound
          int sfx = int(random(4));
          sfx_learnNewRule.get(sfx).rewind();
          sfx_learnNewRule.get(sfx).play(); 
      }
      
      //println("child memory size: " + eventMemory.size() + " | # rules: " + rules.size());
    }
  }
  
  public void setLearning(boolean willLearn) {
    isLearning = willLearn;
  }
}
