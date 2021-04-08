require "test_helper"

module SnippetExtractor
  module Languages
    class JavascriptTest < Minitest::Test
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

          function getJSON(url, callback) {
            let xhr = new XMLHttpRequest();
            xhr.onload = function () {
              callback(this.responseText)
            };
            xhr.open('GET', url, true);
            xhr.send();
          }

          export function getUsefulContents(url, callback) {
            getJSON(url, data => callback(JSON.parse(data)));
          }

          getUsefulContents('http://www.example.com',
            data => { doSomethingUseful(data); });
        CODE

        expected = <<~CODE
          function getJSON(url, callback) {
            let xhr = new XMLHttpRequest();
            xhr.onload = function () {
              callback(this.responseText)
            };
            xhr.open('GET', url, true);
            xhr.send();
          }
          export function getUsefulContents(url, callback) {
            getJSON(url, data => callback(JSON.parse(data)));
          }
          getUsefulContents('http://www.example.com',
            data => { doSomethingUseful(data); });
        CODE

        assert_equal expected, ExtractSnippet.(code, :javascript)
      end
    end
  end
end
