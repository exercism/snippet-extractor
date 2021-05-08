module SnippetExtractor
  module Extended
    class ParseCode
      include Mandate

      def initialize(code, syntax_trie, arguments = [])
        @code = code
        @syntax_trie = syntax_trie
        @stop_at_first_loc = arguments.include?(STOP_AT_FIRST_LINE_OF_CODE)

        @scan_index = 0

        @current_action = nil
        @queued_multiline = nil

        @saved_lines = []
        generate_new_line!
      end

      def call
        action, skipped = try_match_first_word
        execute_action(action, skipped) if action

        follow_strategy until is_finished?

        save_last_line!

        saved_lines.map(&:content)
      end

      protected
      attr_accessor :code, :syntax_trie, :scan_index, :current_syntax_node, :current_line,
                    :current_action, :queued_multiline, :saved_lines

      def try_match_first_word
        return unless syntax_trie.root.has_match?(' ')

        try_match(syntax_trie.root.get_match_node(' '))
      end

      def try_match(from_node = nil)
        return if stop_at_first_loc? && !(saved_lines.empty? && current_line.empty?)

        current_syntax_node = from_node || syntax_trie.root
        scan_lookahead = 0

        until is_finished?(scan_lookahead)
          node = scan_char!(scan_lookahead)
          break unless current_syntax_node.has_match?(node)

          current_syntax_node = current_syntax_node.get_match_node(node)
          scan_lookahead += 1
        end

        [current_syntax_node.action, scan_lookahead]
      end

      def execute_action(action, skipped)
        return if action.nil?

        if action.instance_of?(Multi)
          self.queued_multiline = action
          execute_action(action.start_action, skipped)
          return
        end

        save_if_newline_reached!(skipped)
        current_line.skip!

        if action.instance_of?(Just) ||
           (action.instance_of?(Line) && code[scan_index - 1] == "\n")
          self.current_action = self.queued_multiline
          self.queued_multiline = nil
        else
          self.current_action = action
        end
      end

      def save_if_newline_reached!(size = 1)
        if code[scan_index, size].include?("\n")
          save_current_line!
          generate_new_line!
        end

        increment_scan_index!(size)
      end

      def follow_strategy
        case current_action
        when Line then follow_line_strategy
        when Multi then follow_multi_strategy
        else
          looking_for_match_strategy
        end
      end

      def follow_line_strategy
        if code[scan_index] == "\n"
          self.current_action = self.queued_multiline
          self.queued_multiline = nil
        end

        # We have to check for matches even though the line was skipped.
        # The newline could be the blank space of the next whole word keyword.

        return save_if_newline_reached! if current_action

        looking_for_match_strategy
      end

      def follow_multi_strategy
        action, skipped = try_match(current_action.syntax_trie.root)

        return execute_action(action, skipped) if action

        save_if_newline_reached!
      end

      def looking_for_match_strategy
        action, skipped = try_match
        return execute_action(action, skipped) if action

        current_line.append(code[scan_index])
        save_if_newline_reached!
      end

      def start_at_new_word
        self.current_syntax_node = current_syntax_node.mapping[' '] if current_syntax_node.mapping.key?(' ')
      end

      def stop_at_first_loc?
        !!@stop_at_first_loc
      end

      def is_finished?(lookahead = 0)
        scan_index + lookahead >= code.length
      end

      def scan_char!(lookahead = 0)
        character = code[scan_index + lookahead]

        character.strip.empty? ? ' ' : character.downcase
      end

      def save_current_line!
        # If the current line is not empty, then save it and move on
        add_newline_and_save_line! and return unless current_line.empty?(strip: true)

        # The current line is empty. Sometimes we want to save it, sometimes we don't.
        return if current_line.skip? || saved_lines.empty? || saved_lines.last.empty?(strip: true)

        current_line.strip!
        add_newline_and_save_line!
      end

      def generate_new_line!
        self.current_line = CurrentLine.new(current_action.instance_of?(Multi) && queued_multiline.nil?)
      end

      def add_newline_and_save_line!
        current_line.append("\n") unless current_line.ends_with_newline?
        saved_lines.append(current_line)
      end

      def save_last_line!
        saved_lines.append(current_line) unless current_line.empty?(strip: true)
      end

      def increment_scan_index!(size = 1)
        self.scan_index += size
      end

      STOP_AT_FIRST_LINE_OF_CODE = "stop_at_first_loc".freeze
      private_constant :STOP_AT_FIRST_LINE_OF_CODE

      CurrentLine = Struct.new(:skip) do
        def initialize(skip)
          @content = ""
          @skip = skip
        end

        def content
          @content.freeze
        end

        def skip?
          !!@skip
        end

        def skip!
          @skip = true
        end

        def empty?(strip: false)
          strip ? @content.strip.empty? : @content.empty?
        end

        def strip!
          @content.strip!
        end

        def append(extra)
          @content += extra
        end

        def ends_with_newline?
          @content[-1, 1] == "\n"
        end
      end
      private_constant :CurrentLine
    end
  end
end
