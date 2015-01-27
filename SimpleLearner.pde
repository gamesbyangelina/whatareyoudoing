List<Rule> simpleLearn (List<Event> events) {
  int minimumSupport = 2;
  int numberOfActions = Action.values().length;
  int numberOfConditions = Condition.values().length;
  int[][] occurrences = new int[numberOfActions][numberOfConditions];
  // count number of occurences of conditions  
  for (Event event : events) {
    for (Condition condition : events.preconditions) {
      occurrences[condition.ordinal()][even.action.ordinal()]++;
    }
  }
  // then, create a rule for each action
  // this is naive
  for (int i = 0; i < numberOfActions; i++) {
    // has this action been taken enough with some sort of precondition?
    boolean enoughSupport = false;
    for (int j = 0; j < numberOfConditions; j++) {
      
    }
    
  }
  
}
