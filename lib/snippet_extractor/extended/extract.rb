module SnippetExtractor
  module Extended
    class Extract
      include Mandate

      initialize_with :code, :rules_file

      def call
        raise 'Given file is not a extended version rule text' unless rules_file[0].start_with? "!e"

        args = rules_file[0].split(' ')
        rules = ParseRules.(rules_file[1..])
        syntax_trie = BuildSyntaxTrie.(rules)
        ParseCode.(code, syntax_trie, args)[0...10]
      end
    end
  end
end
