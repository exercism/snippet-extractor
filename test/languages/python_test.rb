require "test_helper"

module SnippetExtractor
  module Languages
    class PythonTest < Minitest::Test
      def test_full_example
        code = <<~CODE
          #!/usr/bin/env python3
          # The above is sometimes used to note
          # where the python interpreter is located

          # Files may start with a module *docstring* using
          # single or double quotes:
          '''
          Created on Tue Apr  6 09:27:51 2021

          @author: aliceP
          '''

          # And after this comes the import statements, if any:
          import re
          from collections import Counter

          # And then any constants or globals
          WORDS = re.compile("[a-z0-9]+(['][a-z]+)?")

          #finally, some code:
          def count_words(text):
              return Counter(word.group(0) for word in WORDS.finderiter(text.lower()))
        CODE

        expected = <<~CODE
          '''
          Created on Tue Apr  6 09:27:51 2021

          @author: aliceP
          '''

          import re
          from collections import Counter

          WORDS = re.compile("[a-z0-9]+(['][a-z]+)?")

          def count_words(text):
              return Counter(word.group(0) for word in WORDS.finditer(text.lower()))
        CODE

        assert_equal expected, ExtractSnippet.(code, :python)
      end
    end
  end
end
