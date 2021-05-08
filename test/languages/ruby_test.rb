require "test_helper"

module SnippetExtractor
  module Languages
    class RubyTest < Minitest::Test
      def test_full_example
        code = <<~CODE
          # This is a file
          # With some comments in it

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

      def test_extended_example
        code = <<~CODE
          # This is a file
          # With some comments in it

          # And a blank line ⬆️
          # It has some requires like this:
          require 'json'

          =begin
          Multiline comments
          dkfdlksf
          =end
          # And then eventually the code
          class TwoFer
            ...#And comments
          end
          =begin
          Multiline comments
          dkfdlksf
          =end
          __END__
          More data after end of source file
          and more
          moooore but this is over 10 lines so it wont appear
        CODE

        expected = <<~CODE
          class TwoFer
            ...#And comments
          end
          =begin
          Multiline comments
          dkfdlksf
          =end
          __END__
          More data after end of source file
          and more
        CODE

        assert_equal expected, ExtractSnippet.(code, :ruby)
      end
    end
  end
end
