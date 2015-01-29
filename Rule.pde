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
  
  public void draw(float x, float y){
     TileType front = null; boolean hasFront = false;
     TileType back = null; boolean hasBack = false;
     TileType left = null; boolean hasLeft = false;
     TileType right = null; boolean hasRight = false;
    
     for(Condition condition : preconditions){
        String tile = condition.toString().split("_")[0];
        String dir = condition.toString().split("_")[1];
        if(dir.equalsIgnoreCase("front")){ front = toTileType(tile); hasFront = true;}
        if(dir.equalsIgnoreCase("behind")){ back = toTileType(tile);  hasBack = true;}
        if(dir.equalsIgnoreCase("left")){ left = toTileType(tile);  hasLeft = true;}
        if(dir.equalsIgnoreCase("right")){ right = toTileType(tile);  hasRight = true;}
     }
     
     //Render left hand side of rules
     if(hasFront) drawTile(x+tileSize, y, front);
     if(hasBack) drawTile(x+tileSize, y+2*tileSize, back);
     if(hasLeft) drawTile(x, y+tileSize, left);
     if(hasRight) drawTile(x+2*tileSize, y+tileSize, right);
     renderChild(x+tileSize, y+tileSize);
     
     //Render an arrow
     text("=", x + tileSize*4, y+tileSize*1.75);
     
     //Render right hand side
     text(prettyPrint(consequence.toString()), x+tileSize*6,y+tileSize*1.75);
  }
  
  String prettyPrint(String cons){
     if(cons.equalsIgnoreCase("move"))
         return "Move Forwards";
     else if(cons.equalsIgnoreCase("drop"))
         return "Drop Stone";
     else if(cons.equalsIgnoreCase("eat"))
         return "Eat";
     else if(cons.equalsIgnoreCase("t_right")){
        return "Turn Right"; 
     }
     else if(cons.equalsIgnoreCase("t_left")){
        return "Turn Left"; 
     }
     else if(cons.equalsIgnoreCase("t_back")){
        return "Turn Around"; 
     }
     else if(cons.equalsIgnoreCase("pickup")){
        return "Pick Up Stone"; 
     }
     return "ERROR - No Action representation";
  }
  
  public TileType toTileType(String t){
     if(t == null || t.equalsIgnoreCase("null")){
        return null;
     } 
     if(t.equalsIgnoreCase("river")){
       return TileType.RIVER;
     }
     if(t.equalsIgnoreCase("stone")){
        return TileType.STONE; 
     }
     return null;
  }
  
  public void drawTile(float x, float y, TileType t){
      if (t == TileType.RIVER) {
        fill(riverColor);
      } else if (t == TileType.STONE) {
        fill(stoneColor);
      } else {
        fill(groundColor);
      }
      rect(x, y, tileSize, tileSize); 
  }
  
  public void renderChild(float x, float y)
  {
    noStroke();
    fill(color(141, 115, 232));
    rect(x, y, tileSize, tileSize);
    fill(255);
    ellipse(x + tileSize/2, y + borderSize*4, 2, 2);
  }
  
}

