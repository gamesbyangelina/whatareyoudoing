public List<Rule> testRuleCreation (){
 
  Random random = new Random(); 
  List<Event> allEvents = new ArrayList<Event>();
  
  int maximumPreconditions = 3;
  int totalEvents = 20;
  
  for(int i = 0; i < totalEvents; i++){

     println("** EVENT #"+i+" **");
    
     Event nextEvent = new Event();   
     int numPreconditions = 1 + random.nextInt(maximumPreconditions);
     
     for(int j = 0; j < numPreconditions; j++){
       Condition nextCondition = Condition.randomCondition();
       
       if(!nextEvent.containsPrecondition(nextCondition)){
         nextEvent.addPrecondition(nextCondition);
         println(nextCondition);
       }
     }
     
     Action nextAction = Action.randomAction();
     println(nextAction);
     nextEvent.addAction(nextAction);

    allEvents.add(nextEvent);
  }
  
  List<Rule> rules = simpleLearn(allEvents);
  
//  for(Rule currentRule: rules){
//    println(currentRule);
//  }
   
   return rules;
  
}
