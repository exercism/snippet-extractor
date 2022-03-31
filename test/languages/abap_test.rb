require "test_helper"

module SnippetExtractor
  module Languages
    class AbapTest < Minitest::Test

      # This fails with stop_at_first_loc
      def test_simple_example
        code = <<~CODE
          method run.
          * delete
            write 'Hello World!'.
          endmethod.
        CODE

        expected = <<~CODE
          method run.
            write 'Hello World!'.
          endmethod.
        CODE

        assert_equal expected, ExtractSnippet.(code, :abap)
      end

      # This fails with or without stop_at_first_loc as both sections will always match
      def test_strip_definition
        code = <<~CODE
          class foo definition. 
            public section.
              methods run.
            private section.
              data stuff type standard table of string.
          endclass.

          class foo implementation. 
            method run.
              write 'Hello world!'.
            endmethod.
          endclass.
        CODE

        expected = <<~CODE
          class foo implementation. 
            method run.
              write 'Hello world!'.
            endmethod.
          endclass.
        CODE

        assert_equal expected, ExtractSnippet.(code, :abap)
      end

    end
  end
end
