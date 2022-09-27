require "test_helper"

module SnippetExtractor
  module Languages
    class AbapTest < Minitest::Test
      def test_simple_example
        code = <<~CODE
          method run.
          * delete me
            write 'Hello World!'.
            "another comment
          endmethod.
        CODE

        expected = <<~CODE
          method run.
            write 'Hello World!'.
          endmethod.
        CODE

        assert_equal expected, ExtractSnippet.(code, :abap)
      end

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
          * comment1
              write 'Hello world!'.
              "comment2
            endmethod.
          endclass.
        CODE

        expected = <<~CODE
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
