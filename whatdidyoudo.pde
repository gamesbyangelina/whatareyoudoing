int gridSizeX = 25;
int gridSizeY = 25;
int tileSize = 20;
int borderSize = 1;
int statusBarSize = 100;

TileType[][] world;
color groundColor = color(183, 72, 72);
color riverColor = color(44, 245, 240);
color stoneColor = color(198, 192, 192);

color ERROR_COLOR = color(252, 10, 252); 

Parent parent;


void setup()
{
  size(gridSizeX*tileSize, gridSizeY*tileSize + statusBarSize);
  
  world = new TileType[gridSizeX][gridSizeY];
  for (int i = 0; i < gridSizeX; i++) {
    for (int j = 0; j < gridSizeY; j++) {
      world[i][j] = (random(1) < 0.1) ? TileType.RIVER : null;
    }
  }
  
  world = GenerateWorld(gridSizeX, gridSizeY, 3);
  
  parent = new Parent();
  
  smooth();
}


void draw()
{
  background(0);
  
  //draw the base tile grid
  for (int i = 0; i < gridSizeX; i++) {
    for (int j = 0; j < gridSizeY; j++) {
      pushMatrix();
      translate(i*tileSize, j*tileSize);
      noStroke();
      if (world[i][j] == TileType.RIVER) {
        fill(riverColor);
      }
      else if (world[i][j] == TileType.STONE) {
        fill(stoneColor);
      }
      else {
        fill(groundColor);
      }
      rect(0, 0, tileSize - 2*borderSize, tileSize - 2*borderSize);
      popMatrix();  
    }
  }
  
  //draw the status bar
  fill(255);
  String holdingString = "Holding: ";
  holdingString += (parent.inventory != null && parent.inventory == TileType.STONE) ? "a stone!" : "nothing";
  text(holdingString, 10, gridSizeY*tileSize + 10);
  
  parent.render();
}

WalkLeftCommand walkLeft = new WalkLeftCommand();
WalkRightCommand walkRight = new WalkRightCommand();
WalkUpCommand walkUp = new WalkUpCommand();
WalkDownCommand walkDown = new WalkDownCommand();
PickupCommand pickup = new PickupCommand();
DropCommand drop = new DropCommand();
void keyPressed()
{
  if (keyCode == LEFT) walkLeft.execute(parent);
  else if (keyCode == RIGHT) walkRight.execute(parent);
  else if (keyCode == UP) walkUp.execute(parent);
  else if (keyCode == DOWN) walkDown.execute(parent);
  else if (key == 'p') pickup.execute(parent);
  else if (key == 'd') drop.execute(parent);
}
