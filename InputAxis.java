public enum InputAxis{
  
  LEFT_STICK_X("X Axis"),
  LEFT_STICK_Y("Y Axis"),
  RIGHT_STICK_X("X Rotation"),
  RIGHT_STICK_Y("Y Rotation");
  
  private String id;
  
  InputAxis(String id) {
    this.id = id;
  }
  
  public String getIDString(){
    return id;
  }
  
};
