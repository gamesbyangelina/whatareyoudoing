int gridSizeX = 25;
int gridSizeY = 25;
int tileSize = 20;
int borderSize = 1;

TileType[][] world;
color groundColor = color(#B74848);
color riverColor = color(#2CF5F0);

color ERROR_COLOR = color(#FC0AFC); 

void setup()
{
  size(gridSizeX*tileSize, gridSizeY*tileSize);
  
  world = new TileType[gridSizeX][gridSizeY];
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
      if (world[i][j] == TileType.GROUND) {
        fill(groundColor);
      }
      else if (world[i][j] == TileType.RIVER) {
        fill(riverColor);
      }
      else {
        fill(ERROR_COLOR);
      }
      rect(0, 0, tileSize - 2*borderSize, tileSize - 2*borderSize);
      popMatrix();  
    }
  }
  noStroke();
  
  noLoop();
}
