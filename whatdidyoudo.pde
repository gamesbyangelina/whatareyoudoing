int gridSizeX = 25;
int gridSizeY = 25;
int tileSize = 20;
int borderSize = 1;

TileType[][] world;
color groundColor = color(183, 72, 72);
color riverColor = color(44, 245, 240);
color stoneColor = color(198, 192, 192);

color ERROR_COLOR = color(252, 10, 252); 

Parent parent;


void setup()
{
  size(gridSizeX*tileSize, gridSizeY*tileSize);
  
  world = new TileType[gridSizeX][gridSizeY];
  for (int i = 0; i < gridSizeX; i++) {
    for (int j = 0; j < gridSizeY; j++) {
      world[i][j] = (random(1) < 0.1) ? TileType.RIVER : null;
    }
  }
  
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
      else {
        fill(groundColor);
      }
      rect(0, 0, tileSize - 2*borderSize, tileSize - 2*borderSize);
      popMatrix();  
    }
  }
  parent.render();
}

WalkLeftCommand walkLeft = new WalkLeftCommand();
WalkRightCommand walkRight = new WalkRightCommand();
WalkUpCommand walkUp = new WalkUpCommand();
WalkDownCommand walkDown = new WalkDownCommand();
void keyPressed()
{
  if (keyCode == LEFT) walkLeft.execute(parent);
  else if (keyCode == RIGHT) walkRight.execute(parent);
  else if (keyCode == UP) walkUp.execute(parent);
  else if (keyCode == DOWN) walkDown.execute(parent);
}
