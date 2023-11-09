require "test_helper"

class SnippetExtractor::Languages::NimTest < Minitest::Test
  def test_full_example
    code = <<~CODE
      ## Module doc comment
      # This is a file
      # With some comments in it

      # And a blank line ⬆️
      # It has some module-related code like this:
      import json
      export json
      from json import nil
      # And then eventually the code
      proc twoFer =
        ##[ doc comment ]##
        ## more doc comment
        discard
      # A non doc comment
    CODE

    expected = <<~CODE
      proc twoFer =
        discard
    CODE

    assert_equal expected, SnippetExtractor::ExtractSnippet.(code, :nim)
  end

  def test_extended_example
    code = <<~CODE
      ## Module doc comment
      # This is a file
      # With some comments in it

      # And a blank line ⬆️
      # It has some module-related code like this:
      import json
      export json
      from json import nil
      # And then eventually the code
      proc twoFer =#more comments
        # comment
        #####comment
        #[comment]#
        ####[comment]#
        #[comment]####
        #####[comment]#
        # comment
        #####comment
        #[
          comment
         ]#
        ####[
          comment
        ]#
        #[
          comment
          ]####
        #####[
          comment
        ]#
        ##[ doc comment ]##
        ## more doc comment
        discard
      # A non doc comment
    CODE

    expected = <<~CODE
      proc twoFer =
        discard
    CODE

    assert_equal expected, SnippetExtractor::ExtractSnippet.(code, :nim)
  end
end
