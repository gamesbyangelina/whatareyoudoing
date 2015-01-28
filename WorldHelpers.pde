boolean inBounds(int x, int y)
{
  return !(x < 0 || y < 0 || x >= gridSizeX || y >= gridSizeY);
}


//method to check world state for conditions for a particular actor
ArrayList<Condition> checkConditions(Agent actor)
{
  ArrayList<Condition> conditions = new ArrayList<Condition>();
  PVector facingDir = actor.getFacingDirection();
  int faceX = int(facingDir.x);
  int faceY = int(facingDir.y);
  int perpX = -1 * faceY;  //perpendicular vector to facing vector
  int perpY = faceX;
  
  //front
  int frontX = actor.xPos + faceX;
  int frontY = actor.yPos + faceY;
  if (inBounds(frontX, frontY)) {
    if (world[frontX][frontY] == TileType.STONE) conditions.add(Condition.stone_front);
    if (world[frontX][frontY] == TileType.RIVER) conditions.add(Condition.river_front);
  }
  
  //right
  int rightX = actor.xPos + perpX;
  int rightY = actor.yPos + perpY;
  if (inBounds(rightX, rightY)) {
    if (world[rightX][rightY] == TileType.STONE) conditions.add(Condition.stone_right);
    if (world[rightX][rightY] == TileType.RIVER) conditions.add(Condition.river_right);
  }
  
  //behind
  int behindX = actor.xPos - faceX;
  int behindY = actor.yPos - faceY;
  if (inBounds(behindX, behindY)) {
    if (world[behindX][behindY] == TileType.STONE) conditions.add(Condition.stone_behind);
    if (world[behindX][behindY] == TileType.RIVER) conditions.add(Condition.river_behind);
  }
  
  //left
  int leftX = actor.xPos - perpX;
  int leftY = actor.yPos - perpY;
  if (inBounds(leftX, leftY)) {
    if (world[leftX][leftY] == TileType.STONE) conditions.add(Condition.stone_left);
    if (world[leftX][leftY] == TileType.RIVER) conditions.add(Condition.river_left);
  }
  
  return conditions;
}
