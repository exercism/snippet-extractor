require "test_helper"

module SnippetExtractor
  module Extended
    SyntaxTrieFactory
    CodeParser

    class CodeParserTest < Minitest::Test
      def test_empty_syntax_trie_return_rules
        # Given
        syntax_trie = SyntaxTrie.new(Node.new({}, "", nil))
        code =
          <<~CODE
            line1
            line2
          CODE
        expected = code

        # Expect
        assert_equal expected, CodeParser.(code, syntax_trie)
      end
    end
  end
end
