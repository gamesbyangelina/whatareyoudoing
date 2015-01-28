import java.util.*;

enum Action {
  m_up,
  m_right,
  m_down,
  m_left,
  f_up,
  f_right,
  f_down,
  f_left,
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
