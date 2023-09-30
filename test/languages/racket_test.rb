require "test_helper"

module SnippetExtractor
  module Languages
    class RacketTest < Minitest::Test
      def test_full_example
        code = <<~CODE
          #lang racket
          #| This will
          test if (define something)
          will be deleted in block comments?|#

          (provide add-gigasecond)
          ; only comment in a line
          (require racket/date)
          ;(provide (contract-out
          ;  [add-gigasecond (-> date? date?)]))
          ; ^ Multiline provide no solution yet to conquer that 
          (define gigasecond 1000000000)

          (define (add-gigasecond dt) ; comment after important stuff
            (seconds->date
              (+ (date->seconds dt) gigasecond)))
        CODE

        expected = <<~CODE
          (define gigasecond 1000000000)
          
          (define (add-gigasecond dt) 
            (seconds->date
              (+ (date->seconds dt) gigasecond)))
        CODE

        assert_equal expected, ExtractSnippet.(code, :racket)
      end

      def test_many_braces_example
        code = <<~CODE
          #lang racket

          (provide score)
          
          (define score (scrabble-score
                        (1 A E I O U L N R S T)
                        (2 D G)
                        (8 J X)
                        (10 Q Z)))
          (define-syntax (scrabble-score stx)
            (syntax-case stx ()
              [(_ (num char ...) ...)
              #'(lambda (word)
                  (apply + (map (lambda (s)
                                  (cond
                                    [(member (string-upcase (string s))
                                              (list (symbol->string (quote char)) ...)) num] ...
                                    [else 0]))
                                (string->list word))))]))
        CODE

        expected = <<~CODE         
          (define score (scrabble-score
                        (1 A E I O U L N R S T)
                        (2 D G)
                        (8 J X)
                        (10 Q Z)))
          (define-syntax (scrabble-score stx)
            (syntax-case stx ()
              [(_ (num char ...) ...)
              #'(lambda (word)
                  (apply + (map (lambda (s)
        CODE

        assert_equal expected, ExtractSnippet.(code, :racket)
      end
    end
  end
end