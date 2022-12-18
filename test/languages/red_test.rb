require "test_helper"

module SnippetExtractor
  module Languages
    class RedTest < Minitest::Test
      def test_full_example
        code = <<~CODE
          Red [] ; a comment

          ; single line comment
          x: 1 ; line comment 1
          x: 2   ;-- line comment 2
          x: 3		;@@ line comment 3

          comment ['this
          	'is 'multiline
          	'comment]
          comment   {and this
          	as well}

          function add100 [x [integer!]] [
          	" this should not count as comment "
          	{ and neither
          	 this }
          ]
        CODE

        expected = <<~CODE
          x: 1
          x: 2
          x: 3
          function add100 [x [integer!]] [
          	" this should not count as comment "
          	{ and neither
          	 this }
          ]
        CODE

        assert_equal expected, ExtractSnippet.(code, :red)
      end
    end
  end
end
