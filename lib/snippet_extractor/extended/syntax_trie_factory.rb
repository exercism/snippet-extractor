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

          self.rule = transform_rule(map_rule)
        else
          unless mapping.key? map_word[0]
            self.mapping[map_word[0]] =
              SyntaxTrieNode.new({}, self.word + map_word[0], nil)
          end
          self.mapping[map_word[0]].map_word(map_word[1..], map_rule)
        end
      end

      def transform_rule(rule)
        case rule
        when MultilineRule then Multi.new(transform_rule(rule.start_rule), SyntaxTrieFactory.([rule.end_rule]))
        when SimpleRule
          if rule.skip_line?
            Line.new(rule.word)
          else
            Just.new(rule.word)
          end
        end
      end
    end

    # Rules
    Just = Struct.new(:original_word)
    Line = Struct.new(:original_word)
    Multi = Struct.new(:from_rule, :to_syntax_trie)
  end
end
