module SnippetExtractor
  class ProcessRequest
    include Mandate

    initialize_with :event, :context

    def call
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
      body[:source_code]
    end

    def language
      body[:language]
    end

    memoize
    def body
      JSON.parse(event['body'], symbolize_names: true)
    end
  end
end
