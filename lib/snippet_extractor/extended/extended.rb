module SnippetExtractor
  module Extended
    class ExtractSnippetExtended
      include Mandate

      initialize_with :language

      def call
        raise 'Given file is not a extended version rule text' if rule_text[0] != "!e"

        CodeParser.(code, SintaxTrie.(RuleParser.(rule_text)))[0..10]
      end

      memoize
      def rule_text
        slug = language.to_s.gsub(/[^a-z0-9-]/, '')
        File.read(File.expand_path("../../languages/#{slug}.txt", __FILE__)).lines.map(&:rstrip)
      end
    end
  end
end
