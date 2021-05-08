require "test_helper"

module SnippetExtractor
  module Languages
    class CsharpTest < Minitest::Test
      def test_full_example
        code = <<~CODE
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
        CODE

        expected = <<~CODE
          namespace Grasses
          {
            public static class Grains
            {
              public static double Square(int i) => Math.Pow(2, i - 1);

              public static double Total() => Enumerable.Range(1, 64).Select(Square).Sum();
            }
          }
        CODE

        assert_equal expected, ExtractSnippet.(code, :csharp)
      end

      def test_extended_example
        code = <<~CODE
          using something.baddass

          /// Saying things over
          /// multiple lines of code

          // I love C#!!
          /* I really love
          comments
          :D*/namespace Grasses//Now with more comments
          {/*yeeeeeeeeeeeeeee
            eeee
            eeeey*/
            public static class Grains
            {
              public static double Square(int i) => Math.Pow(2, i - 1);

              public static double Total() => Enumerable.Range(1, 64).Select(Square).Sum();
            }
          }
        CODE

        expected = <<~CODE
          namespace Grasses
          {
            public static class Grains
            {
              public static double Square(int i) => Math.Pow(2, i - 1);

              public static double Total() => Enumerable.Range(1, 64).Select(Square).Sum();
            }
          }
        CODE

        assert_equal expected, ExtractSnippet.(code, :csharp)
      end
    end
  end
end
