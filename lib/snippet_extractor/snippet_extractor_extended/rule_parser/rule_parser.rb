module SnippetExtractorExtended
  class RuleParser
    include Mandate

    initialize_with :rule_text

    def call
      return []
    end
  end
end
