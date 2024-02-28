using something.baddass

/// Saying things over
/// multiple lines of code

// I love C#!!
namespace Grasses
{
  public static class Grains
  {
    public static double Square(int i) => Math.Pow(2, i - 1);

    public static double Total() => Enumerable.Range(1, 64).Select(Square).Sum();
  }
}
