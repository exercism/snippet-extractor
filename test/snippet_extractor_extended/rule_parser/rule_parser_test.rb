require "test_helper"

module SnippetExtractorExtended
  class RuleParserTest < Minitest::Test

    def test_empty_file_brings_empty_rule_list
      # Given
      rule_text =
        %{}

      # When
      rule_list = RuleParser.(rule_text)

      # Then
      assert_equal [], rule_list
    end

    def test_word_creates_simple_rule_with_word
      # Given
      rule_text =
        %{word
        }

      # When
      rule_list = RuleParser.(rule_text)

      # Then
      assert_equal [SimpleRule.new('word')], rule_list
    end

  end
end
