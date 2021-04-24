require "test_helper"

module SnippetExtractor
  module Extended
    SyntaxTrieFactory
    CodeParser

    class CodeParserTest < Minitest::Test
      def test_empty_syntax_trie_return_rules
        # Given
        rules = ["!e"]
        code =
          <<~CODE
            line1
            line2
          CODE
        expected = code

        # Expect
        assert_equal expected, ExtendedExtractor.(code, rules).join
      end

      def test_parsing_no_code_returns_no_code
        # Given
        rules = ["!e", "ab1"]
        code = ""
        expected = ""

        # Expect
        assert_equal expected, ExtendedExtractor.(code, rules).join
      end

      def test_line_rule_whole_word_matches
        # Given
        rules = ["!e", "ab1"]
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
        assert_equal expected, ExtendedExtractor.(code, rules).join
      end

      def test_line_rule_partial_word_matches
        # Given
        rules = ["!e", 'ab1\p']

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
        assert_equal expected, ExtendedExtractor.(code, rules).join
      end

      def test_just_rule_whole_word_matches
        # Given
        rules = ["!e", 'ab1\j']

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
        assert_equal expected, ExtendedExtractor.(code, rules).join
      end

      def test_just_rule_partial_word_matches
        # Given
        rules = ["!e", 'ab1\jp']

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
        assert_equal expected, ExtendedExtractor.(code, rules).join
      end

      def test_multi_rule_with_just_final
        # Given
        rules = ["!e", 'ab1\p-->>cd\jp']

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
        assert_equal expected, ExtendedExtractor.(code, rules).join
      end

      def test_multi_rule_with_line_final
        # Given
        rules = ["!e", 'ad1\jp-->>at\p']

        code =
          <<~CODE
            ab1 ad1 ae1
            ac2 at2 an2
            cd3 cd3 sdf3
          CODE
        expected =
          <<~CODE
            ab1#{' '}
            cd3 cd3 sdf3
          CODE

        # Expect
        assert_equal expected, ExtendedExtractor.(code, rules).join
      end

      def test_multi_rule_in_one_line_just_start_action
        # Given
        rules = ["!e", 'ab1\jp-->>ae\jp']

        code =
          <<~CODE
            ab1 ad1 ae1
            ac2 at2 ae2
            cd3 cd3 sdf3
          CODE
        expected =
          <<~CODE
            1
            ac2 at2 ae2
            cd3 cd3 sdf3
          CODE

        # Expect
        assert_equal expected, ExtendedExtractor.(code, rules).join
      end

      def test_multi_rule_in_one_line_line_start_action
        # Given
        rules = ["!e", 'ab1\p-->>ae\jp']

        code =
          <<~CODE
            ab1 ad1 ae1
            ac2 at2 ae2
            cd3 cd3 sdf3
          CODE
        expected =
          <<~CODE
            2
            cd3 cd3 sdf3
          CODE

        # Expect
        assert_equal expected, ExtendedExtractor.(code, rules).join
      end

      def test_slight_overlapping_in_rules
        # Given
        rules = ["!e", 'ab1\jp', '1']

        code =
          <<~CODE
            ab1 ad2 ae2
            ac2 at2 an2
            cd3 cd3 sdf3
          CODE
        expected =
          <<~CODE
             ad2 ae2
            ac2 at2 an2
            cd3 cd3 sdf3
          CODE

        # Expect
        assert_equal expected, ExtendedExtractor.(code, rules).join
      end

      def test_line_rule_skip_matches_inside_line
        # Given
        rules = ["!e", '9\jp-->>5\jp', '1\p']

        code =
          <<~CODE
            ab1 ad9 ae2
            ac2 at2 an2
            cd3 cd5 sdf3
          CODE
        expected =
          <<~CODE
            ab
            ac2 at2 an2
            cd3 cd5 sdf3
          CODE

        # Expect
        assert_equal expected, ExtendedExtractor.(code, rules).join
      end

      def multi_line_rule_skip_matches_inside
        # Given
        rules = ["!e", '3\jp-->>`8\jp`', '1\jp-->>`5\jp']

        code =
          <<~CODE
            ab1 ad2 ae3
            ac4 at5 an6
            cd7 cd8 sdf9
          CODE
        expected =
          <<~CODE
             an6
            cd7 cd8 sdf9
          CODE

        # Expect
        assert_equal expected, ExtendedExtractor.(code, rules).join
      end
    end
  end
end
