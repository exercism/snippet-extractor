require "test_helper"

module SnippetExtractor
  module Languages
    class GleamTest < Minitest::Test
      def test_full_example
        code = <<~CODE
          //// This is a file
          //// With some comments in it

          // And a blank line ⬆️
          // It has some imports like this:
          import gleam/erlang
          import gleam/erlang/process.{Subject}

          /// And then eventually the code
          pub fn two_fer(name: String) -> String {
            todo
          }
        CODE

        expected = <<~CODE
          pub fn two_fer(name: String) -> String {
            todo
          }
        CODE

        assert_equal expected, ExtractSnippet.(code, :gleam)
      end

      def test_extended_example
        code = <<~CODE
          //// This is a file
          //// With some comments in it

          // And a blank line ⬆️
          // It has some imports like this:
          import gleam/erlang
          import gleam/erlang/process.{Subject}

          /// And then eventually the code
          pub fn two_fer(name: String) -> String {
            todo// with comments
          }

          // Here is a comment
          /// And a documentation comment
          pub type TwoFer {
            TwoFer(name: String)
          }

          const a = 1
          const b = 1
          const c = 1 // More, but this is over 10 lines so it wont appear
        CODE

        expected = <<~CODE
          pub fn two_fer(name: String) -> String {
            todo
          }

          pub type TwoFer {
            TwoFer(name: String)
          }

          const a = 1
          const b = 1
        CODE

        assert_equal expected, ExtractSnippet.(code, :gleam)
      end
    end
  end
end
