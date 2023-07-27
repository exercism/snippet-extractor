require "test_helper"

module SnippetExtractor
  module Languages
    class PyretTest < Minitest::Test
      def test_full_example
        code = <<~CODE
        provide: foo end

        include lists
        import string-dict as SD

        # Standalone single line comment
        #|
            This comment can extend
            over multiple lines
        |#
        fun foo(text):
          true # Hi I start after some code
        end
        CODE

        expected = <<~CODE
        fun foo(text):
          true 
        end
        CODE

        assert_equal expected, ExtractSnippet.(code, :pyret)
      end
    end
  end
end
