require "test_helper"

module SnippetExtractor
  module Languages
    class JavaTest < Minitest::Test
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

              var cases = readInt();

              for (int caseN = 0; caseN < cases; caseN++) {
                var data = readInt();
                System.out.println(data);
              }
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

              var cases = readInt();

              for (int caseN = 0; caseN < cases; caseN++) {
                var data = readInt();
                System.out.println(data);
              }
            }

            private static int readInt() throws IOException {
              return Integer.parseInt(in.readLine());
            }
          }
        CODE

        assert_equal expected, ExtractSnippet.(code, :java)
      end
    end
  end
end
