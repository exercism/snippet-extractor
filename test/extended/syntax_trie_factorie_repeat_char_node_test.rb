require "test_helper"

module SnippetExtractor
  module Extended
    # Not ideal but adding the class identifier will worse legibility and break rubocop length rule
    SyntaxTrieFactory
    RuleParser

    class SyntaxTrieFactoryRepeatCharNodeTest < Minitest::Test
      def test_single_repeated_letter
        # Given
        rules = [SimpleRule.new('w+', '')]
        expected = SyntaxTrie.new(
          Node.new({ ' ': Node.new(
            { 'w': Node.new(
              { '+': RepeatNode.new(
                { ' ': Node.new({}, ' w+ ', Line.new('w+')) }.transform_keys!(&:to_s), ' w+', nil
              ) }.transform_keys!(&:to_s), ' w', nil
            ) }.transform_keys!(&:to_s), ' ', nil
          ) }.transform_keys!(&:to_s), "", nil)
        )

        # Expect
        assert_equal expected, SyntaxTrieFactory.(rules)
      end

    end
  end
end
