(defun list--partition (list cell-size)
  (cl-loop for index from 0
           ;; we can ignore the rest because this can never contain our sublist
           while (<= index (- (length list) cell-size))
           collect (cl-subseq list index (+ index cell-size))))

(defun list-sublist (list1 list2)
  (cl-some (lambda (partition)
             (equal list1 partition))
           (list--partition list2 (length list1))))
