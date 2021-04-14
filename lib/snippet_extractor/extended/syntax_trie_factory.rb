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

        word = get_word_from_rule(rule)

        self.root.map_word(word, rule)
      end

      def get_word_from_rule(rule)
        rule = rule.start_rule if rule.is_a? MultilineRule

        !rule.whole_word? ? rule.word : " #{rule.word} "
      end
    end

    SyntaxTrieNode = Struct.new(:mapping, :word, :rule) do
      def map_word(map_word, map_rule)
        if map_word.empty?
          if self.rule.nil?
            self.rule = transform_rule(map_rule)
          elsif map_rule.is_a?(MultilineRule) && self.rule.is_a?(Multi)
            unless self.rule.from_rule == transform_rule(map_rule.start_rule)
              raise "Mapping conflict: #{self.word} has rule #{self.rule}, but #{map_rule} tries to overwrite it" end

            self.rule.syntax_trie.add(map_rule.end_rule)
          elsif self.rule != transform_rule(map_rule)
            raise "Mapping conflict: #{self.word} has rule #{self.rule}, but #{map_rule} tries to overwrite it"
          end
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
    Multi = Struct.new(:from_rule, :syntax_trie)
  end
end
