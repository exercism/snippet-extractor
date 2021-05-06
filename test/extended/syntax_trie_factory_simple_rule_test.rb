require "test_helper"

module SnippetExtractor
  module Extended
    class SyntaxTrieFactorySimpleRuleTest < Minitest::Test
      def test_empty_rules_bring_empty_trie
        # Given
        rules = []
        expected = SyntaxTrie.new(Node.new({}, "", nil))

        # Then
        assert_equal expected, SyntaxTrieFactory.(rules)
      end

      def test_even_simpler_word_rule_brings_trie_with_rule
        # Given
        rules = [SimpleRule.new('w', '')]
        expected = syntax_trie_maker({ ' ': { 'w': { ' ': [{}, Line.new('w')] } } })

        # Expect
        assert_equal expected, SyntaxTrieFactory.(rules)
      end

      def test_simple_word_rule_brings_trie_with_rule
        # Given
        rules = [SimpleRule.new('word', '')]
        expected = syntax_trie_maker({ ' ': { 'w': { 'o': { 'r': { 'd': { ' ': [{},
                                                                                Line.new('word')] } } } } } })
        # Expect
        assert_equal expected, SyntaxTrieFactory.(rules)
      end

      def test_two_words_with_different_roots
        # Given
        rules = [SimpleRule.new('word', ''), SimpleRule.new('asd', '')]
        expected = syntax_trie_maker(
          {
            ' ': {
              'w': { 'o': { 'r': { 'd': { ' ': [{}, Line.new('word')] } } } },
              'a': { 's': { 'd': { ' ': [{}, Line.new('asd')] } } }
            }
          }
        )

        # Expect
        assert_equal expected, SyntaxTrieFactory.(rules)
      end

      def test_two_words_with_same_root
        # Given
        rules = [SimpleRule.new('word', ''), SimpleRule.new('w', 'j')]
        expected = syntax_trie_maker(
          {
            ' ': {
              'w': {
                'o': { 'r': { 'd': { ' ': [{}, Line.new('word')] } } },
                ' ': [{}, Just.new('w')]
              }
            }
          }
        )

        # Expect
        assert_equal expected, SyntaxTrieFactory.(rules)
      end

      def test_two_conflicting_rules
        # Given
        rules = [SimpleRule.new('word', ''), SimpleRule.new('word', 'j')]

        # Expect
        assert_raises { SyntaxTrieFactory.(rules) }
      end

      def test_two_same_rules_doesnt_conflict
        # Given
        rules = [SimpleRule.new('w', ''), SimpleRule.new('w', '')]
        expected = syntax_trie_maker({ ' ': { 'w': { ' ': [{}, Line.new("w")] } } })

        # Expect
        assert_equal expected, SyntaxTrieFactory.(rules)
      end

      def test_single_partial_word_rule
        # Given
        rules = [SimpleRule.new('word', 'p')]
        expected = syntax_trie_maker({ 'w': { 'o': { 'r': { 'd': [{}, Line.new('word')] } } } })

        # Expect
        assert_equal expected, SyntaxTrieFactory.(rules)
      end

      def test_two_partial_words_with_same_root
        # Given
        rules = [SimpleRule.new('word', 'p'), SimpleRule.new('w', 'jp')]
        expected = syntax_trie_maker(
          {
            'w': [
              { 'o': { 'r': { 'd': [{}, Line.new('word')] } } },
              Just.new('w')
            ]
          }
        )

        # Expect
        assert_equal expected, SyntaxTrieFactory.(rules)
      end

      def mixing_partial_non_partial_word_with_mixed_roots
        # Given
        rules = [SimpleRule.new('word', ''), SimpleRule.new('word', 'p'), SimpleRule.new('w', ''),
                 SimpleRule.new('w', 'p')]
        expected = syntax_trie_maker(
          {
            ' ': {
              'w': {
                'o': { 'r': { 'd': { ' ': [{}, Line.new('word')] } } },
                ' ': [{}, Line.new('w')]
              }
            },
            'w': [
              { 'o': { 'r': { 'd': [{}, Line.new('word')] } } },
              Line.new('w')
            ]
          }
        )

        # Expect
        assert_equal expected, SyntaxTrieFactory.(rules)
      end

      # Object mothers
      def syntax_trie_maker(expected_hashes)
        SyntaxTrie.new(syntax_node_maker(expected_hashes, ""))
      end

      # Not happy with this object mother but using struct made the code unberably cluttered
      def syntax_node_maker(content, current_word)
        sub_hash_trie = content.is_a?(Array) ? content[0] : content
        rule = content.is_a?(Array) ? content[1] : nil
        Node.new(
          Hash[sub_hash_trie.map { |key, value| [key.to_s, syntax_node_maker(value, current_word + key.to_s)] }],
          current_word,
          rule
        )
      end
    end
  end
end
