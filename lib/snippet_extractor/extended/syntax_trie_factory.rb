module SnippetExtractor
  module Extended
    class SyntaxTrieFactory
      include Mandate

      initialize_with :rules

      def call
        SyntaxTrie.new
      end
    end

    # Trie nodes
    SyntaxTrie = Struct.new(:root)

    # Target actions
    LineSkip = Struct.new(:flag_list)
  end
end
