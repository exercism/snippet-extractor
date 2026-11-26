require 'mandate'
require 'json'

require "zeitwerk"
loader = Zeitwerk::Loader.for_gem
loader.setup

module SnippetExtractor
  # The most lines a snippet can have.
  MAX_LINES = 15

  # The most characters a line in a snippet can have. Longer lines are cut at this length.
  MAX_LINE_LENGTH = 200

  def self.process(event:, context:) = ProcessRequest.(event, context)
end
