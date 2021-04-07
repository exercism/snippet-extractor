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
          'Content-Type': 'application/plain; charset=utf-8',
          'Content-disposition': 'attachment;snippet.txt'
        },
        isBase64Encoded: false,
        body: snippet
      }
    end

    def source_code
      event['source_code']
    end

    def language
      event['language']
    end
  end
end
