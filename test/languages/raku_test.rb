require "test_helper"

module SnippetExtractor
  module Languages
    class RakuTest < Minitest::Test
      def test_single
        code = <<~CODE
          # Single line comment, single line
          sub foo { # Single line comment, partial line
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

      def test_multi_round
        code = <<~CODE
          #`( Multi-line comment, round parentheses, single line )
          #`(( Multi-line comment, double round parentheses, single line ))
          sub foo { #`( Multi-
            line comment, single round parentheses, multiple lines )  say #`(( Multi-
            line comment, double round parentheses, multiple lines ))  'baz';
          }
        CODE

        expected = <<~CODE
          sub foo {
            say
            'baz';
          }
        CODE

        assert_equal expected, ExtractSnippet.(code, :raku)
      end

      def test_multi_code
        code = <<~CODE
          #`{ Multi-line comment, code parentheses, single line }
          #`{{ Multi-line comment, double code parentheses, single line }}
          sub foo { #`{ Multi-
            line comment, code parentheses, multiple lines }  say #`{{ Multi-
            line comment, double code parentheses, multiple lines }}  'baz';
          }
        CODE

        expected = <<~CODE
          sub foo {
            say
            'baz';
          }
        CODE

        assert_equal expected, ExtractSnippet.(code, :raku)
      end

      def test_multi_square
        code = <<~CODE
          #`[ Multi-line comment, square parentheses, single line ]
          #`[[ Multi-line comment, double square parentheses, single line ]]
          sub foo { #`[ Multi-
            line comment, square parentheses, multiple lines ]  say #`[[ Multi-
            line comment, double square parentheses, multiple lines ]]  'baz';
          }
        CODE

        expected = <<~CODE
          sub foo {
            say
            'baz';
          }
        CODE

        assert_equal expected, ExtractSnippet.(code, :raku)
      end

      def test_multi_angle
        code = <<~CODE
          #`< Multi-line comment, angle parentheses, single line >
          #`<< Multi-line comment, double angle parentheses, single line >>
          sub foo { #`< Multi-
            line comment, angle parentheses, multiple lines >  say #`<< Multi-
            line comment, double angle parentheses, multiple lines >>  'baz';
          }
        CODE

        expected = <<~CODE
          sub foo {
            say
            'baz';
          }
        CODE

        assert_equal expected, ExtractSnippet.(code, :raku)
      end

      def test_pod
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

    end
  end
end
