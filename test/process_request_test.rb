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
        body: {
          language: :ruby,
          source_code: code
        }.to_json
      }.to_json)

      expected = {
        statusCode: 200,
        statusDescription: "200 OK",
        headers: { 'Content-Type': 'text/plain' },
        isBase64Encoded: false,
        body: snippet.rstrip
      }
      assert_equal expected, ProcessRequest.(event, {})
    end
  end
end
