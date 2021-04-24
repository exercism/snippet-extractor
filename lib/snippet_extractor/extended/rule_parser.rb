module SnippetExtractor
  module Extended
    MULTILINE_TOKEN = '-->>'.freeze
    PARTIAL_MODIFIER  = "p".freeze
    JUST_MODIFIER     = "j".freeze

    SimpleRule = Struct.new(:word, :modifiers) do
      def whole_word?
        !modifiers.include? PARTIAL_MODIFIER
      end

      def skip_line?
        !modifiers.include? JUST_MODIFIER
      end
    end
    MultilineRule = Struct.new(:start_rule, :end_rule)

    class RuleParser
      include Mandate

      initialize_with :rule_lines

      def call
        rule_lines.
          reject { |line| line.strip.empty? }.
          map(&:downcase).
          map { |line| line.delete("\n") }.
          map do |line|
            if line.include? MULTILINE_TOKEN
              multiline_rule line
            else
              simple_rule line
            end
          end
      end

      def simple_rule(line)
        word, modifiers = line.split('\\')
        modifiers = '' if modifiers.nil?

        SimpleRule.new(word, modifiers)
      end

      def multiline_rule(line)
        start_rule, end_rule = line.split('-->>').map { |rule| simple_rule rule }

        MultilineRule.new(start_rule, end_rule)
      end
    end
  end
end
