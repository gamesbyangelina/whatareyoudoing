interface Command
{
  void execute(Agent actor);
}

class WalkLeftCommand implements Command
{
  void execute(Agent actor) {
    println(actor.xPos);
    actor.xPos = actor.xPos - 1;
  }
}

class WalkRightCommand implements Command
{
  void execute(Agent actor) {
    actor.xPos = actor.xPos + 1;
  }
}

class WalkUpCommand implements Command
{
  void execute(Agent actor) {
    actor.yPos = actor.yPos - 1;
  }
}

class WalkDownCommand implements Command
{
  void execute(Agent actor) {
    actor.yPos = actor.yPos + 1;
  }
}
