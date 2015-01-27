interface Command
{
  void execute(Agent actor);
}

class PickupCommand implements Command
{
  void execute(Agent actor) {
    PVector dir = actor.getFacingDirection();
    if (inBounds(actor.xPos + int(dir.x), actor.yPos + int(dir.y)) //the tile the player is facing is in world bounds
            && world[actor.xPos + int(dir.x)][actor.yPos + int(dir.y)] == TileType.STONE  //the tile is a stone
            && actor.inventory == null) //the actor isn't already holding something
    {
      actor.inventory = TileType.STONE;
      world[actor.xPos + int(dir.x)][actor.yPos + int(dir.y)] = null;  
    }
  }
}

class DropCommand implements Command
{
  void execute(Agent actor) {
    PVector dir = actor.getFacingDirection();
    if (inBounds(actor.xPos + int(dir.x), actor.yPos + int(dir.y)) //the tile the player is facing is in world bounds
            && actor.inventory == TileType.STONE) //the actor is holding a stone
    {
      actor.inventory = null;
      world[actor.xPos + int(dir.x)][actor.yPos + int(dir.y)] = TileType.STONE;
    }
  }
}

abstract class WalkCommand implements Command
{
  void execute(Agent actor) {
    boolean isFacing = checkIfFacing(actor);
    if (isFacing) {
      updatePosition(actor);
      resolveCollision(actor);
    }
  }  
  
  void resolveCollision(Agent actor) {
    if (!inBounds(actor.xPos, actor.yPos) || world[actor.xPos][actor.yPos] != null) rollBackPosition(actor);
  }
  
  abstract boolean checkIfFacing(Agent actor);
  abstract void updatePosition(Agent actor);
  abstract void rollBackPosition(Agent actor);
}

class WalkLeftCommand extends WalkCommand
{
  boolean checkIfFacing(Agent actor) {
    if (actor.direction == Facing.LEFT) return true;
    else actor.direction = Facing.LEFT;
    return false;
  }
  
  void updatePosition(Agent actor)   { actor.xPos -= 1; }
  void rollBackPosition(Agent actor) { actor.xPos += 1; } 
}

class WalkRightCommand extends WalkCommand
{
  boolean checkIfFacing(Agent actor) {
    if (actor.direction == Facing.RIGHT) return true;
    else actor.direction = Facing.RIGHT;
    return false;
  }
  
  void updatePosition(Agent actor)   { actor.xPos += 1; }
  void rollBackPosition(Agent actor) { actor.xPos -= 1; }
}

class WalkUpCommand extends WalkCommand
{
  boolean checkIfFacing(Agent actor) {
    if (actor.direction == Facing.UP) return true;
    else actor.direction = Facing.UP;
    return false;
  }
  
  void updatePosition(Agent actor)   { actor.yPos -= 1; }
  void rollBackPosition(Agent actor) { actor.yPos += 1; }
}

class WalkDownCommand extends WalkCommand
{
  boolean checkIfFacing(Agent actor) {
    if (actor.direction == Facing.DOWN) return true;
    else actor.direction = Facing.DOWN;
    return false;
  }
  
  void updatePosition(Agent actor)   { actor.yPos += 1; }
  void rollBackPosition(Agent actor) { actor.yPos -= 1; }
}
