require "test_helper"

class SnippetExtractor::Languages::JqTest < Minitest::Test
  def test_no_comments
    code = <<~CODE
      {a: "foo", b: "bar"}
    CODE

    expected = <<~CODE
      {a: "foo", b: "bar"}
    CODE

    assert_equal expected, SnippetExtractor::ExtractSnippet.(code, :ruby)
  end

  def test_full_example
    code = <<~CODE
      # This is a file
      # With some comments in it

      # And a blank line ⬆️

      # And then eventually the code
      def afunc: 42 ;

      afunc
    CODE

    expected = <<~CODE
      def afunc: 42 ;

      afunc
    CODE

    assert_equal expected, SnippetExtractor::ExtractSnippet.(code, :jq)
  end

  def test_stop_at_first_loc
    code = <<~CODE
      # a comment should be removed
      {a: "foo", b: "bar"}
      # a comment should remain
    CODE

    expected = <<~CODE
      {a: "foo", b: "bar"}
      # a comment should remain
    CODE

    assert_equal expected, SnippetExtractor::ExtractSnippet.(code, :ruby)
  end
end
