require "test_helper"

class SnippetExtractor::Languages::MipsTest < Minitest::Test
  def test_full_example
    code = <<~CODE
      # General comment
      #
      # $a0 - input
      
      .globl binary_convert
      
      binary_convert:
              li      $v0, 0 # line comment
      
      # Another line comment
      end:
              jr $ra
        
    CODE

    expected = <<~CODE          
      .globl binary_convert
      
      binary_convert:
              li      $v0, 0 

      end:
              jr $ra
      
    CODE

    assert_equal expected, SnippetExtractor::ExtractSnippet.(code, :nim)
  end
end
