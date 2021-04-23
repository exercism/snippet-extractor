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
        assert_equal expected, CodeParser.new(code, syntax_trie).parse.join
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
        assert_equal expected, CodeParser.new(code, syntax_trie).parse.join
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
        assert_equal expected, CodeParser.new(code, syntax_trie).parse.join
      end

      def test_line_rule_partial_word_matches
        # Given
        syntax_trie = SyntaxTrie.new(
          Node.new(
              {'a': Node.new(
                {'b': Node.new(
                  {'1': Node.new({}, ' ab1 ', Line.new('ab1'))}.transform_keys!(&:to_s)
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
        assert_equal expected, CodeParser.new(code, syntax_trie).parse.join
      end

      def test_just_rule_whole_word_matches
        # Given
        syntax_trie = SyntaxTrie.new(
          Node.new(
            {' ': Node.new(
              {'a': Node.new(
                {'b': Node.new(
                  {'1': Node.new(
                    {' ': Node.new({}, ' ab1 ', Just.new('ab1'))}.transform_keys!(&:to_s)
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
            ad1 ae1
            ac2 at2 an2
            cd3 cd3 sdf3
        CODE

        # Expect
        assert_equal expected, CodeParser.new(code, syntax_trie).parse.join
      end

      def test_just_rule_partial_word_matches
        # Given
        syntax_trie = SyntaxTrie.new(
          Node.new(
            {'a': Node.new(
              {'b': Node.new(
                {'1': Node.new({}, ' ab1 ', Just.new('ab1'))}.transform_keys!(&:to_s)
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
             ad1 ae1
            ac2 at2 an2
            cd3 cd3 sdf3
          CODE

        # Expect
        assert_equal expected, CodeParser.new(code, syntax_trie).parse.join
      end

      def test_multi_rule_with_just_final
        # Given
        syntax_trie_final = SyntaxTrie.new(
          Node.new(
            {'c': Node.new(
              {'d': Node.new({}, 'cd', Just.new('cd'))}.transform_keys!(&:to_s)
            )}.transform_keys!(&:to_s)
          )
        )
        syntax_trie = SyntaxTrie.new(
          Node.new(
            {'a': Node.new(
              {'b': Node.new(
                {'1': Node.new({}, ' ab1 ', Multi.new('ab1', syntax_trie_final))}.transform_keys!(&:to_s)
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
            3 cd3 sdf3
        CODE

        # Expect
        assert_equal expected, CodeParser.new(code, syntax_trie).parse.join
      end

      def test_multi_rule_with_line_final
        # Given
        syntax_trie_final = SyntaxTrie.new(
          Node.new(
            {'a': Node.new(
              {'t': Node.new({}, 'at', Line.new('at'))}.transform_keys!(&:to_s)
            )}.transform_keys!(&:to_s)
          )
        )
        syntax_trie = SyntaxTrie.new(
          Node.new(
            {'a': Node.new(
              {'d': Node.new(
                {'1': Node.new({}, ' ab1 ', Multi.new('ab1', syntax_trie_final))}.transform_keys!(&:to_s)
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
            ab1 
            cd3 cd3 sdf3
          CODE

        # Expect
        assert_equal expected, CodeParser.new(code, syntax_trie).parse.join
      end

    end
  end
end
