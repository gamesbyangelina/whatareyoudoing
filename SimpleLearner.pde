List<Rule> simpleLearn (List<Event> events) {
  List<Rule> rules = new LinkedList<Rule>();
  int minimumSupport = 2;
  int numberOfActions = Action.values().length;
  int numberOfConditions = Condition.values().length;
  int[][] occurrences = new int[numberOfActions][numberOfConditions];
  // count number of occurences of conditions  
  for (Event event : events) {
    for (Condition condition : event.preconditions) {
      occurrences[event.action.ordinal()][condition.ordinal()]++;
    }
  }
  // then, create a rule for each action
  // this is naive
  for (int i = 0; i < numberOfActions; i++) {
    // has this action been taken enough with some sort of precondition?
    Rule rule = new Rule ();
    rule.consequence = Action.values()[i];
//    println ("Adding consequence " + rule.consequence);
    for (int j = 0; j < numberOfConditions; j++) {
      if (occurrences[i][j] >= minimumSupport) {
        rule.preconditions.add (Condition.values()[j]);
//        println ("Adding precondition " + Condition.values()[j]);
        //enoughSupport = true;
      }
    }
    if (rule.preconditions.size () > 0) {
      println ("Adding rule!");
        rules.add (rule);
    }
//    else println ("Discarding rule");
  }
  return rules;
}

// match a set of rules to a set of conditions to pick next action
List<Action> gitActionSet(List<Rule> rules, List<Condition> state) {
  ArrayList<Action> actions = new ArrayList<Action>();
  boolean willAdd = true;
  
  for (Rule rule : rules) {
    println("testing rule: " + rule);
    willAdd = true;
    for (Condition precondition : rule.preconditions) {
      // don't add actions if any precondition fails
      if (!state.contains(precondition)) { 
        willAdd = false;
      }
    }
    
    if (willAdd) {
      println("adding action: " + rule.consequence);
      actions.add(rule.consequence); 
    }
  }
  
  return actions;
}
