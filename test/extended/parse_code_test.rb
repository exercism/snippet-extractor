require "test_helper"

module SnippetExtractor
  module Extended
    class ParseCodeTest < Minitest::Test
      def test_empty_syntax_trie_return_rules
        # Given
        syntax_trie = SyntaxTrie.new(Node.new({}, "", nil))
        code = <<~CODE
          line1
          line2
        CODE
        expected = code

        # Expect
        assert_equal expected, ParseCode.(code, syntax_trie).join
      end

      def test_parsing_no_code_returns_no_code
        # Given
        syntax_trie = SyntaxTrie.new(
          Node.new(
            { ' ': Node.new(
              { 'a': Node.new(
                { 'b': Node.new(
                  { '1': Node.new(
                    { ' ': Node.new({}, ' ab1 ', Line.new('ab1')) }.transform_keys!(&:to_s)
                  ) }.transform_keys!(&:to_s)
                ) }.transform_keys!(&:to_s)
              ) }.transform_keys!(&:to_s)
            ) }.transform_keys!(&:to_s)
          )
        )
        code = ""
        expected = ""

        # Expect
        assert_equal expected, ParseCode.(code, syntax_trie).join
      end

      def test_line_rule_whole_word_matches
        # Given
        syntax_trie = SyntaxTrie.new(
          Node.new(
            { ' ': Node.new(
              { 'a': Node.new(
                { 'b': Node.new(
                  { '1': Node.new(
                    { ' ': Node.new({}, ' ab1 ', Line.new('ab1')) }.transform_keys!(&:to_s)
                  ) }.transform_keys!(&:to_s)
                ) }.transform_keys!(&:to_s)
              ) }.transform_keys!(&:to_s)
            ) }.transform_keys!(&:to_s)
          )
        )
        code = <<~CODE
          ab1 ad1 ae1
          ac2 at2 an2
          cd3 cd3 sdf3
        CODE
        expected = <<~CODE
          ac2 at2 an2
          cd3 cd3 sdf3
        CODE

        # Expect
        assert_equal expected, ParseCode.(code, syntax_trie).join
      end

      def test_matches_ignore_case
        # Given
        syntax_trie = SyntaxTrie.new(
          Node.new(
            { ' ': Node.new(
              { 'a': Node.new(
                { 'b': Node.new(
                  { '1': Node.new(
                    { ' ': Node.new({}, ' ab1 ', Line.new('ab1')) }.transform_keys!(&:to_s)
                  ) }.transform_keys!(&:to_s)
                ) }.transform_keys!(&:to_s)
              ) }.transform_keys!(&:to_s)
            ) }.transform_keys!(&:to_s)
          )
        )
        code = <<~CODE
          aB1 ad1 ae1
          ac2 at2 an2
          cd3 cd3 sdf3
        CODE
        expected = <<~CODE
          ac2 at2 an2
          cd3 cd3 sdf3
        CODE

        # Expect
        assert_equal expected, ParseCode.(code, syntax_trie).join
      end

      def test_line_rule_whole_word_matches_at_end_of_line
        # Given
        syntax_trie = SyntaxTrie.new(
          Node.new(
            { ' ': Node.new(
              { 'a': Node.new(
                { 'e': Node.new(
                  { '1': Node.new(
                    { ' ': Node.new({}, ' ae1 ', Line.new('ae1')) }.transform_keys!(&:to_s)
                  ) }.transform_keys!(&:to_s)
                ) }.transform_keys!(&:to_s)
              ) }.transform_keys!(&:to_s)
            ) }.transform_keys!(&:to_s)
          )
        )
        code = <<~CODE
          ab1 ad1 ae1
          ac2 at2 an2
          cd3 cd3 sdf3
        CODE
        expected = <<~CODE
          ab1 ad1
          ac2 at2 an2
          cd3 cd3 sdf3
        CODE

        # Expect
        assert_equal expected, ParseCode.(code, syntax_trie).join
      end

      def test_line_rule_partial_word_matches
        # Given
        syntax_trie = SyntaxTrie.new(
          Node.new(
            { 'a': Node.new(
              { 'b': Node.new(
                { '1': Node.new({}, ' ab1 ', Line.new('ab1')) }.transform_keys!(&:to_s)
              ) }.transform_keys!(&:to_s)
            ) }.transform_keys!(&:to_s)
          )
        )
        code = <<~CODE
          ab1 ad1 ae1
          ac2 at2 an2
          cd3 cd3 sdf3
        CODE
        expected = <<~CODE
          ac2 at2 an2
          cd3 cd3 sdf3
        CODE

        # Expect
        assert_equal expected, ParseCode.(code, syntax_trie).join
      end

      def test_just_rule_whole_word_matches
        # Given
        syntax_trie = SyntaxTrie.new(
          Node.new(
            { ' ': Node.new(
              { 'a': Node.new(
                { 'b': Node.new(
                  { '1': Node.new(
                    { ' ': Node.new({}, ' ab1 ', Just.new('ab1')) }.transform_keys!(&:to_s)
                  ) }.transform_keys!(&:to_s)
                ) }.transform_keys!(&:to_s)
              ) }.transform_keys!(&:to_s)
            ) }.transform_keys!(&:to_s)
          )
        )
        code = <<~CODE
          ab1 ad1 ae1
          ac2 at2 an2
          cd3 cd3 sdf3
        CODE
        expected = <<~CODE
          ad1 ae1
          ac2 at2 an2
          cd3 cd3 sdf3
        CODE

        # Expect
        assert_equal expected, ParseCode.(code, syntax_trie).join
      end

      def test_just_rule_partial_word_matches
        # Given
        syntax_trie = SyntaxTrie.new(
          Node.new(
            { 'a': Node.new(
              { 'b': Node.new(
                { '1': Node.new({}, ' ab1 ', Just.new('ab1')) }.transform_keys!(&:to_s)
              ) }.transform_keys!(&:to_s)
            ) }.transform_keys!(&:to_s)
          )
        )
        code = <<~CODE
          ab1 ad1 ae1
          ac2 at2 an2
          cd3 cd3 sdf3
        CODE
        expected = <<~CODE
           ad1 ae1
          ac2 at2 an2
          cd3 cd3 sdf3
        CODE

        # Expect
        assert_equal expected, ParseCode.(code, syntax_trie).join
      end

      def test_multi_rule_with_just_final
        # Given
        syntax_trie_final = SyntaxTrie.new(
          Node.new(
            { 'c': Node.new(
              { 'd': Node.new({}, 'cd', Just.new('cd')) }.transform_keys!(&:to_s)
            ) }.transform_keys!(&:to_s)
          )
        )
        syntax_trie = SyntaxTrie.new(
          Node.new(
            { 'a': Node.new(
              { 'b': Node.new(
                { '1': Node.new({}, ' ab1 ', Multi.new(Just.new('ab1'), syntax_trie_final)) }.transform_keys!(&:to_s)
              ) }.transform_keys!(&:to_s)
            ) }.transform_keys!(&:to_s)
          )
        )

        code = <<~CODE
          ab1 ad1 ae1
          ac2 at2 an2
          cd3 cd3 sdf3
        CODE
        expected = <<~CODE
          3 cd3 sdf3
        CODE

        # Expect
        assert_equal expected, ParseCode.(code, syntax_trie).join
      end

      def test_multi_rule_with_line_final
        # Given
        syntax_trie_final = SyntaxTrie.new(
          Node.new(
            { 'a': Node.new(
              { 't': Node.new({}, 'at', Line.new('at')) }.transform_keys!(&:to_s)
            ) }.transform_keys!(&:to_s)
          )
        )
        syntax_trie = SyntaxTrie.new(
          Node.new(
            { 'a': Node.new(
              { 'd': Node.new(
                { '1': Node.new({}, ' ab1 ', Multi.new(Just.new('ab1'), syntax_trie_final)) }.transform_keys!(&:to_s)
              ) }.transform_keys!(&:to_s)
            ) }.transform_keys!(&:to_s)
          )
        )

        code = <<~CODE
          ab1 ad1 ae1
          ac2 at2 an2
          cd3 cd3 sdf3
        CODE
        expected = <<~CODE
          ab1#{' '}
          cd3 cd3 sdf3
        CODE

        # Expect
        assert_equal expected, ParseCode.(code, syntax_trie).join
      end

      def test_multi_rule_in_one_line_just_start_action
        # Given
        syntax_trie_final = SyntaxTrie.new(
          Node.new(
            { 'a': Node.new(
              { 'e': Node.new({}, 'ae', Just.new('ae')) }.transform_keys!(&:to_s)
            ) }.transform_keys!(&:to_s)
          )
        )
        syntax_trie = SyntaxTrie.new(
          Node.new(
            { 'a': Node.new(
              { 'b': Node.new(
                { '1': Node.new({}, ' ab1 ', Multi.new(Just.new('ab1'), syntax_trie_final)) }.transform_keys!(&:to_s)
              ) }.transform_keys!(&:to_s)
            ) }.transform_keys!(&:to_s)
          )
        )

        code = <<~CODE
          ab1 ad1 ae1
          ac2 at2 ae2
          cd3 cd3 sdf3
        CODE
        expected = <<~CODE
          1
          ac2 at2 ae2
          cd3 cd3 sdf3
        CODE

        # Expect
        assert_equal expected, ParseCode.(code, syntax_trie).join
      end

      def test_multi_rule_in_one_line_line_start_action
        # Given
        syntax_trie_final = SyntaxTrie.new(
          Node.new(
            { 'a': Node.new(
              { 'e': Node.new({}, 'ae', Just.new('ae')) }.transform_keys!(&:to_s)
            ) }.transform_keys!(&:to_s)
          )
        )
        syntax_trie = SyntaxTrie.new(
          Node.new(
            { 'a': Node.new(
              { 'b': Node.new(
                { '1': Node.new({}, ' ab1 ', Multi.new(Line.new('ab1'), syntax_trie_final)) }.transform_keys!(&:to_s)
              ) }.transform_keys!(&:to_s)
            ) }.transform_keys!(&:to_s)
          )
        )

        code = <<~CODE
          ab1 ad1 ae1
          ac2 at2 ae2
          cd3 cd3 sdf3
        CODE
        expected = <<~CODE
          2
          cd3 cd3 sdf3
        CODE

        # Expect
        assert_equal expected, ParseCode.(code, syntax_trie).join
      end

      def test_slight_overlapping_in_rules
        # Given
        syntax_trie = SyntaxTrie.new(
          Node.new(
            { 'a': Node.new(
              { 'b': Node.new(
                { '1': Node.new({}, 'ab1', Just.new('ab1')) }.transform_keys!(&:to_s)
              ) }.transform_keys!(&:to_s)
            ),
              '1': Node.new({}, '1', Line.new('1')) }.transform_keys!(&:to_s)
          )
        )
        code = <<~CODE
          ab1 ad2 ae2
          ac2 at2 an2
          cd3 cd3 sdf3
        CODE
        expected = <<~CODE
           ad2 ae2
          ac2 at2 an2
          cd3 cd3 sdf3
        CODE

        # Expect
        assert_equal expected, ParseCode.(code, syntax_trie).join
      end

      def test_line_rule_skip_matches_inside_line
        # Given
        syntax_trie = SyntaxTrie.new(
          Node.new(
            { '9': Node.new(
              {}, '9', Multi.new(Just.new('9'), SyntaxTrie.new(Node.new({ '5': Node.new({}, '5', Just.new('5')) }.
                                                                transform_keys!(&:to_s))))
            ),
              '1': Node.new({}, '1', Line.new('1')) }.transform_keys!(&:to_s)
          )
        )
        code = <<~CODE
          ab1 ad9 ae2
          ac2 at2 an2
          cd3 cd5 sdf3
        CODE
        expected = <<~CODE
          ab
          ac2 at2 an2
          cd3 cd5 sdf3
        CODE

        # Expect
        assert_equal expected, ParseCode.(code, syntax_trie).join
      end

      def test_multi_line_rule_skip_matches_inside
        # Given
        syntax_trie = SyntaxTrie.new(
          Node.new(
            { '3': Node.new(
              {}, '3', Multi.new(Just.new('3'), SyntaxTrie.new(Node.new({ '8': Node.new({}, '8', Just.new('8')) }.
                                                                transform_keys!(&:to_s))))
            ),
              '1': Node.new(
                {}, '1', Multi.new(Just.new('1'), SyntaxTrie.new(Node.new({ '5': Node.new({}, '5', Just.new('5')) }.
                                                                 transform_keys!(&:to_s))))
              ) }.transform_keys!(&:to_s)
          )
        )
        code = <<~CODE
          ab1 ad2 ae3
          ac4 at5 an6
          cd7 cd8 sdf9
        CODE
        expected = <<~CODE
          ab
           an6
          cd7 cd8 sdf9
        CODE

        # Expect
        assert_equal expected, ParseCode.(code, syntax_trie).join
      end

      def test_repeat_char_wont_match_1_char
        # Given
        syntax_trie = SyntaxTrie.new(
          Node.new(
            { "a": Node.new(
              { "+": Node.new(
                {}, "a+", Line.new("a+")
              ) }.transform_keys!(&:to_s), "a", nil
            ) }.transform_keys!(&:to_s), "", nil
          )
        )
        code = <<~CODE
          a1 cdefgh2
          aa1 cdefgh2
          a cdefgh2
          aa cdefgh2
        CODE

        expected = <<~CODE
          a1 cdefgh2
          a cdefgh2
        CODE

        # Expect
        assert_equal expected, ParseCode.(code, syntax_trie).join
      end

      def test_repeat_char_default_is_tailless
        # Given
        syntax_trie = SyntaxTrie.new(
          Node.new(
            { "a": Node.new(
              { "+": Node.new(
                { "1": Node.new(
                  {}, "a+1", Just.new("a+1")
                ) }.transform_keys!(&:to_s), "a+", Line.new("a+")
              ) }.transform_keys!(&:to_s), "a", nil
            ) }.transform_keys!(&:to_s), "", nil
          )
        )
        code = <<~CODE
          a1 cdefgh2
          aa1 cdefgh2
          a cdefgh2
          aa cdefgh2
        CODE

        expected = <<~CODE
          a1 cdefgh2
           cdefgh2
          a cdefgh2
        CODE

        # Expect
        assert_equal expected, ParseCode.(code, syntax_trie).join
      end

      def test_first_loc_argument
        # Given
        syntax_trie = SyntaxTrie.new(
          Node.new(
            { ' ': Node.new(
              { 'a': Node.new(
                { 'b': Node.new(
                  { '1': Node.new(
                    { ' ': Node.new({}, ' ab1 ', Line.new('ab1')) }.transform_keys!(&:to_s)
                  ) }.transform_keys!(&:to_s)
                ) }.transform_keys!(&:to_s)
              ) }.transform_keys!(&:to_s)
            ) }.transform_keys!(&:to_s)
          )
        )
        code = <<~CODE
          ab1 ad1 ae1
          ac2 ab1 ad1 ae1
          ab1 ad1 ae1
        CODE
        expected = <<~CODE
          ac2 ab1 ad1 ae1
          ab1 ad1 ae1
        CODE

        # Expect
        assert_equal expected, ParseCode.(code, syntax_trie, ['stop_at_first_loc']).join
      end

      def test_empty_lines_at_beginning_are_ignored
        # Given
        syntax_trie = SyntaxTrie.new(
          Node.new({}, "", nil)
        )
        code = <<~CODE
          ab1 ad1 ae1

          ac2 at2 an2
          cd3 cd3 sdf3
        CODE
        expected = <<~CODE
          ab1 ad1 ae1

          ac2 at2 an2
          cd3 cd3 sdf3
        CODE

        # Expect
        assert_equal expected, ParseCode.(code, syntax_trie).join
      end

      def test_one_empty_line_is_stored
        # Given
        syntax_trie = SyntaxTrie.new(
          Node.new({}, "", nil)
        )
        code = <<~CODE
          ab1 ad1 ae1

          ac2 at2 an2
          cd3 cd3 sdf3
        CODE
        expected = <<~CODE
          ab1 ad1 ae1

          ac2 at2 an2
          cd3 cd3 sdf3
        CODE

        # Expect
        assert_equal expected, ParseCode.(code, syntax_trie).join
      end

      def test_two_empty_lines_skips_the_second_one
        # Given
        syntax_trie = SyntaxTrie.new(
          Node.new({}, "", nil)
        )
        code = <<~CODE
          ab1 ad1 ae1


          ac2 at2 an2
          cd3 cd3 sdf3
        CODE
        expected = <<~CODE
          ab1 ad1 ae1

          ac2 at2 an2
          cd3 cd3 sdf3
        CODE

        # Expect
        assert_equal expected, ParseCode.(code, syntax_trie).join
      end

      def test_skips_dont_interfere_with_emptyline_logic
        # Given
        syntax_trie = SyntaxTrie.new(
          Node.new(
            { ' ': Node.new(
              { 'a': Node.new(
                { 'b': Node.new(
                  { '1': Node.new(
                    { ' ': Node.new({}, ' ab1 ', Line.new('ab1')) }.transform_keys!(&:to_s)
                  ) }.transform_keys!(&:to_s)
                ) }.transform_keys!(&:to_s)
              ) }.transform_keys!(&:to_s)
            ) }.transform_keys!(&:to_s)
          )
        )
        code = <<~CODE
          ac2 at2 an2

          ab1 ad1 ae1

          cd3 cd3 sdf3
        CODE
        expected = <<~CODE
          ac2 at2 an2

          cd3 cd3 sdf3
        CODE

        # Expect
        assert_equal expected, ParseCode.(code, syntax_trie).join
      end

      def test_multi_rule_skips_dont_add_lines_neither_remove_lines_just_after
        # Given
        syntax_trie_final = SyntaxTrie.new(
          Node.new(
            { 'a': Node.new(
              { 't': Node.new({}, 'at', Line.new('at')) }.transform_keys!(&:to_s)
            ) }.transform_keys!(&:to_s)
          )
        )
        syntax_trie = SyntaxTrie.new(
          Node.new(
            { 'a': Node.new(
              { 'd': Node.new(
                { '1': Node.new({}, 'ad1', Multi.new(Just.new('ad1'), syntax_trie_final)) }.transform_keys!(&:to_s)
              ) }.transform_keys!(&:to_s)
            ) }.transform_keys!(&:to_s)
          )
        )

        code = <<~CODE
          ab1 ad1 ae1

          ac2 at2 an2

          cd3 cd3 sdf3
        CODE
        expected = <<~CODE
          ab1#{' '}

          cd3 cd3 sdf3
        CODE

        # Expect
        assert_equal expected, ParseCode.(code, syntax_trie).join
      end

    end
  end
end
