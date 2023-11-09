require "test_helper"

class SnippetExtractor::Languages::FsharpTest < Minitest::Test
  def test_full_example
    code = <<~CODE
      open System.IO

      /// This is a
      /// multiline comment

      // I love F#!!
      module Grasses

      let square x = x * x
    CODE

    expected = <<~CODE
      module Grasses

      let square x = x * x
    CODE

    assert_equal expected, SnippetExtractor::ExtractSnippet.(code, :fsharp)
  end

  def test_extended_example
    code = <<~CODE
      open System.IO

      /// This is a
      /// multiline comment

      // I love F#!!
      module Grasses
      (* This module will have
      the square function *)

      let square x = x * x// This does the square
    CODE

    expected = <<~CODE
      module Grasses

      let square x = x * x
    CODE

    assert_equal expected, SnippetExtractor::ExtractSnippet.(code, :fsharp)
  end
end
