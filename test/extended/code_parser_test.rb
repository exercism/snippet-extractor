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

      def test_parsing_no_code_returns_no_code
        # Given
        syntax_trie = SyntaxTrie.new(
          Node.new(
            {' ': Node.new(
              {'a': Node.new(
                {'b': Node.new(
                  {'1': Node.new(
                    {' ': Node.new({}, ' ab1 ', Line.new('ab1'))}.transform_keys!(&:to_s)
                  )}.transform_keys!(&:to_s)
                )}.transform_keys!(&:to_s)
              )}.transform_keys!(&:to_s)
            )}.transform_keys!(&:to_s)
          ))
        code = ""
        expected = ""

        # Expect
        assert_equal expected, CodeParser.(code, syntax_trie)
      end

      def test_line_rule_whole_word_matches
        # Given
        syntax_trie = SyntaxTrie.new(
          Node.new(
            {' ': Node.new(
              {'a': Node.new(
                {'b': Node.new(
                  {'1': Node.new(
                    {' ': Node.new({}, ' ab1 ', Line.new('ab1'))}.transform_keys!(&:to_s)
                  )}.transform_keys!(&:to_s)
                )}.transform_keys!(&:to_s)
              )}.transform_keys!(&:to_s)
            )}.transform_keys!(&:to_s)
          ))
        code =
          <<~CODE
            ab1 ad1 ae1
            ac2 at2 an2
            cd3 cd3 sdf3
          CODE
        expected =
          <<~CODE
            ac2 at2 an2
            cd3 cd3 sdf3
          CODE

        # Expect
        assert_equal expected, CodeParser.(code, syntax_trie)
      end
    end
  end
end
