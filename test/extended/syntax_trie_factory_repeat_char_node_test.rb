require "test_helper"

module SnippetExtractor
  module Extended
    class BuildSyntaxTrieRepeatCharNodeTest < Minitest::Test
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
        assert_equal expected, BuildSyntaxTrie.(rules)
      end

      def test_single_repeated_letter_at_beginning
        # Given
        rules = [SimpleRule.new('+w', 'p')]

        # Expect
        assert_raises { BuildSyntaxTrie.(rules) }
      end

      def test_single_repeated_letter_at_end
        # Given
        rules = [SimpleRule.new('w+', 'p')]
        expected = SyntaxTrie.new(
          Node.new(
            { 'w': Node.new(
              { '+': RepeatNode.new(
                {}, 'w+', Line.new('w+')
              ) }.transform_keys!(&:to_s), 'w', nil
            ) }.transform_keys!(&:to_s), '', nil
          )
        )

        # Expect
        assert_equal expected, BuildSyntaxTrie.(rules)
      end

      def test_two_repeated_chars_different_tail
        # Given
        rules = [SimpleRule.new('w+o', 'p'), SimpleRule.new('w+e', 'pj')]
        expected = SyntaxTrie.new(
          Node.new(
            { 'w': Node.new(
              { '+': RepeatNode.new(
                { 'o': Node.new({}, 'w+o', Line.new('w+o')),
                  'e': Node.new({}, 'w+e', Just.new('w+e')) }.transform_keys!(&:to_s), 'w+', nil
              ) }.transform_keys!(&:to_s), 'w', nil
            ) }.transform_keys!(&:to_s), '', nil
          )
        )

        # Expect
        assert_equal expected, BuildSyntaxTrie.(rules)
      end

      def test_two_repeated_chars_one_with_tail_other_is_finish
        # Given
        rules = [SimpleRule.new('w+', 'p'), SimpleRule.new('w+e', 'pj')]
        expected = SyntaxTrie.new(
          Node.new(
            { 'w': Node.new(
              { '+': RepeatNode.new(
                { 'e': Node.new({}, 'w+e', Just.new('w+e')) }.transform_keys!(&:to_s), 'w+', Line.new('w+')
              ) }.transform_keys!(&:to_s), 'w', nil
            ) }.transform_keys!(&:to_s), '', nil
          )
        )

        # Expect
        assert_equal expected, BuildSyntaxTrie.(rules)
      end
    end
  end
end
