module SnippetExtractor
  module Extended
    class SyntaxTrieFactory
      include Mandate

      initialize_with :rules

      def call
        trie = SyntaxTrie.new(SyntaxTrieNode.new({}, "", nil))
        rules.each { |rule| add_rule(trie, rule) }

        trie
      end

      def add_rule(trie, rule)
        word = get_word_from_rule(rule)

        set_next_node(trie.root, word, rule)
      end

      def get_word_from_rule(rule)
        rule = rule.start_rule if rule.is_a? MultilineRule

        !rule.whole_word? ? rule.word : " #{rule.word} "
      end

      def set_next_node(node, word, rule)
        if word.empty?
          handle_rule_placement node, rule
          return
        end

        next_letter = word[0]
        unless node.mapping.key? next_letter
          node.mapping[next_letter] = SyntaxTrieNode.new({}, node.word + next_letter, nil)
        end

        set_next_node(node.mapping[next_letter], word[1..], rule)
      end

      def handle_rule_placement(node, rule)
        if node.action.nil?
          set_rule node, rule
          return
        end

        unless are_compatible? node.action, rule
          raise "Mapping conflict: #{node.word} has action #{node.action}, but #{rule} tries to overwrite it" end

        merge_rule node, rule
      end

      def are_compatible?(action, rule)
        case rule
        when MultilineRule then multilines_compatible? action, rule
        when SimpleRule then single_lines_compatible? action, rule
        end
      end

      def multilines_compatible?(action, rule)
        rule.is_a?(MultilineRule) && action.is_a?(Multi) && action.start_action == get_action_from(rule.start_rule)
      end

      def single_lines_compatible?(action, rule)
        action == get_action_from(rule)
      end

      def set_rule(node, rule)
        node.action = get_action_from(rule)
      end

      def merge_rule(node, rule)
        # We only merge compatible multiline rules. Simple rules are only mergeable if they are the same
        add_rule node.action.syntax_trie, rule.end_rule if node.action.is_a? Multi
      end

      def get_action_from(rule)
        case rule
        when MultilineRule then Multi.new(get_action_from(rule.start_rule), SyntaxTrieFactory.([rule.end_rule]))
        when SimpleRule
          if rule.skip_line?
            Line.new(rule.word)
          else
            Just.new(rule.word)
          end
        end
      end
    end

    # Trie nodes
    SyntaxTrie = Struct.new(:root)
    SyntaxTrieNode = Struct.new(:mapping, :word, :action)

    # Actions
    Just = Struct.new(:original_word)
    Line = Struct.new(:original_word)
    Multi = Struct.new(:start_action, :syntax_trie)
  end
end
