require "test_helper"

module SnippetExtractor
  module Languages
    class ElixirTest < Minitest::Test
      def test_full_example
        code = <<~CODE
          # This is a file
          # With some comments in it

          # And a blank line ⬆️
          # It has some requires like this:

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

        assert_equal expected, ExtractSnippet.(code, :elixir)
      end
    end
  end
end
