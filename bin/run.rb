#!/usr/bin/env ruby

require(File.expand_path(File.join("..", "lib", "snippet_extractor")))

event = JSON.parse(ARGV[0])
response = SnippetExtractor.process(event:, context: {})
puts response.to_json
