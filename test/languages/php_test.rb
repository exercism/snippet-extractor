require "test_helper"

module SnippetExtractor
  module Languages
    class CsharpTest < Minitest::Test
      def test_full_example
        code = <<~CODE
          <?php

          namespace Lib\\Exercism\\Test;

          use Lib\\NotExercism;

          // I love C#!! But get paid with PHP

          /*
           * Comment
           */

          public class Grains
          {
              function square($n)
              {
                  if ($n < 1 || $n > 64) {
                      throw new InvalidArgumentException();
                  }
                  return pow(2, $n - 1);
              }

              function total()
              {
                  return array_reduce(range(1, 64), function ($acc, $n) {
                      return $acc += square($n);
                  });
              }
          }
        CODE

        expected = <<~CODE
          public class Grains
          {
              function square($n)
              {
                  if ($n < 1 || $n > 64) {
                      throw new InvalidArgumentException();
                  }
                  return pow(2, $n - 1);
              }

              function total()
              {
                  return array_reduce(range(1, 64), function ($acc, $n) {
                      return $acc += square($n);
                  });
              }
          }
        CODE

        assert_equal expected, ExtractSnippet.(code, :csharp)
      end
    end
  end
end
