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
