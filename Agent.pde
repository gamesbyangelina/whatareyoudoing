abstract class Agent
{
  public int xPos, yPos;
  color renderColor;
  
  public Agent() {
    xPos = int(random(0, gridSizeX));
    yPos = int(random(0, gridSizeY));
  }
  
  public void render()
  {
    noStroke();
    fill(renderColor);
    ellipse(xPos*tileSize - tileSize/2, yPos*tileSize - tileSize/2, tileSize - 4, tileSize - 4);
  }
}

class Parent extends Agent
{
  public Parent()
  {
    super();
    renderColor = color(77, 35, 219);
  }
}

class Child extends Agent
{
  public Child()
  {
    super();
    renderColor = color(141, 115, 232);
  }
}
