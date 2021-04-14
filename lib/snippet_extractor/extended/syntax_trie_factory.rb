module SnippetExtractor
  module Extended
    class SyntaxTrieFactory
      include Mandate

      initialize_with :rules

      def call
        # Not happy with this struct instantiate. Move to other class maybe?
        trie = SyntaxTrie.new(nil)
        rules.each { |rule| trie.add(rule) }

        trie
      end
    end

    # Trie nodes
    SyntaxTrie = Struct.new(:root) do
      def add(rule)
        self.root = SyntaxTrieNode.new({}, "", nil) if root.nil?
        word = !rule.whole_word? ? rule.word : " #{rule.word} "
        self.root.map_word(word, rule)
      end
    end

    SyntaxTrieNode = Struct.new(:mapping, :word, :rule) do
      def map_word(map_word, map_rule)
        if map_word.empty?
          unless self.rule.nil?
            raise "Mapping conflict: #{word} has rule #{rule}, but #{map_rule} tries to overwrite it" end

          self.rule = map_rule
        else
          unless mapping.key? map_word[0]
            self.mapping[map_word[0]] =
              SyntaxTrieNode.new({}, self.word + map_word[0], nil)
          end
          self.mapping[map_word[0]].map(map_word[1..], map_rule)
        end
      end
    end
  end
end
