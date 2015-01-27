class Agent
{
  public int xPos, yPos;
  
  public Agent() {
    xPos = int(random(0, gridSizeX));
    yPos = int(random(0, gridSizeY));
  }
  
  
}

class Parent extends Agent
{
}

class Child extends Agent
{
}
