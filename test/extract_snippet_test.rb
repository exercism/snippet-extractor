require "test_helper"

module SnippetExtractor
  module Languages
    class RubyTest < Minitest::Test
      def test_strips_correctly
        code = <<~CODE
          # This is a file
          # With some comments in it

          # And a blank line ⬆️
          # It has some requires like this:
          require 'json'

          # And then eventually the code
          class TwoFer
            ...
          end
        CODE

        expected = <<~CODE
          class TwoFer
            ...
          end
        CODE

        assert_equal expected, ExtractSnippet.(code, :ruby)
      end

      def test_extracts_first_10
        code = <<~CODE
          # Here is some code
          class TwoFer
            Line 2
            Line 3
            Line 4
            Line 5
            Line 6
            Line 7
            Line 8
            Line 9
            Line 10
            Line 11
            Line 12
            Line 13
          end
        CODE

        expected = <<~CODE
          class TwoFer
            Line 2
            Line 3
            Line 4
            Line 5
            Line 6
            Line 7
            Line 8
            Line 9
            Line 10
        CODE

        assert_equal expected, ExtractSnippet.(code, :ruby)
      end

      def test_strips_correctly_with_extended_syntax
        code = <<~CODE
          # This is a file
          # With some comments in it

          # And a blank line ⬆️
          # It has some requires like this:
          require 'json'

          # And then eventually the code
          class TwoFer#Comment will be ignored
            ...#This too
          # :D
          end
        CODE

        expected = <<~CODE
          class TwoFer
            ...
          end
        CODE

        assert_equal expected, ExtractSnippet.(code, :ruby)
      end
    end
  end
end
