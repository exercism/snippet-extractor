require "test_helper"

module SnippetExtractor
  class LanguagesTest < Minitest::Test
    Dir.glob(File.join(__dir__, '..', 'tests', '*', '*')).each do |test_dir|
      track = File.basename(File.dirname(test_dir))
      test_name = File.basename(test_dir)
      code = File.read(Dir.glob(File.join(test_dir, 'code.*')).first)
      expected = File.read(Dir.glob(File.join(test_dir, 'expected_snippet.*')).first)

      define_method("test_#{track}_#{test_name}") do
        assert_equal expected.chomp(''), SnippetExtractor::ExtractSnippet.(code, track).chomp('')
      end
    end
  end
end
