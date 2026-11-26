require "test_helper"

module SnippetExtractor
  class ExtractSnippetTest < Minitest::Test
    def test_returns_first_15_loc_on_missing_language
      lines = (1..20).map { |i| "Loc #{i}\n" }

      assert_equal lines.first(15).join, ExtractSnippet.(lines.join, :foobar)
    end

    def test_strips_correctly
      code = <<~CODE
        # This is a file
        # With some comments in it

        # And a blank line ⬆️
        # It has some requires like this:
        require 'json'

        # And then eventually the code
        class TwoFer
          ...
        end
      CODE

      expected = <<~CODE
        class TwoFer
          ...
        end
      CODE

      assert_equal expected, ExtractSnippet.(code, :ruby)
    end

    def test_extracts_first_15
      body = (2..20).map { |i| "  Line #{i}\n" }
      code = "# Here is some code\nclass TwoFer\n#{body.join}end\n"

      assert_equal "class TwoFer\n#{body.first(14).join}", ExtractSnippet.(code, :ruby)
    end

    def test_extracts_first_15_with_basic_syntax
      lines = (1..20).map { |i| "x = #{i}\n" }

      assert_equal lines.first(15).join, ExtractSnippet.(lines.join, :julia)
    end

    def test_cuts_long_lines_to_200_characters_keeping_the_newline
      code = "class TwoFer\n  #{'a' * 300}\n  short\nend\n"

      expected = "class TwoFer\n  #{'a' * 198}\n  short\nend\n"

      assert_equal expected, ExtractSnippet.(code, :ruby)
    end

    def test_leaves_lines_of_exactly_200_characters_alone
      line = "#{'b' * 199}\n"

      assert_equal "class TwoFer\n#{line}", ExtractSnippet.("class TwoFer\n#{line}", :ruby)
    end

    def test_cuts_long_lines_by_characters_not_bytes
      # Characters 199 and 200 are multi-byte, so a byte-based cut would split one.
      long_line = "#{'a' * 198}é日#{'z' * 50}"
      code = "class TwoFer\n#{long_line}\nend\n"

      expected = "class TwoFer\n#{'a' * 198}é日\nend\n"
      actual = ExtractSnippet.(code, :ruby)

      assert_equal expected, actual
      assert actual.valid_encoding?
      assert_equal 200, actual.lines[1].chomp.length
    end

    def test_cuts_long_lines_on_the_missing_language_fallback
      code = "#{'x' * 250}\nshort\n"

      assert_equal "#{'x' * 200}\nshort\n", ExtractSnippet.(code, :foobar)
    end

    def test_cuts_a_long_last_line_without_a_newline
      code = "class TwoFer\n#{'y' * 250}"

      assert_equal "class TwoFer\n#{'y' * 200}", ExtractSnippet.(code, :ruby)
    end

    def test_strips_correctly_with_extended_syntax
      code = <<~CODE
        # This is a file
        # With some comments in it

        # And a blank line ⬆️
        # It has some requires like this:
        require 'json'

        # And then eventually the code
        class TwoFer#Comment will not be ignored because of flag
          ...#This neither
        # Comment
        end
      CODE

      expected = <<~CODE
        class TwoFer#Comment will not be ignored because of flag
          ...#This neither
        # Comment
        end
      CODE

      assert_equal expected, ExtractSnippet.(code, :ruby)
    end
  end
end
