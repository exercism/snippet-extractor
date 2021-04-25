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

      def test_full_example
        # Code snippet taken from https://culttt.com/2016/10/19/writing-comments-documentation-elixir/
        code = <<~CODE
          defmodule Maths do
            @moduledoc """
            A module that implements functions for performing simple
            mathematic calculations
            """

            @doc """
            Add two numbers together
            """
            def add(left, right) do
              # Add two numbers together
              left + right
            end
          end
        CODE

        expected = <<~CODE
          defmodule Maths do
            def add(left, right) do
              left + right
            end
          end
        CODE

        assert_equal expected, ExtractSnippet.(code, :elixir)
      end
    end
  end
end
