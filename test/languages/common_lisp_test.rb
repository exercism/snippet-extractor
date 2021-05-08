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

        assert_equal expected, ExtractSnippet.(code, 'common-lisp')
      end

      def test_extended_example
        # Code snippet taken from https://stackoverflow.com/a/6365579/7948842 by acelent
        code = <<~CODE
          ;;;; Math Utilities

          ;;; FIB computes the the Fibonacci function in the traditional
          ;;; recursive way.

          (defun fib (n)
            (check-type n integer)
            ;; At this point we're sure we have an integer argument.
            ;; Now we can get down to some serious computation.
            (cond ((< n 0)#|
              MULTILINE COMMENTS TOO|#
                   ;; Hey, this is just supposed to be a simple example.
                   ;; Did you really expect me to handle the general case?
                   (error "FIB got ~D as an argument." n))
                  ((< n 2) n)             ;fib[0]=0 and fib[1]=1
                  ;; The cheap cases didn't work.
                  ;; Nothing more to do but recurse.
                  (t (+ (fib (- n 1))     ;The traditional formula
                        (fib (- n 2)))))) ; is fib[n-1]+fib[n-2].
        CODE

        expected = <<~CODE
          (defun fib (n)
            (check-type n integer)
            (cond ((< n 0)
                   (error "FIB got ~D as an argument." n))
                  ((< n 2) n)#{'             '}
                  (t (+ (fib (- n 1))#{'     '}
                        (fib (- n 2))))))#{' '}
        CODE

        assert_equal expected, ExtractSnippet.(code, 'common-lisp')
      end
    end
  end
end
