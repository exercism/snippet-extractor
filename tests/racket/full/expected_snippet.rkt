(define gigasecond 1000000000)

(define (add-gigasecond dt) 
  (seconds->date
    (+ (date->seconds dt) gigasecond)))
