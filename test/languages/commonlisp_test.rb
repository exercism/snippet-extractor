require "test_helper"

module SnippetExtractor
  module Languages
    class CommonLispTest < Minitest::Test
      def test_full_example
        code = <<~CODE
          ;;;
          ;;; Example of how to convert aribic numerals to roman numerals
          ;;;
          (defpackage #:roman-numerals
            (:use #:cl)
            (:export #:romanize))

          (in-package #:roman-numerals)

          (defun romanize (number)
            (format nil "~@R" number))
        CODE

        expected = <<~CODE
          (defpackage #:roman-numerals
            (:use #:cl)
            (:export #:romanize))

          (in-package #:roman-numerals)

          (defun romanize (number)
            (format nil "~@R" number))
        CODE

        assert_equal expected, ExtractSnippet.(code, :commonlisp)
      end
    end
  end
end
