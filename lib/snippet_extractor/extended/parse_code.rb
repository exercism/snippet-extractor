module SnippetExtractor
  module Extended
    class ParseCode
      include Mandate

      STOP_AT_FIRST_LINE_OF_CODE = "stop_at_first_loc".freeze

      def initialize(code, syntax_trie, arguments = [])
        @code = code
        @syntax_trie = syntax_trie
        @arguments = arguments

        @scan_index = 0

        @current_line = ""
        @current_line_has_skip = false
        @current_action = nil
        @queued_multiline = nil

        @saved_lines = []
      end

      def call
        action, skipped = try_match_first_word
        execute_action(action, skipped) unless action.nil?

        follow_strategy until is_finished?

        save_last_line

        self.saved_lines
      end

      protected
      attr_accessor :code, :syntax_trie, :scan_index, :current_syntax_node, :current_line, :current_line_skipped,
                    :current_action, :queued_multiline, :saved_lines, :arguments, :current_line_has_skip

      def try_match_first_word
        try_match(syntax_trie.root.get_match_node(' ')) if syntax_trie.root.has_match?(' ')
      end

      def try_match(from_node = nil)
        if self.arguments.include?(STOP_AT_FIRST_LINE_OF_CODE) && !(self.saved_lines.empty? && self.current_line.empty?)
          return [nil, 0]
        end

        current_syntax_node = from_node || self.syntax_trie.root
        scan_lookahead = 0

        while !is_finished?(scan_lookahead) && current_syntax_node.has_match?(scan_char(scan_lookahead))
          current_syntax_node = current_syntax_node.get_match_node(scan_char(scan_lookahead))
          scan_lookahead += 1
        end

        [current_syntax_node.action, scan_lookahead]
      end

      def execute_action(action, skipped)
        return if action.nil?

        if action.instance_of? Multi
          self.queued_multiline = action
          execute_action(action.start_action, skipped)
          return
        end

        save_if_newline_reached(skipped)
        self.scan_index += skipped
        self.current_line_has_skip = true

        if action.instance_of?(Just) || (action.instance_of?(Line) && code[self.scan_index - 1].include?("\n"))
          self.current_action = self.queued_multiline
          self.queued_multiline = nil
        else
          self.current_action = action
        end
      end

      def save_if_newline_reached(skipped = 1)
        return unless code[self.scan_index, skipped].include?("\n")

        save_current_line
        self.current_line = ""
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
        if action.nil?
          self.current_line = self.current_line + self.code[self.scan_index]
          save_if_newline_reached
          self.scan_index += 1
        else
          execute_action(action, skipped)
        end
      end

      def line_strategy
        if self.code[self.scan_index] == "\n"
          self.current_action = self.queued_multiline
          self.queued_multiline = nil
        end

        # We have to check for matches even though the line was skipped.
        # The newline could be the blank space of the next whole word keyword.
        if self.current_action.nil?
          action, skipped = try_match
          if action.nil?
            self.current_line = self.current_line + self.code[self.scan_index]
            save_if_newline_reached
            self.scan_index += 1
          else
            execute_action(action, skipped)
          end
        else
          save_if_newline_reached
          self.scan_index += 1
        end
      end

      def multi_strategy
        action, skipped = try_match(self.current_action.syntax_trie.root)
        if action.nil?
          save_if_newline_reached
          self.scan_index += 1
        else
          execute_action(action, skipped)
        end
      end

      def start_at_new_word
        self.current_syntax_node = self.current_syntax_node.mapping[' '] if self.current_syntax_node.mapping.key? ' '
      end

      def is_finished?(lookahead = 0)
        self.scan_index + lookahead >= self.code.length
      end

      def scan_char(lookahead = 0)
        character = self.code[self.scan_index + lookahead]

        character.strip.empty? ? ' ' : character.downcase
      end

      def save_current_line
        if self.current_line.strip.empty?
          unless self.current_line_has_skip || self.saved_lines.empty? || self.saved_lines.last.strip.empty?
            self.current_line.strip!
            add_newline_and_save_line
          end
        else
          add_newline_and_save_line
        end
        self.current_line = ""
        self.current_line_has_skip = false unless current_action.instance_of? Multi || queued_multiline.nil?
      end

      def add_newline_and_save_line
        self.current_line += "\n" if self.current_line[-1, 1] != "\n"
        self.saved_lines.append(self.current_line)
      end

      def save_last_line
        self.saved_lines.append(self.current_line) unless self.current_line.strip.empty?
      end
    end
  end
end
