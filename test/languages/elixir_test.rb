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

      def test_documentation_heredoc_double_quote
        # Code snippet taken from https://culttt.com/2016/10/19/writing-comments-documentation-elixir/
        code = <<~CODE
          defmodule Maths do
            @moduledoc """
            A module that implements functions for performing simple
            mathematic calculations

            ```elixir
              @doc "Add two numbers together"
              def add(left, right) do
                # Add two numbers together
                left + right
              end
            end
            ```
            """

            @typedoc """
                iex> 1 + * 1
                1
            """

            @type t :: any()

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

            @type t :: any()

            def add(left, right) do
              left + right
            end
          end
        CODE

        assert_equal expected, ExtractSnippet.(code, :elixir)
      end

      def test_documentation_heredoc_single_quote
        # Code snippet taken from https://culttt.com/2016/10/19/writing-comments-documentation-elixir/
        code = <<~CODE
          defmodule Maths do
            @moduledoc '''
            A module that implements functions for performing simple
            mathematic calculations
            '''

            @typedoc '''
                iex> 1 + * 1
                1
            '''

            @type t :: any()

            @doc '''
            Add two numbers together
            '''
            def add(left, right) do
              # Add two numbers together
              left + right
            end
          end
        CODE

        expected = <<~CODE
          defmodule Maths do

            @type t :: any()

            def add(left, right) do
              left + right
            end
          end
        CODE

        assert_equal expected, ExtractSnippet.(code, :elixir)
      end

      def test_documentation_sigil_downcase_heredoc_double_quote
        # Code snippet taken from https://culttt.com/2016/10/19/writing-comments-documentation-elixir/
        code = <<~CODE
          defmodule Maths do
            @moduledoc ~s'''
            A module that implements functions for performing simple
            mathematic calculations
            '''

            @typedoc ~s'''
                iex> 1 + * 1
                1
            '''

            @type t :: any()

            @doc ~s'''
            Add two numbers together
            '''
            def add(left, right) do
              # Add two numbers together
              left + right
            end
          end
        CODE

        expected = <<~CODE
          defmodule Maths do

            @type t :: any()

            def add(left, right) do
              left + right
            end
          end
        CODE

        assert_equal expected, ExtractSnippet.(code, :elixir)
      end

      def test_documentation_sigil_downcase_heredoc_single_quote
        # Code snippet taken from https://culttt.com/2016/10/19/writing-comments-documentation-elixir/
        code = <<~CODE
          defmodule Maths do
            @moduledoc ~s'''
            A module that implements functions for performing simple
            mathematic calculations
            '''

            @typedoc ~s'''
                iex> 1 + * 1
                1
            '''

            @type t :: any()

            @doc ~s'''
            Add two numbers together
            '''
            def add(left, right) do
              # Add two numbers together
              left + right
            end
          end
        CODE

        expected = <<~CODE
          defmodule Maths do

            @type t :: any()

            def add(left, right) do
              left + right
            end
          end
        CODE

        assert_equal expected, ExtractSnippet.(code, :elixir)
      end

      def test_documentation_sigil_upcase_heredoc_double_quote
        # Code snippet taken from https://culttt.com/2016/10/19/writing-comments-documentation-elixir/
        code = <<~CODE
          defmodule Maths do
            @moduledoc ~S'''
            A module that implements functions for performing simple
            mathematic calculations
            '''

            @typedoc ~S'''
                iex> 1 + * 1
                1
            '''

            @type t :: any()

            @doc ~S'''
            Add two numbers together
            '''
            def add(left, right) do
              # Add two numbers together
              left + right
            end
          end
        CODE

        expected = <<~CODE
          defmodule Maths do

            @type t :: any()

            def add(left, right) do
              left + right
            end
          end
        CODE

        assert_equal expected, ExtractSnippet.(code, :elixir)
      end

      def test_documentation_sigil_upcase_heredoc_single_quote
        # Code snippet taken from https://culttt.com/2016/10/19/writing-comments-documentation-elixir/
        code = <<~CODE
          defmodule Maths do
            @moduledoc ~S'''
            A module that implements functions for performing simple
            mathematic calculations
            '''

            @typedoc ~S'''
                iex> 1 + * 1
                1
            '''

            @type t :: any()

            @doc ~S'''
            Add two numbers together
            '''
            def add(left, right) do
              # Add two numbers together
              left + right
            end
          end
        CODE

        expected = <<~CODE
          defmodule Maths do

            @type t :: any()

            def add(left, right) do
              left + right
            end
          end
        CODE

        assert_equal expected, ExtractSnippet.(code, :elixir)
      end

      def test_documentation_single_line_string
        # Code snippet taken from https://culttt.com/2016/10/19/writing-comments-documentation-elixir/
        code = <<~CODE
          defmodule Maths do
            @moduledoc "A module that implements functions for performing simple mathematic calculations"

            @typedoc "anything..."
            @type t :: any()

            @doc "Add two numbers together"
            def add(left, right) do
              # Add two numbers together
              left + right
            end
          end
        CODE

        expected = <<~CODE
          defmodule Maths do

            @type t :: any()

            def add(left, right) do
              left + right
            end
          end
        CODE

        assert_equal expected, ExtractSnippet.(code, :elixir)
      end

      def test_documentation_single_line_string_sigil_downcase_various_delimiters
        # Code snippet taken from https://culttt.com/2016/10/19/writing-comments-documentation-elixir/
        code = <<~CODE
          defmodule Maths do
            @moduledoc ~s[A module that implements functions for performing simple mathematic calculations]

            @typedoc ~s(anything...)
            @type t :: any()

            @doc ~s<Add two numbers together>
            def add(left, right) do
              # Add two numbers together
              left + right
            end
          end
        CODE

        expected = <<~CODE
          defmodule Maths do

            @type t :: any()

            def add(left, right) do
              left + right
            end
          end
        CODE

        assert_equal expected, ExtractSnippet.(code, :elixir)
      end

      def test_documentation_single_line_string_sigil_upcase_various_delimiters
        # Code snippet taken from https://culttt.com/2016/10/19/writing-comments-documentation-elixir/
        code = <<~CODE
          defmodule Maths do
            @moduledoc ~S/A module that implements functions for performing simple mathematic calculations/

            @typedoc ~S|anything...|
            @type t :: any()

            @doc ~S{Add two numbers together}
            def add(left, right) do
              # Add two numbers together
              left + right
            end
          end
        CODE

        expected = <<~CODE
          defmodule Maths do

            @type t :: any()

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
