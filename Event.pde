import java.util.*;

class Event {

  List<Condition> preconditions;
  Action action;
  
  public Event(){
    preconditions = new ArrayList<Condition>();
  }
  
  public void addPrecondition(Condition precondition){
    preconditions.add(precondition); 
  }
  
  public void addAction(Action action){
    this.action = action;
  }
  
  public boolean containsPrecondition(Condition precondition){
    return preconditions.contains(precondition);
  }
    
}

