require "test_helper"

module SnippetExtractor
  module Languages
    class RubyTest < Minitest::Test
      def test_returns_first_10_loc_on_missing_language
        code = <<~CODE
          Loc 1
          Loc 2
          Loc 3
          Loc 4
          Loc 5
          Loc 6
          Loc 6
          Loc 8
          Loc 9
          Loc 10
          Loc 11
          Loc 12
        CODE

        expected = <<~CODE
          Loc 1
          Loc 2
          Loc 3
          Loc 4
          Loc 5
          Loc 6
          Loc 6
          Loc 8
          Loc 9
          Loc 10
        CODE

        assert_equal expected, ExtractSnippet.(code, :foobar)
      end

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
    end
  end
end
