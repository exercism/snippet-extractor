require "test_helper"
require 'json'

module SnippetExtractor
  class ProcessRequestTest < Minitest::Test
    def test_e2e
      code = <<~CODE.strip
        # This is a file
        Some code
      CODE

      snippet = <<~CODE.strip
        Some code
      CODE

      event = JSON.parse({
        queryStringParameters: {
          source_code: code,
          language: :ruby
        }
      }.to_json)

      expected = {
        statusCode: 200,
        headers: {
          'Content-Length': 9,
          'Content-Type': 'application/plain; charset=utf-8'
        },
        isBase64Encoded: false,
        body: snippet.rstrip
      }
      assert_equal expected, ProcessRequest.(event, {})
    end
  end
end
