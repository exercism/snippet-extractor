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
          (provide (contract-out
            [add-gigasecond (-> date? date?)]))
          ; ^ Multiline provide
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
    end
  end
end
