(defun test-+ ()
  (and
   (= (+ 1 2) 3)
   (= (+ 1 2 3) 6)
   (= (+ -1 -3) -4)))

(defun test-+with-format ()
  (report-result  (= (+ 1 2) 3) '(= (+ 1 2) 3))
  (report-result (= (+ 1 2 3) 6) '(= (+ 1 2 3) 6))
  (report-result (= (+ -1 -3) -4) '(= (+ -1 -3) -4)))

(defun report-result (result form)
  (format t "~:[FAIL~;pass~] ... ~a; ~a~%" result *test-name* form)
  result)

;(defmacro check (form)
; `(report-result ,form ',form))

;(defun test-* ()
;  (check (= (* 1 2) 2))
;  (check (= (* 2 3) 6))
;  (check (= (* 3 4) 12)))

(defmacro with-gensyms ((&rest names) &body body)
  `(let ,(loop for n in names collect `(,n (gensym)))
     ,@body))

(defmacro combine-results (&body forms)
  (with-gensyms (result)
    `(let ((,result t))
       ,@(loop for f in forms collect `(unless ,f (setf ,result nil)))
       ,result)))


(defmacro check (&body forms)
  `(combine-results
     ,@(loop for f in forms collect `(report-result ,f ',f))))

(deftest test-* ()
  (check
    (= (* 2 2) 4)
    (= (* 3 3) 9)))

(deftest test-arithemetic ()
  (combine-results
    (test-+)
    (test-*)))

(defvar *test-name* nil)

(defmacro deftest (name parameters &body body)
  `(defun ,name ,parameters
     (let ((*test-name* (append *test-name* (list ',name)))) ,@body)))

(deftest test-+-new ()
  (check
    (= (+ 1 1) 2)))
