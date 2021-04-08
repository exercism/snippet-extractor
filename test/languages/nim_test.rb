require "test_helper"

module SnippetExtractor
  module Languages
    class NimTest < Minitest::Test
      def test_full_example
        code = <<~CODE
          # This is a file
          # With some comments in it

          # And a blank line ⬆️
          # It has some module-related code like this:
          import json
          export json
          from json import nil
          # And then eventually the code
          proc twoFer =
            ##[ doc comment ]##
            ## more doc comment
            discard
          # A non doc comment
        CODE

        expected = <<~CODE
          proc twoFer =
            ##[ doc comment ]##
            ## more doc comment
            discard
          # A non doc comment
        CODE

        assert_equal expected, ExtractSnippet.(code, :nim)
      end
    end
  end
end
