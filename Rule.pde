import java.util.*;

class Rule {

  List<Condition> preconditions = new ArrayList<Condition>();
  Action consequence;
  
  public String toString () {
    StringBuffer sb = new StringBuffer ();
    for (Condition condition : preconditions) {
      sb.append (condition.toString () + " ");
    }
    sb.append ("->");
    sb.append (consequence.toString ());
    return sb.toString ();
  }
  
}

