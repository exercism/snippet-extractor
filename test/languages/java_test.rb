require "test_helper"

class SnippetExtractor::Languages::JavaTest < Minitest::Test
  def test_full_example
    code = <<~CODE
      package example;

      /**
      * Multiline comment
      */

      //Inline comment

      /* Block comment */

      import java.io.BufferedReader;
      import java.io.IOException;
      import java.io.InputStreamReader;
      import java.util.*;
      import java.util.stream.Collectors;

      public class Solution {
        public static BufferedReader in = new BufferedReader(new InputStreamReader(System.in));
        public static void main(String[] args) throws Exception {
          var num = readInt();
          System.out.println(num);
        }
        private static int readInt() throws IOException {
          return Integer.parseInt(in.readLine());
        }
      }
    CODE

    expected = <<~CODE
      public class Solution {
        public static BufferedReader in = new BufferedReader(new InputStreamReader(System.in));
        public static void main(String[] args) throws Exception {
          var num = readInt();
          System.out.println(num);
        }
        private static int readInt() throws IOException {
          return Integer.parseInt(in.readLine());
        }
      }
    CODE

    assert_equal expected, SnippetExtractor::ExtractSnippet.(code, :java)
  end

  def test_extended_sample
    code = <<~CODE
      package example;

      /**
      * Multiline comment
      */

      //Inline comment

      /* Block comment */

      import java.io.BufferedReader;
      import java.io.IOException;
      import java.io.InputStreamReader;
      import java.util.*;
      import java.util.stream.Collectors;

      public class Solution {//Commentscomments
        /*I like to put my comments
        in the middle of things*/
        public static BufferedReader in = new BufferedReader(new InputStreamReader(System.in));
        public static void main(String[] args) throws Exception {//Throwing Exception instead of IOException
          var num = readInt();
          System.out.println(num);
        }
        /* Hi */
        private /*Hi again*/static int readInt() throws IOException {
          return Integer.parseInt(in.readLine());
        }
      }
    CODE

    expected = <<~CODE
      public class Solution {
        public static BufferedReader in = new BufferedReader(new InputStreamReader(System.in));
        public static void main(String[] args) throws Exception {
          var num = readInt();
          System.out.println(num);
        }
        private static int readInt() throws IOException {
          return Integer.parseInt(in.readLine());
        }
      }
    CODE

    assert_equal expected, SnippetExtractor::ExtractSnippet.(code, :java)
  end
end
