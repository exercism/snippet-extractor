module SnippetExtractor
  class ProcessRequest
    include Mandate

    initialize_with :event, :context

    def call
      p event
      p context
      snippet = ExtractSnippet.(source_code, language)

      {
        statusCode: 200,
        headers: {
          'Content-Length': snippet.bytesize,
          'Content-Type': 'application/plain; charset=utf-8'
        },
        isBase64Encoded: false,
        body: snippet
      }
    end

    def source_code
      event['queryStringParameters']['source_code']
    end

    def language
      event['queryStringParameters']['language']
    end
  end
end
