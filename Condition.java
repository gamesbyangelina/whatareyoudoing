import java.util.*;

enum Condition {  
  stone_front,
  stone_right,
  stone_behind,
  stone_left,
  river_front,
  river_right,
  river_behind,
  river_left;
  
  private static final List<Condition> VALUES = Collections.unmodifiableList(Arrays.asList(values()));
  private static final int SIZE = VALUES.size();
  private static final Random RANDOM = new Random();
  
  public static Condition randomCondition()  {
    return VALUES.get(RANDOM.nextInt(SIZE));
  }
}


