module SnippetExtractor
  module Extended
    class ParseRules
      include Mandate

      initialize_with :rule_lines

      def call
        parsed_lines = rule_lines.
          reject { |line| line.strip.empty? }.
          map(&:downcase).
          map(&:rstrip)

        parsed_lines.map do |line|
          line.include?(MULTILINE_TOKEN) ? multiline_rule(line) : simple_rule(line)
        end
      end

      def simple_rule(line)
        word, modifiers = line.split('\\')

        SimpleRule.new(word, modifiers || '')
      end

      def multiline_rule(line)
        start_rule, end_rule = line.split('-->>').map { |rule| simple_rule(rule) }

        MultilineRule.new(start_rule, end_rule)
      end
    end
  end
end
