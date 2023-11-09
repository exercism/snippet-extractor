require "test_helper"

class SnippetExtractor::Languages::CppTest < Minitest::Test
  def test_full_example
    code = <<~CODE
      #include <string>
      
      namespace two_fer
      {
          std::string two_fer(const std::string& name = "you")
          {
              return "One for " + name + ", one for me.";
          }
      }
    CODE

    expected = <<~CODE      
      namespace two_fer
      {
          std::string two_fer(const std::string& name = "you")
          {
              return "One for " + name + ", one for me.";
          }
      }
    CODE

    assert_equal expected, SnippetExtractor::ExtractSnippet.(code, :cpp)
  end

  def test_extended_example
    code = <<~CODE
      #if !defined(TWO_FER_H)
      #define TWO_FER_H
      
      #include <string>
      
      using namespace std;

      namespace two_fer
      {
          /* multiline comments
          can have comments 
          // single line commennt
          or include #something 
          */
          inline string two_fer(const string& name = "you")
          {
              // There might be a comment here
              return "One for " + name + ", one for me."; // A comment after a valid line 
          }
      } // namespace two_fer
      
      #endif //TWO_FER_H
    CODE

    expected = <<~CODE       
      namespace two_fer
      {
          inline string two_fer(const string& name = "you")
          {
              return "One for " + name + ", one for me.";
          }
      }

    CODE

    assert_equal expected, SnippetExtractor::ExtractSnippet.(code, :cpp)
  end
end
