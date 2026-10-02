;;;; two-fer.scm — Solution for Two-Fer on Exercism

(import (rnrs))

;;; Generate a personalized phrase

;; If a name is provided, two-fer() returns:
;; "One for <name>, one for me."
;;
;; If no name is provided, "you" is used for <name>.
(define (two-fer . maybe-name)
  (let ((name (if (pair? maybe-name) ; in-line comment
                  (car maybe-name)
                  "you")))
    (format #f "One for ~a, one for me." name)))
#|
   Multi-line comments seem uncommon but we should still strip them
|#
