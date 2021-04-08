require "test_helper"

module SnippetExtractor
  module Languages
    class CsharpTest < Minitest::Test
      def test_full_example
        code = <<~CODE
          open System.IO

          /// This is a
          /// multiline comment

          // I love F#!!
          module Grasses

          let square x = x * x
        CODE

        expected = <<~CODE
          module Grasses

          let square x = x * x
        CODE

        assert_equal expected, ExtractSnippet.(code, :fsharp)
      end
    end
  end
end
