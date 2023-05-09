require "test_helper"

module SnippetExtractor
  module Languages
    class BallerinaTest < Minitest::Test
      def test_full_example
        code = <<~CODE
          import ballerina/io

          // Package gigasecond constains functionality to add a gigasecond
          // to a period of time

          # Add one billion seconds to a time
          #
          # + timestamp - a string representing the starting time
          # + return - a string representing the end time
          function addGigasecond(string timestamp) returns string {
              Utc epoch = check time:utcFromString(timestamp);
              return epoch.utcAddSeconds(1000000000).utcToString();
          }
        CODE

        expected = <<~CODE
          function addGigasecond(string timestamp) returns string {
              Utc epoch = check time:utcFromString(timestamp);
              return epoch.utcAddSeconds(1000000000).utcToString();
          }
        CODE

        assert_equal expected, ExtractSnippet.(code, :ballerina)
      end

      def test_stop_at_first_loc
        code = <<~CODE
          import ballerina/io

          // Package gigasecond constains functionality to add a gigasecond
          // to a period of time

          # a Doc Comment
          function addGigasecond(string timestamp) returns string {
              // expects input in RFC 3339 format (e.g., 2007-12-03T10:15:30.00Z)
              Utc epoch = check time:utcFromString(timestamp);
              return epoch.utcAddSeconds(1000000000).utcToString();
          }
        CODE

        expected = <<~CODE
          function addGigasecond(string timestamp) returns string {
              // expects input in RFC 3339 format (e.g., 2007-12-03T10:15:30.00Z)
              Utc epoch = check time:utcFromString(timestamp);
              return epoch.utcAddSeconds(1000000000).utcToString();
          }
        CODE

        assert_equal expected, ExtractSnippet.(code, :ballerina)
      end
    end
  end
end
