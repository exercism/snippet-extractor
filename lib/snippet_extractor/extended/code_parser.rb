module SnippetExtractor
  module Extended
    class CodeParser
      def initialize(code, syntax_trie)
        @code = code
        @syntax_trie = syntax_trie

        @scan_index = 0

        @current_line = ""
        @current_action = nil

        @saved_lines = []
      end

      def parse
        action, skipped = try_match_first_word
        execute_action(action, skipped) unless action.nil?

        follow_strategy while !is_finished?

        save_current_line

        self.saved_lines
      end

      private
      attr_accessor :code, :syntax_trie, :scan_index, :current_syntax_node, :current_line, :current_line_skipped,
                    :current_action, :saved_lines

      def try_match_first_word
        try_match(syntax_trie.root.get_match_node(' ')) if syntax_trie.root.has_match?(' ')
      end

      def try_match(from_node=nil)
        current_syntax_node = from_node || self.syntax_trie.root
        scan_lookahead = 0

        while !is_finished?(scan_lookahead) && current_syntax_node.has_match?(scan_char(scan_lookahead))
          current_syntax_node = current_syntax_node.get_match_node(scan_char(scan_lookahead))
          scan_lookahead += 1
        end

        [current_syntax_node.action, scan_lookahead]
      end

      def execute_action(action, skipped)
        unless action.nil?
          save_if_newline_reached(skipped)
          self.scan_index += skipped
          unless action.instance_of? Just
            self.current_action = action
          else
            self.current_action = nil
          end

        end
      end

      def save_if_newline_reached(skipped=1)
        if code[self.scan_index, skipped].include? "\n"
          save_current_line
          self.current_line = ""
        end
      end

      def follow_strategy
        case self.current_action
        when Line then line_strategy
        when Multi then multi_strategy
        else
          looking_for_match_strategy
        end
      end

      def looking_for_match_strategy
        action, skipped = try_match
        unless action.nil? then execute_action(action, skipped)
        else
          self.current_line = self.current_line + self.code[self.scan_index]
          save_if_newline_reached
          self.scan_index += 1
        end
      end

      def line_strategy
        if self.code[self.scan_index] == "\n"
          self.current_action = nil
        end
        save_if_newline_reached
        self.scan_index += 1
      end

      def multi_strategy
        action, skipped = try_match(self.current_action.syntax_trie.root)
        unless action.nil? then execute_action(action, skipped)
        else
          save_if_newline_reached
          self.scan_index += 1
        end
      end

      def start_at_new_word
        self.current_syntax_node = self.current_syntax_node.mapping[' '] if self.current_syntax_node.mapping.key? ' '
      end

      def is_finished?(lookahead=0)
        self.scan_index + lookahead >= self.code.length
      end

      def scan_char(lookahead=0)
        self.code[self.scan_index + lookahead]
      end

      def save_current_line
        unless self.current_line.strip.empty?
          self.current_line += "\n" if self.current_line[-1, 1] != "\n"
          self.saved_lines.append(self.current_line)
        end
        self.current_line = ""
      end
    end

  end
end
