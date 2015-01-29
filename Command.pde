abstract class Command
{
  public Command() {}
  
  public Action perform(Agent actor) {
    execute(actor);
    return getKind();
  }
  
  abstract protected void execute(Agent actor);
  abstract public Action getKind();
}

class PickupCommand extends Command
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
  
  Action getKind() { return Action.pickup; };
}

class DropCommand extends Command
{
  boolean failedToDrop;
  
  void execute(Agent actor) {
    PVector dir = actor.getFacingDirection();
    failedToDrop = false;
    if (inBounds(actor.xPos + int(dir.x), actor.yPos + int(dir.y))){ //the tile the player is facing is in world bounds
        //case: stone + river -> ground
       if(world[actor.xPos + int(dir.x)][actor.yPos + int(dir.y)] == TileType.RIVER){
           actor.inventory = null;
           world[actor.xPos + int(dir.x)][actor.yPos + int(dir.y)] = null;
       }
        //case: stone + ground -> stone
       else if(world[actor.xPos + int(dir.x)][actor.yPos + int(dir.y)] == null){
           actor.inventory = null;
           world[actor.xPos + int(dir.x)][actor.yPos + int(dir.y)] = TileType.STONE;
       }
       //case: stone + stone -> <invalid>
       //todo: this should NOT end the turn
       else if(world[actor.xPos + int(dir.x)][actor.yPos + int(dir.y)] == TileType.STONE){
           failedToDrop = true;
       }
    }
  }
  
  Action getKind() { return (failedToDrop) ? null : Action.drop; }
}

abstract class WalkCommand extends Command
{
  boolean changedDirection;
  boolean collided;
  
  void execute(Agent actor) {
    boolean isFacing = checkIfFacing(actor);
    collided = false;
    if (isFacing) {
      updatePosition(actor);
      collided = resolveCollision(actor);
    }
    changedDirection = !isFacing;
  }  
  
  boolean resolveCollision(Agent actor) {
    if (!inBounds(actor.xPos, actor.yPos) || world[actor.xPos][actor.yPos] != null) {
      rollBackPosition(actor);
      return true;
    }
    return false;
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
  Action getKind() { return (collided) ? null : ((changedDirection) ? Action.f_left : Action.m_left); }
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
  Action getKind() { return (collided) ? null : ((changedDirection) ? Action.f_right : Action.m_right); }
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
  Action getKind() { return (collided) ? null : ((changedDirection) ? Action.f_up : Action.m_up); }
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
  Action getKind() { return (collided) ? null : ((changedDirection) ? Action.f_down : Action.m_down); }
}
