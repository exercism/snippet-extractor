module SnippetExtractor
  module Extended
    class CodeParser
      include Mandate

      initialize_with :code, :syntax_trie

      def call
        parse code, syntax_trie
      end

      def parse(code, syntax_trie)
        parser = initialize_parser code, syntax_trie

        while is_finished? parser

          character = scan parser
          normalized_character = clean character

          if matches_syntax? parser, normalized_character
            store_possible_skip parser, character
            advance_syntax parser, normalized_character
            next
          end

          # Rule
          store_skipped_in_read_line parser
          reset_syntax parser
          if matches_syntax? parser, normalized_character
            store_possible_skip parser, character
            advance_syntax parser, normalized_character
          end
        end
      end

      def initialize_parser(code, syntax_trie)
        parser_data = ParserData.new(code, syntax_trie)
        parser_state = ParserState.new(0, syntax_trie.root, "", "", false)
        parser_output = ParserOutput.new([])

        Parser.new(parser_data, parser_state, parser_output)
      end

      def is_finished?(parser)
        parser.state.scan_index >= parser.data.code.length
      end

      def scan(parser)
        read_char = parser.data.code[parser.state.scan_index]
        parser.scan_index += 1

        read_char
      end

      def normalize(character)
        if character.lstrip.empty? then ' ' else character end
      end

      def matches_syntax?(parser, character)
        parser.state.current_syntax_trie_node.key? character
      end

      def store_possible_skip(parser, character)
        parser.state.skipping_line += character
      end

      def store_skipped_in_read_line(parser)
        parser.current_line += parser.skipping_line
      end

      def advance_syntax(parser, character)
        parser.state.current_syntax_trie_node[character]
      end

      def reset_syntax(parser)
        parser.state.current_syntax_trie_node = parser.data.syntax_trie.root
      end

      Parser = Struct.new(:data, :state, :output)
      ParserData = Struct.new(:code, :syntax_trie)
      ParserState = Struct.new(:scan_index, :current_syntax_trie_node, :current_line, :skipping_line, :multiline_skip?)
      ParserOutput = Struct.new(:read_lines)
    end

  end
end
