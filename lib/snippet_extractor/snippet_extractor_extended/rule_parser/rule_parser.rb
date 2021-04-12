module SnippetExtractorExtended
  class RuleParser
    include Mandate

    initialize_with :rule_text

    def call
      rules = []

      unless rule_text.empty?
        rules.append SimpleRule.new(rule_text.rstrip)
      end

      rules
    end
  end
end
