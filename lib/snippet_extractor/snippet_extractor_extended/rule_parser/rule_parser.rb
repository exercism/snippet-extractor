module SnippetExtractorExtended

  SimpleRule = Struct.new(:word, :modifiers)

  class RuleParser
    include Mandate

    initialize_with :rule_text

    def call
      rule_text.lines
          .reject {|line| line.strip.empty?}
          .map {|line| line.gsub(/\n/, '')}
          .map {|line| line.split('\\')}
          .map do |word, modifiers|
            modifiers = '' if modifiers.nil?
            SimpleRule.new(word, modifiers)
          end
    end
  end
end
