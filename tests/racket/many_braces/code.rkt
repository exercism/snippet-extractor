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
