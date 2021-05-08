require "test_helper"

module SnippetExtractor
  module Languages
    class PhpTest < Minitest::Test
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

        CODE

        assert_equal expected, ExtractSnippet.(code, :php)
      end

      def test_extended_example
        code = <<~CODE
          <?php

          namespace Lib\\Exercism\\Test;

          use Lib\\NotExercism;

          // I love C#!! But get paid with PHP

          /*
           * Comment
           */

          public class Grains
          {//comments
            //Comments
            /* More#{' '}
              comments*/
              function square($n/*Even more comments*/)
              {
                  if ($n < 1 || $n > 64) {
                      throw new InvalidArgumentException();//Too large
                  }
                  return pow(2, $n - 1);// Just right
              }

              function total(/*I can be here supposedly*/)
              {
                  return array_reduce(range(1, 64), function ($acc, $n) {
                      return $acc += square($n);
                  });
              }//This is the end of the program
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

        CODE

        assert_equal expected, ExtractSnippet.(code, :php)
      end
    end
  end
end
