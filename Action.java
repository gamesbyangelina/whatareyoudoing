import java.util.*;

enum Action {
  move,
  t_left,
  t_right,
  t_back,
  pickup,
  drop,
  eat;
  
  
  
  private static final List<Action> VALUES = Collections.unmodifiableList(Arrays.asList(values()));
  private static final int SIZE = VALUES.size();
  private static final Random RANDOM = new Random();
  
  public static Action randomAction()  {
    return VALUES.get(RANDOM.nextInt(SIZE));
  }
}
