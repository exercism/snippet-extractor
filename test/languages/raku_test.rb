require "test_helper"

module SnippetExtractor
  module Languages
    class RakuTest < Minitest::Test
      def test_single_line
        code = <<~CODE
          # Comment
          sub foo {
            say 'baz';
          }
        CODE

        expected = <<~CODE
          sub foo {
            say 'baz';
          }
        CODE

        assert_equal expected, ExtractSnippet.(code, :raku)
      end

      def test_single_line_partial
        code = <<~CODE
          sub foo { # Comment
            say 'baz';
          }
        CODE

        expected = <<~CODE
          sub foo {
            say 'baz';
          }
        CODE

        assert_equal expected, ExtractSnippet.(code, :raku)
      end

      def test_multi_line_parentheses_A
        code = <<~CODE
          sub foo { #`( Comment )
            say 'baz';
          }
        CODE

        expected = <<~CODE
          sub foo {
            say 'baz';
          }
        CODE

        assert_equal expected, ExtractSnippet.(code, :raku)
      end

      def test_multi_line_parentheses_A_partial
        code = <<~CODE
          sub foo { #`( Com-
            ment )  say 'baz';
          }
        CODE

        expected = <<~CODE
          sub foo {
            say 'baz';
          }
        CODE

        assert_equal expected, ExtractSnippet.(code, :raku)
      end

      def test_multi_line_parentheses_B
        code = <<~CODE
          sub foo { #`{ Comment }
            say 'baz';
          }
        CODE

        expected = <<~CODE
          sub foo {
            say 'baz';
          }
        CODE

        assert_equal expected, ExtractSnippet.(code, :raku)
      end

      def test_multi_line_parentheses_B_partial
        code = <<~CODE
          sub foo { #`{ Com-
            ment }  say 'baz';
          }
        CODE

        expected = <<~CODE
          sub foo {
            say 'baz';
          }
        CODE

        assert_equal expected, ExtractSnippet.(code, :raku)
      end

      def test_multi_line_parentheses_C
        code = <<~CODE
          sub foo { #`[ Comment ]
            say 'baz';
          }
        CODE

        expected = <<~CODE
          sub foo {
            say 'baz';
          }
        CODE

        assert_equal expected, ExtractSnippet.(code, :raku)
      end

      def test_multi_line_parentheses_C_partial
        code = <<~CODE
          sub foo { #`[ Com-
            ment ]  say 'baz';
          }
        CODE

        expected = <<~CODE
          sub foo {
            say 'baz';
          }
        CODE

        assert_equal expected, ExtractSnippet.(code, :raku)
      end

      def test_multi_line_parentheses_AA
        code = <<~CODE
          sub foo { #`(( Comment ))
            say 'baz';
          }
        CODE

        expected = <<~CODE
          sub foo {
            say 'baz';
          }
        CODE

        assert_equal expected, ExtractSnippet.(code, :raku)
      end

      def test_multi_line_parentheses_AA_partial
        code = <<~CODE
          sub foo { #`(( Com-
            ment ))  say 'baz';
          }
        CODE

        expected = <<~CODE
          sub foo {
            say 'baz';
          }
        CODE

        assert_equal expected, ExtractSnippet.(code, :raku)
      end

      def test_multi_line_parentheses_BB
        code = <<~CODE
          sub foo { #`{{ Comment }}
            say 'baz';
          }
        CODE

        expected = <<~CODE
          sub foo {
            say 'baz';
          }
        CODE

        assert_equal expected, ExtractSnippet.(code, :raku)
      end

      def test_multi_line_parentheses_BB_partial
        code = <<~CODE
          sub foo { #`{{ Com-
            ment }}  say 'baz';
          }
        CODE

        expected = <<~CODE
          sub foo {
            say 'baz';
          }
        CODE

        assert_equal expected, ExtractSnippet.(code, :raku)
      end

      def test_multi_line_parentheses_CC
        code = <<~CODE
          sub foo { #`[[ Comment ]]
            say 'baz';
          }
        CODE

        expected = <<~CODE
          sub foo {
            say 'baz';
          }
        CODE

        assert_equal expected, ExtractSnippet.(code, :raku)
      end

      def test_multi_line_parentheses_CC_partial
        code = <<~CODE
          sub foo { #`[[ Com-
            ment ]]  say 'baz';
          }
        CODE

        expected = <<~CODE
          sub foo {
            say 'baz';
          }
        CODE

        assert_equal expected, ExtractSnippet.(code, :raku)
      end

      def test_begin_end
        code = <<~CODE
          =begin comment
            Hello,
            World!
          =end comment
          sub foo {
            say 'baz';
          }
        CODE

        expected = <<~CODE
          sub foo {
            say 'baz';
          }
        CODE

        assert_equal expected, ExtractSnippet.(code, :raku)
      end

      def test_unit
        code = <<~CODE
          unit class HelloWorld;

          sub foo {
            say 'baz';
          }
        CODE

        expected = <<~CODE
          sub foo {
            say 'baz';
          }
        CODE

        assert_equal expected, ExtractSnippet.(code, :raku)
      end
    end
  end
end
