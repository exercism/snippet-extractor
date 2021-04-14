require "test_helper"

module SnippetExtractor
  module Extended
    SyntaxTrieFactory
    RuleParser

    class SyntaxTrieFactoryTest < Minitest::Test
      def test_empty_rules_bring_empty_trie
        # Given
        rules = []

        # When
        syntax_trie = SyntaxTrieFactory.(rules)

        # Then
        assert_equal SyntaxTrie.new, syntax_trie
      end

      def test_even_simpler_word_rule_brings_trie_with_rule
        # Given
        rules = [SimpleRule.new('w','')]
        expected = syntax_trie_maker({' ':{'w':{' ': [{}, SimpleRule.new('w','')]}}})

        # When
        syntax_trie = SyntaxTrieFactory.(rules)

        # Then
        assert_equal expected, syntax_trie
      end

      def test_simple_word_rule_brings_trie_with_rule
        # Given
        rules = [SimpleRule.new('word','')]
        expected = syntax_trie_maker({' ':{'w':{'o':{'r':{'d':{' ': [{}, SimpleRule.new('word','')]}}}}}})

        # When
        syntax_trie = SyntaxTrieFactory.(rules)

        # Then
        assert_equal expected, syntax_trie
      end

      def syntax_trie_maker(expected_hashes)
        SyntaxTrie.new(syntax_node_maker(expected_hashes, ""))
      end

      # Not happy with this object mother but using struct made the code unberably cluttered
      def syntax_node_maker(content, current_word)
        sub_hash_trie = content.is_a?(Array) ? content[0] : content
        rule = content.is_a?(Array) ? content[1] : nil
        SyntaxTrieNode.new(
          Hash[sub_hash_trie.map {|key,value| [key.to_s, syntax_node_maker(value, current_word+key.to_s)]}],
          current_word,
          rule
        )
      end
    end
  end
end
