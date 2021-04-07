load File.expand_path('../../lib/snippet_extractor.rb', __FILE__)

SnippetExtractor.extract(ARGV[0], ARGV[1], ARGV[2])
