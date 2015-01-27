abstract class Agent
{
  public int xPos, yPos;
  public Facing direction;
  public TileType inventory;
  color renderColor;
  
  public Agent() {
    xPos = int(random(0, gridSizeX));
    yPos = int(random(0, gridSizeY));
    direction = Facing.LEFT;
    inventory = null;
  }
  
  public void render()
  {
    noStroke();
    fill(renderColor);
    rect(xPos*tileSize + borderSize*2, yPos*tileSize + borderSize*2, 
          tileSize - borderSize*6, tileSize - borderSize*6);
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
