module SnippetExtractor
  module Extended
    class ExtendedExtractor
      include Mandate

      initialize_with :code, :rules

      def call
        raise 'Given file is not a extended version rule text' unless rules[0].include? "!e"

        CodeParser.new(code, SyntaxTrieFactory.(RuleParser.(rules[1..])), rules[0].split(' ')).parse[0...10]
      end
    end
  end
end
