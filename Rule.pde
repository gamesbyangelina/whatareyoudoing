import java.util.*;

class Rule {

  List<Condition> preConditions = new ArrayList<Condition>();
  Action consequence;
  
  public void toString () {
    StringBuffer sb = new StringBuffer ();
    for (Condition condition : preConditions) {
      sb.add (condition.toString () + " ");
    }
    sb.add ("->");
    sb.add (consequence.toString);
  }
  
}

