require "test_helper"

module SnippetExtractor
  module Languages
    class RubyTest < Minitest::Test
      def test_full_example
        code = <<~CODE
          # This is a file
          # With some comments in it

          # And a blank line ⬆️
          # It has some requires like this:
          require 'json'

          # And then eventually the code
          defmodule TwoFer do
            ...
          end
        CODE

        expected = <<~CODE
          defmodule TwoFer do
            ...
          end
        CODE

        assert_equal expected, ExtractSnippet.(code, :ruby)
      end
    end
  end
end
