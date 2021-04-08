require "test_helper"

module SnippetExtractor
  module Languages
    class CsharpTest < Minitest::Test
      def test_full_example
        code = <<~CODE

          // Skipping imports
          import * as example from 'example.js'
          import *
            as example
            from 'example.js'

          import { get_data, get_data2 } from 'example.js

          /// Saying things over
          /// multiple lines of code

          /* Multiline comments */
          /**
           * Multiline comments 2
           *
           */

           let numberRegexp = /^[0-9]+$/;
           class ZipCodeValidator {
             isAcceptable(s: string) {
               return s.length === 5 && numberRegexp.test(s);
             }
           }
           export = ZipCodeValidator;
        CODE

        expected = <<~CODE
          let numberRegexp = /^[0-9]+$/;
           class ZipCodeValidator {
             isAcceptable(s: string) {
               return s.length === 5 && numberRegexp.test(s);
             }
           }
           export = ZipCodeValidator;
        CODE

        assert_equal expected, ExtractSnippet.(code, :csharp)
      end
    end
  end
end
