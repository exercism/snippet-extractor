module SnippetExtractor
  module Extended
    class CodeParser
      include Mandate

      initialize_with :code, :syntax_trie

      def call
        return code
      end
    end
  end
end
