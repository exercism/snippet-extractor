require "test_helper"

module SnippetExtractor
  module Extended
    # Not ideal but adding the class identifier will worse legibility and break rubocop length rule
    SyntaxTrieFactory
    RuleParser

    class SyntaxTrieFactoryMultilineRuleTest < Minitest::Test
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

      def test_mix_up
        # Given
        rules = [SimpleRule.new('w', 'p'), MultilineRule.new(SimpleRule.new('word', 'p'), SimpleRule.new('oth', ''))]
        expected = syntax_trie_maker({ 'w': [
                                       { 'o': { 'r': { 'd': [{},
                                                             Multi.new(Line.new('word'),
                                                                       syntax_trie_maker({ ' ': { 'o': {
                                                                                           't': { 'h': { ' ': [
                                                                                             {}, Line.new('oth')
                                                                                           ] } }
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
        expect = syntax_trie_maker({ 'w': [
                                     {},
                                     Multi.new(Line.new('w'),
                                               syntax_trie_maker({ ' ': { 'o': { ' ': [{}, Just.new('o')],
                                                                                 'd': { ' ': [{},
                                                                                              Just.new('od')] } } } }))
                                   ] })

        # When
        syntax_trie = SyntaxTrieFactory.(rules)

        # Then
        assert_equal expect, syntax_trie
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

      # def test_single_repeated_letter_in_whole_word
      #   # Given
      #   rules = [SimpleRule.new('w+', '')]
      #   expected = syntax_trie_maker({ ' ': { 'w':
      #                                           RepeatedLetterNode.new("w", { ' ': [{}, Line.new('w+')] }) } })
      #
      #   # When
      #   syntax_trie = SyntaxTrieFactory.(rules)
      #
      #   # Then
      #   assert_equal expected, syntax_trie
      # end

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
