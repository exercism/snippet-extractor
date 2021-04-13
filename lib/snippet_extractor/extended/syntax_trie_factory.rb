module SnippetExtractor
  module Extended
    class SyntaxTrieFactory
      include Mandate

      initialize_with :rules

      def call
        SyntaxTrie.new
      end
    end

    SyntaxTrie = Struct.new(:root)
  end
end
