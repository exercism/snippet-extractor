(import (rnrs))

(define (two-fer . maybe-name)
  (let ((name (if (pair? maybe-name) 
                  (car maybe-name)
                  "you")))
    (format #f "One for ~a, one for me." name)))
