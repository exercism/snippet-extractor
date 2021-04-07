require 'mandate'

require "zeitwerk"
loader = Zeitwerk::Loader.for_gem
loader.setup

module SnippetExtractor
  def self.extract(language_slug, submission_path, output_path)
    submission_pathname = Pathname.new(submission_path)
    output_pathname = Pathname.new(output_path)

    #ExtractSnippet.(exercise_slug, submission_pathname, output_pathname)
  end
end
