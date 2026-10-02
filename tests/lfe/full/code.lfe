;;;; File-level comment

;;; Section comment

;; Single-line comment

#| Multi-line
   block comment |#

(defmodule two-fer
  (export (two-fer 1)))

(defun two-fer
  (("")
   (two-fer "y;o;u")) ; inline comment
  ((name)
   (++ "One for " name ", one for me.")))
