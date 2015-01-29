abstract class Agent
{
  public int xPos, yPos;
  public Facing direction;
  public TileType inventory;
  color renderColor;
  
  public Agent(int x, int y) {
    xPos = x;
    yPos = y;
    direction = Facing.LEFT;
    inventory = null;
  }
  
  public void render()
  {
    noStroke();
    fill(renderColor);
    rect(xPos*tileSize + borderSize*2, yPos*tileSize + borderSize*2, 
          tileSize - borderSize*4, tileSize - borderSize*4);
    fill(255);
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
}

class Parent extends Agent
{
  public Parent(int x, int y)
  {
    super(x, y);
    renderColor = color(77, 35, 219);
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
  
  public Child(int x, int y)
  {
    super(x, y);
    renderColor = color(141, 115, 232);
    commandQueue = new LinkedList<Command>();
    eventMemory = new LinkedList<Event>();
    rules = new LinkedList<Rule>();
    learnFrequency = 5;
    isLearning = true;
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
    eventMemory.add(e);
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
    rules.add(r);
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
    println("child is executing!");
    ArrayList<Action> nextActions = (ArrayList<Action>)gitActionSet(rules, state);
    if (nextActions.size() > 0) {
      Action a = nextActions.get(rng.nextInt(nextActions.size()));
      println("child next action: " + a);
      if (a == Action.move) {
        commandQueue.add(walkUp);
      } else if (a == Action.t_right) {
        commandQueue.add(walkRight);
      } else if (a == Action.t_left) {
        commandQueue.add(walkDown);
      } else if (a == Action.t_back) {
        commandQueue.add(walkLeft);
      } else if (a == Action.pickup) {
        commandQueue.add(pickup);
      } else if (a == Action.drop) {
        commandQueue.add(drop);
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
    if (eventMemory.size() % learnFrequency == 0) {
      println("child is learning!");
      // re-learn rules, obliterating old knowledge
      rules = (List<Rule>)simpleLearn(eventMemory);
      println("child memory size: " + eventMemory.size() + " | # rules: " + rules.size());
    }
  }
  
  public void setLearning(boolean willLearn) {
    isLearning = willLearn;
  }
}
