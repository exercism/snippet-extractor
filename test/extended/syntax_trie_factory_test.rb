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

      def test_two_words_with_different_roots
        # Given
        rules = [SimpleRule.new('word',''), SimpleRule.new('asd','')]
        expected = syntax_trie_maker(
          {
            ' ':{
               'w':{'o':{'r':{'d':{' ': [{}, SimpleRule.new('word','')]}}}},
               'a':{'s':{'d':{' ':[{},SimpleRule.new('asd','')]}}}
             }})

        # When
        syntax_trie = SyntaxTrieFactory.(rules)

        # Then
        assert_equal expected, syntax_trie
      end

      def test_two_words_with_same_root
        # Given
        rules = [SimpleRule.new('word',''), SimpleRule.new('w','j')]
        expected = syntax_trie_maker(
          {
            ' ':{
              'w':{
                'o':{'r':{'d':{' ': [{}, SimpleRule.new('word','')]}}},
                ' ':[{},  SimpleRule.new('w','j')]
              },
            }})

        # When
        syntax_trie = SyntaxTrieFactory.(rules)

        # Then
        assert_equal expected, syntax_trie
      end

      def test_two_conflicting_rules
        # Given
        rules = [SimpleRule.new('word',''), SimpleRule.new('word','j')]

        # Expect
        assert_raises { SyntaxTrieFactory.(rules) }
      end

      def test_single_partial_word_rule
        # Given
        rules = [SimpleRule.new('word','p')]
        expected = syntax_trie_maker({'w':{'o':{'r':{'d': [{}, SimpleRule.new('word','p')]}}}})

        # When
        syntax_trie = SyntaxTrieFactory.(rules)

        # Then
        assert_equal expected, syntax_trie
      end

      def test_two_partial_words_with_different_roots
        # Given
        rules = [SimpleRule.new('word','p'), SimpleRule.new('asd','p')]
        expected = syntax_trie_maker(
          {
            'w':{'o':{'r':{'d':[{}, SimpleRule.new('word','p')]}}},
            'a':{'s':{'d':[{},SimpleRule.new('asd','p')]}}
          })

        # When
        syntax_trie = SyntaxTrieFactory.(rules)

        # Then
        assert_equal expected, syntax_trie
      end

      def test_two_partial_words_with_same_root
        # Given
        rules = [SimpleRule.new('word','p'), SimpleRule.new('w','jp')]
        expected = syntax_trie_maker(
          {
            'w':[
              {'o':{'r':{'d':[{}, SimpleRule.new('word','p')]}}},
              SimpleRule.new('w','jp')]
          })

        # When
        syntax_trie = SyntaxTrieFactory.(rules)

        # Then
        assert_equal expected, syntax_trie
      end

      def mixing_partial_non_partial_word_with_mixed_roots
        # Given
        rules = [SimpleRule.new('word',''), SimpleRule.new('word','p'), SimpleRule.new('w',''), SimpleRule.new('w','p')]
        expected = syntax_trie_maker(
          {
            ' ':{
              'w':{
                'o':{'r':{'d':{' ': [{}, SimpleRule.new('word','')]}}},
                ' ':[{},  SimpleRule.new('w','')]
              },
            },
            'w':[
              {'o':{'r':{'d':[{}, SimpleRule.new('word','p')]}}},
              SimpleRule.new('w','p')]
          })

        # When
        syntax_trie = SyntaxTrieFactory.(rules)

        # Then
        assert_equal expected, syntax_trie
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
          Hash[sub_hash_trie.map {|key,value| [key.to_s, syntax_node_maker(value, current_word+key.to_s)]}],
          current_word,
          rule
        )
      end
    end
  end
end
