module SnippetExtractor
  module Extended
    MULTILINE_TOKEN     = '-->>'.freeze
    PARTIAL_MODIFIER    = "p".freeze
    JUST_MODIFIER       = "j".freeze
    REPITITION_MODIFIER = "+".freeze

    # Rules
    SimpleRule = Struct.new(:word, :modifiers) do
      def whole_word?
        !modifiers.include?(PARTIAL_MODIFIER)
      end

      def skip_line?
        !modifiers.include?(JUST_MODIFIER)
      end
    end
    MultilineRule = Struct.new(:start_rule, :end_rule)

    # Trie nodes
    SyntaxTrie = Struct.new(:root)

    Node = Struct.new(:mapping, :word, :action) do
      def has_match?(character)
        mapping.key?(character) or (mapping.key? REPITITION_MODIFIER and character == word[-1, 1])
      end

      def get_match_node(character)
        return mapping[REPITITION_MODIFIER] if mapping.key?(REPITITION_MODIFIER) && (character == word[-1, 1])

        mapping[character]
      end
    end

    RepeatNode = Struct.new(:mapping, :word, :action) do
      def has_match?(character)
        mapping.key? character or character == word[-2, 1]
      end

      def get_match_node(character)
        return self if character == word[-2, 1]

        mapping[character]
      end
    end

    # Actions
    Just = Struct.new(:original_word)
    Line = Struct.new(:original_word)
    Multi = Struct.new(:start_action, :syntax_trie)
  end
end
