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

        assert_equal expected, ExtractSnippet.(code, :crystal)
      end

      def test_extended_example
        code = <<~CODE
          # This is a file
          # With some comments in it

          # And a blank line ⬆️
          # It has some requires like this:
          require 'json'
          # And then eventually the code
          class TwoFer
            ...#And comments
          end
        CODE

        expected = <<~CODE
          class TwoFer
            ...#And comments
          end
        CODE

        assert_equal expected, ExtractSnippet.(code, :crystal)
      end

      def test_full_example_extended
        code = <<~CODE
          #!/usr/bin/env python3

          # The above is sometimes used to note
          # where the python interpreter is located.

          # And after this comes the import statements, if any:
          require "json"

          # And then any constants or globals,
          # followed by code.
          WORDS = ["abc", def]

          module
            def count_words(text)
              #This counts words
              WORDS[0]
            end
          end
        CODE

        expected = <<~CODE
        require "json"
        WORDS = ["abc", def]
        module
          def count_words(text)
            WORDS[0]
          end
        end
        CODE

        assert_equal expected, ExtractSnippet.(code, :crystal)
      end
    end
  end
end
