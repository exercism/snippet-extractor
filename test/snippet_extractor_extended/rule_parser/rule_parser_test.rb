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
        %q{word
        }

      # When
      rule_list = RuleParser.(rule_text)

      # Then
      assert_equal [SimpleRule.new('word', '')], rule_list
    end

    def test_partial_word_creates_simple_rule_with_partial_modifier
      # Given
      rule_text =
        %q{word\p
        }

      # When
      rule_list = RuleParser.(rule_text)

      # Then
      assert_equal [SimpleRule.new('word','p')], rule_list
    end

    def test_just_word_creates_simple_rule_with_just_modifier
      # Given
      rule_text =
        %q{word\j
        }

      # When
      rule_list = RuleParser.(rule_text)

      # Then
      assert_equal [SimpleRule.new('word','j')], rule_list
    end

    def test_just_partial_word_creates_simple_rule_with_just_and_partial_modifiers
      # Given
      rule_text =
        %q{word\pj
        }

      # When
      rule_list = RuleParser.(rule_text)

      # Then
      assert_equal [SimpleRule.new('word','pj')], rule_list
    end

    def test_word_with_repeated_character_should_bring_simple_rule_with_word_with_repeated_character
      # Given
      rule_text =
        %q{wo+rd\pj
        }

      # When
      rule_list = RuleParser.(rule_text)

      # Then
      assert_equal [SimpleRule.new('wo+rd','pj')], rule_list
    end

    def test_word_with_spaces_are_respected_in_the_simple_rule
      # Given
      rule_text =
        %q{ word  \
        }

      # When
      rule_list = RuleParser.(rule_text)

      # Then
      assert_equal [SimpleRule.new(' word  ', '')], rule_list
    end

    def test_word_with_tabs_are_respected_in_the_simple_rule
      # Given
      rule_text =
        %q{
    word
        }

      # When
      rule_list = RuleParser.(rule_text)

      # Then
      assert_equal [SimpleRule.new('    word','')], rule_list
    end

    def test_multiline_rule_creates_multiline_rule_containing_both_rules
      # Given
      rule_text =
        %q{word-->>other word\j
        }

      # When
      rule_list = RuleParser.(rule_text)

      # Then
      assert_equal [MultilineRule.new(SimpleRule.new('word',''), SimpleRule.new('other word','j'))], rule_list
    end

    def test_file_with_multiple_rules
      # Given
      rule_text =
      <<~'TEXT'
        word-->>other word\j
        asd+f\
        /*\p-->>*/\pj
        //\p
      TEXT

      # When
      rule_list = RuleParser.(rule_text)

      # Then
      assert_equal [
                     MultilineRule.new(SimpleRule.new('word',''), SimpleRule.new('other word','j')),
                     SimpleRule.new('asd+f',''),
                     MultilineRule.new(SimpleRule.new('/*','p'), SimpleRule.new('*/','pj')),
                     SimpleRule.new('//','p')
                   ], rule_list
    end
  end
end
