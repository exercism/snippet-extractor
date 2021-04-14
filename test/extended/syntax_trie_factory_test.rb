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
        rules = [SimpleRule.new('w', '')]
        expected = syntax_trie_maker({ ' ': { 'w': { ' ': [{}, Line.new('w')] } } })

        # When
        syntax_trie = SyntaxTrieFactory.(rules)

        # Then
        assert_equal expected, syntax_trie
      end

      def test_simple_word_rule_brings_trie_with_rule
        # Given
        rules = [SimpleRule.new('word', '')]
        expected = syntax_trie_maker({ ' ': { 'w': { 'o': { 'r': { 'd': { ' ': [{},
                                                                                Line.new('word')] } } } } } })

        # When
        syntax_trie = SyntaxTrieFactory.(rules)

        # Then
        assert_equal expected, syntax_trie
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

        # When
        syntax_trie = SyntaxTrieFactory.(rules)

        # Then
        assert_equal expected, syntax_trie
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

        # When
        syntax_trie = SyntaxTrieFactory.(rules)

        # Then
        assert_equal expected, syntax_trie
      end

      def test_two_conflicting_rules
        # Given
        rules = [SimpleRule.new('word', ''), SimpleRule.new('word', 'j')]

        # Expect
        assert_raises { SyntaxTrieFactory.(rules) }
      end

      def test_two_same_rules_doesnt_conflict
        # Given
        rules = [SimpleRule.new('word', ''), SimpleRule.new('word', '')]
        expected = syntax_trie_maker({ ' ': { 'w': { 'o': { 'r': { 'd': { ' ': [{},
                                                                                Line.new('word')] } } } } } })

        # When
        syntax_trie = SyntaxTrieFactory.(rules)

        # Then
        assert_equal expected, syntax_trie
      end

      def test_single_partial_word_rule
        # Given
        rules = [SimpleRule.new('word', 'p')]
        expected = syntax_trie_maker({ 'w': { 'o': { 'r': { 'd': [{}, Line.new('word')] } } } })

        # When
        syntax_trie = SyntaxTrieFactory.(rules)

        # Then
        assert_equal expected, syntax_trie
      end

      def test_two_partial_words_with_different_roots
        # Given
        rules = [SimpleRule.new('word', 'p'), SimpleRule.new('asd', 'p')]
        expected = syntax_trie_maker(
          {
            'w': { 'o': { 'r': { 'd': [{}, Line.new('word')] } } },
            'a': { 's': { 'd': [{}, Line.new('asd')] } }
          }
        )

        # When
        syntax_trie = SyntaxTrieFactory.(rules)

        # Then
        assert_equal expected, syntax_trie
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

        # When
        syntax_trie = SyntaxTrieFactory.(rules)

        # Then
        assert_equal expected, syntax_trie
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

        # When
        syntax_trie = SyntaxTrieFactory.(rules)

        # Then
        assert_equal expected, syntax_trie
      end

      def test_simple_multiline_rule
        # Given
        rules = [MultilineRule.new(SimpleRule.new('w', 'p'), SimpleRule.new('o', 'j'))]
        expected = syntax_trie_maker({ 'w': [
                                       {},
                                       Multi.new(Line.new('w'),
                                                 syntax_trie_maker({ ' ': { 'o': { ' ': [{}, Just.new('o')] } } }))
                                     ] })

        # When
        syntax_trie = SyntaxTrieFactory.(rules)

        # Then
        assert_equal expected, syntax_trie
      end

      def test_multiple_multi_line
        # Given
        rules = [MultilineRule.new(SimpleRule.new('w', 'p'), SimpleRule.new('o', 'j')),
                 MultilineRule.new(SimpleRule.new('word', 'p'), SimpleRule.new('other', ''))]
        expected = syntax_trie_maker({ 'w': [
                                       { 'o': { 'r': { 'd': [{},
                                                             Multi.new(Line.new('word'),
                                                                       syntax_trie_maker({ ' ': { 'o': {
                                                                                           't': { 'h': { 'e': { 'r': { ' ': [
                                                                                             {}, Line.new('other')
                                                                                           ] } } } }
                                                                                         } } }))] } } },
                                       Multi.new(Line.new('w'),
                                                 syntax_trie_maker({ ' ': { 'o': { ' ': [{}, Just.new('o')] } } }))
                                     ] })

        # When
        syntax_trie = SyntaxTrieFactory.(rules)

        # Then
        assert_equal expected, syntax_trie
      end

      def test_mix_up
        # Given
        rules = [SimpleRule.new('w', 'p'), MultilineRule.new(SimpleRule.new('word', 'p'), SimpleRule.new('other', ''))]
        expected = syntax_trie_maker({ 'w': [
                                       { 'o': { 'r': { 'd': [{},
                                                             Multi.new(Line.new('word'),
                                                                       syntax_trie_maker({ ' ': { 'o': {
                                                                                           't': { 'h': { 'e': { 'r': { ' ': [
                                                                                             {}, Line.new('other')
                                                                                           ] } } } }
                                                                                         } } }))] } } },
                                       Line.new('w')
                                     ] })

        # When
        syntax_trie = SyntaxTrieFactory.(rules)

        # Then
        assert_equal expected, syntax_trie
      end

      def test_conflict_between_simple_and_multi_rule
        # Given
        rules = [SimpleRule.new('word', ''), MultilineRule.new(SimpleRule.new('word', ''), SimpleRule.new('asdf', ''))]

        # Expect
        assert_raises { SyntaxTrieFactory.(rules) }
      end

      def test_multi_rules_with_same_start_rule_merge_end_rule_tries
        # Given
        rules = [MultilineRule.new(SimpleRule.new('w', 'p'), SimpleRule.new('o', 'j')),
                 MultilineRule.new(SimpleRule.new('w', 'p'), SimpleRule.new('od', 'j'))]
        expected = syntax_trie_maker({ 'w': [
                                       {},
                                       Multi.new(Line.new('w'),
                                                 syntax_trie_maker({ ' ': { 'o': { ' ': [{}, Just.new('o')],
                                                                                   'd': { ' ': [{},
                                                                                                Just.new('od')] } } } }))
                                     ] })

        # When
        syntax_trie = SyntaxTrieFactory.(rules)

        # Then
        assert_equal expected, syntax_trie
      end

      def test_conflict_between_multirules_same_beginning_but_with_different_rule
        # Given
        rules = [MultilineRule.new(SimpleRule.new('w', 'p'), SimpleRule.new('o', 'j')),
                 MultilineRule.new(SimpleRule.new('w', 'pj'), SimpleRule.new('od', 'j'))]

        # Expect
        assert_raises { SyntaxTrieFactory.(rules) }
      end

      def test_conflict_between_multirules_same_end_with_different_rules
        # Given
        rules = [MultilineRule.new(SimpleRule.new('w', 'p'), SimpleRule.new('o', 'j')),
                 MultilineRule.new(SimpleRule.new('w', 'p'), SimpleRule.new('o', ''))]

        # Expect
        assert_raises { SyntaxTrieFactory.(rules) }
      end

      # Object mothers
      def syntax_trie_maker(expected_hashes)
        SyntaxTrie.new(syntax_node_maker(expected_hashes, ""))
      end

      # Not happy with this object mother but using struct made the code unberably cluttered
      def syntax_node_maker(content, current_word)
        sub_hash_trie = content.is_a?(Array) ? content[0] : content
        rule = content.is_a?(Array) ? content[1] : nil
        SyntaxTrieNode.new(
          Hash[sub_hash_trie.map { |key, value| [key.to_s, syntax_node_maker(value, current_word + key.to_s)] }],
          current_word,
          rule
        )
      end
    end
  end
end
