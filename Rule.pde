import java.util.*;

class Rule {

  List<Condition> preConditions = new ArrayList<Condition>();
  Action consequence;
  
  public String toString () {
    StringBuffer sb = new StringBuffer ();
    for (Condition condition : preConditions) {
      sb.append (condition.toString () + " ");
    }
    sb.append ("->");
    sb.append (consequence.toString ());
    return sb.toString ();
  }
  
}

