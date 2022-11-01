require "test_helper"
module SnippetExtractor
  module Languages
    class PerlTest < Minitest::Test
      def test_all
        code = <<~CODE
          package HelloWorld;

          use v5.36;
          use 5.036;

          use strict;
          use warnings;
          use feature qw<say>;

          use builtin qw<true>;
          no warnings qw<experimental::builtin>;

          use experimental qw<refaliasing>;

          use Exporter qw<import>;
          our @EXPORT_OK = qw<hello>;

          # test comment
          sub hello {
              return 'Hello, World!';
          }
        CODE
        expected = <<~CODE
          sub hello {
              return 'Hello, World!';
          }
        CODE
        assert_equal expected, ExtractSnippet.(code, 'perl5')
      end
    end
  end
end
