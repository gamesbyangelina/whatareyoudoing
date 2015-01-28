import java.util.*;

class Event {

  List<Condition> preconditions;
  Action action;

  public Event() {
    preconditions = new ArrayList<Condition>();
  }

  public void addPrecondition(Condition precondition) {
    preconditions.add(precondition);
  }

  public void addPreconditions(ArrayList<Condition> all_preconditions) {
    preconditions.addAll(all_preconditions);
  }

  public void addAction(Action action) {
    this.action = action;
  }

  public boolean containsPrecondition(Condition precondition) {
    return preconditions.contains(precondition);
  }

  public String toString()
  {
    String str = "--------\n";
    str = str + "action: " + action + "\n";
    str = str + "conditions: " + preconditions + "\n";
    str = str + "---------" + "\n\n";
    return str;
  }
}

