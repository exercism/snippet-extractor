;;;
;;; Example of how to convert aribic numerals to roman numerals
;;;
(defpackage #:roman-numerals
  (:use #:cl)
  (:export #:romanize))

(in-package #:roman-numerals)

(defun romanize (number)
  (format nil "~@R" number))
