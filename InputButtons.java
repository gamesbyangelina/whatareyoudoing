public enum InputButtons{
  
  A("Button 0",0),
  B("Button 1",1),
  X("Button 2",2),
  Y("Button 3",3),
  DPAD_LEFT("Hat Switch",11),
  DPAD_RIGHT("Hat Switch",11),
  DPAD_UP("Hat Switch",11),
  DPAD_DOWN("Hat Switch",11);
  
  private String id;
  private int idNumber;
  
  InputButtons(String id, int idNumber) {
    this.id = id;
  }
  
  public int getIDNumber(){
    return idNumber;
  }
  
  public String getIDString(){
    return id;
  }
  
};
