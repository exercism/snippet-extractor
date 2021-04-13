require "test_helper"

module SnippetExtractor
  module Extended
    class SyntaxTrieTest < Minitest::Test
      def test_empty_rules_bring_empty_trie
        # Given
        rules = []

        # When
        syntax_trie = SyntaxTrieFactory.(rules)

        # Then
        assert_equal SyntaxTrie.new, syntax_trie
      end
    end
  end
end
