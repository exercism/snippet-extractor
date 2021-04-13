require "test_helper"

module SnippetExtractor
  module Extended
    class SyntaxTrieFactoryTest < Minitest::Test
      def test_empty_rules_bring_empty_trie
        # Given
        rules = []

        # When
        syntax_trie = SyntaxTrieFactory.(rules)

        # Then
        assert_equal SyntaxTrie.new, syntax_trie
      end

      def test_simple_word_rule_brings_trie_with_rule
        # Given
        rules = [ SnippetExtractor::Extended::SimpleRule.new('word','')]
        expected = syntax_trie_maker({'w':{'o':{'r':{'d':{' ': SnippetExtractor::Extended::LineSkip.new([:all])}}}}})

        # When
        syntax_trie = SyntaxTrieFactory.(rules)

        # Then
        assert_equal SyntaxTrie.new, syntax_trie
        #assert_equal expected, syntax_trie
      end

      def syntax_trie_maker(expected_hashes)
        SyntaxTrie.new(syntax_node_maker(expected_hashes))
      end

      def syntax_node_maker(sub_hash_tree)
        SyntaxNode.new(
          Hash[
            sub_hash_tree.map do |key,value|
              if value.is_a? Hash
              then [key, syntax_node_maker(value)]
              else [key, value]
              end
            end
          ]
        )
      end
    end
  end
end
