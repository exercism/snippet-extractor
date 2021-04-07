require "test_helper"

module SnippetExtractor
  module Languages
    class PythonTest < Minitest::Test
      def test_full_example
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

        assert_equal expected, ExtractSnippet.(code, :python)
      end
    end
  end
end
