;Mary Taft, Period 9

;1.)
(define (Pellmod n)
  (cond ((= n 1) 1)
        ((= n 2) 3)
        (else (+ (* 2 (Pellmod (- n 1)))
                 (* 3 (Pellmod (- n 2)))))))

;2.)
(define (myquotient n d)
  (cond ((< n d) 0)
        ((= n d) 1)
        (else (+ 1 (myquotient (- n d) d)))))

;3.)
(define (mymodulo n d)
  (if (< n d)
      n
      (mymodulo (- n d) d)))

;4.)
(define (sumDigits n)
  (if (< n 10)
      n
      (+ (modulo n 10) (sumDigits (quotient n 10)))))

;6.)
;a.)
;(A 2 4) 
;--> (cond #f 
;          #f
;          #f 
;          (else (A (- 2 1) (- 4 1))))
;--> (A 1 3)
;--> (cond #f
;          #f
;          #f
;          (else (A (- 1 1) (- 3 1))))
;--> (A 0 2)
;--> (cond #f
;          ((= x 0) (* 2 2)))
;--> 4

;b.)
;(A 1 9) 
;--> (cond #f
;          #f
;          #f
;          (else (A (- 1 1) (- 9 1))))
;--> (A 0 8)
;--> (cond #f
;          ((= x 0) (* 2 8)))
;--> 16

;c.)
;(A 10 2)
;--> (cond #f 
;          #f
;          #f 
;          (else (A (- 10 1) (- 2 1))))
;--> (A 9 1)
;--> (cond #f 
;          #f
;          ((= y 1) (* x (+ x 2))))
;--> (* 9 (+ 9 2))
;--> 99

;7.)
(define (exponent b n)
  (cond ((= n 0) 1)
        ((= n 1) b)
        (else (* b (exponent b (- n 1))))))

;8.)
(define (sumEvens a b)
  (cond ((> a b) 0)
        ((and (= a b) (odd? a)) 0)
        ((even? a) (+ a (sumEvens (+ a 2) b)))
        (else (+ a 1 (sumEvens (+ a 3) b)))))

;9.)
(define (CountOdds n)
  (cond ((and (< n 10) (even? n)) 0)
        ((and (< n 10) (odd? n)) 1)
        (else (+ (CountOdds (modulo n 10)) (CountOdds (quotient n 10))))))