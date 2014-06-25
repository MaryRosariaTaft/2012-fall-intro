(define (square x)
  (* x x))

(define (sum-of-squares a b)
  (+ (* a a)
     (* b b)))

(define pi 3.14)

(define (areacircle r)
  (* pi (square r)))

(define (AreaRectangle a b)
  (* a b))

(define (AreaTriangle b h)
  (/ (* b h) 2))

(define (semi a b c)
  (/ (+ a b c) 2))

(define (square x)
  (* x x))

(define (howMany a b c)
  (cond ((< (- (square b) (* 4 a c)) 0) 0)
        ((= (- (square b) (* 4 a c)) 0) 1)
        ((> (- (square b) (* 4 a c)) 0) 2)))

(define (ringarea r1 r2)
  (abs (- (* pi (square r1)) (* pi (square r2)))))

(define (weeklypay h w)
  (if (<= h 40)
      (* h w)
      (+ (* 40 w) (* (- h 40) (/ 3 2) w))))

(define (new-price p w)
  (cond ((< w 3) p)
        ((< w 4) (* p .75))
        ((< w 5) (* p .5))
        (else (* p .25))))

(define (militaryTime t AMPM)
  (cond ((= 12 t) (if (= AMPM 0) 0 12))
        ((= AMPM 0) t)
        (else (+ t 12))))

(define (xor a b)
  (if (and a b)
      (not (and a b))
      (or a b)))

(define (Pellmod n)
  (cond ((= n 1) 1)
        ((= n 2) 3)
        (else (+ (* 2 (Pellmod (- n 1)))
                 (* 3 (Pellmod (- n 2)))))))

(define (myquotient n d)
  (cond ((< n d) 0)
        ((= n d) 1)
        (else (+ 1 (myquotient (- n d) d)))))

(define (mymodulo n d)
  (if (< n d)
      n
      (mymodulo (- n d) d)))

(define (sumDigits n)
  (if (< n 10)
      n
      (+ (modulo n 10) (sumDigits (quotient n 10)))))

(define (exponent b n)
  (cond ((= n 0) 1)
        ((= n 1) b)
        (else (* b (exponent b (- n 1))))))

(define (sumEvens a b)
  (cond ((> a b) 0)
        ((and (= a b) (odd? a)) 0)
        ((even? a) (+ a (sumEvens (+ a 2) b)))
        (else (+ a 1 (sumEvens (+ a 3) b)))))

(define (CountOdds n)
  (cond ((and (< n 10) (even? n)) 0)
        ((and (< n 10) (odd? n)) 1)
        (else (+ (CountOdds (modulo n 10)) (CountOdds (quotient n 10))))))

(define (TheOddsOf L)
  (cond ((null? L) L)
        ((odd? (car L)) (cons (car L) (TheOddsOf (cdr L))))
        (else (cons (+ 1 (car L)) (TheOddsOf (cdr L))))))

(define (TheOddsOf2 L)
  (cond ((null? L) L)
        ((list? (car L)) (append (theOddsOf2 (car L)) (TheOddsOf2 (cdr L))))
        ((odd? (car L)) (cons (car L) (TheOddsOf2 (cdr L))))
        (else (cons (+ 1 (car L)) (TheOddsOf2 (cdr L))))))

(define (mergelists L1 L2)
  (cond ((null? L1) L2)
        ((null? L2) L1)
        ((< (car L1) (car L2)) (cons (car L1) (mergelists (cdr L1) L2)))
        (else (cons (car L2) (mergelists L1 (cdr L2))))))

(define (sum L)
  (cond ((null? L) 0)
        ((list? (car L)) (+ (sum (car L)) (sum (cdr L))))
        (else (+ (abs (car L)) (sum (cdr L))))))

(define (sum-lists L1 L2)
  (cond ((null? L1) L2)
        ((null? L2) L1)
        (else (cons (+ (car L1) (car L2)) (sum-lists (cdr L1) (cdr L2))))))

(define (remove L n)
  (cond ((null? L) L)
        ((equal? (car L) n) (remove (cdr L) n))
        (else (cons (car L) (remove (cdr L) n)))))

(define (minList L)
  (if (null? (cdr L))
      (car L)
      (min (car L) (minList (cdr L)))))

(define (removeMin L)
  (cond ((null? L) L)
        ((null? (cdr L)) (cdr L))
        (else (remove L (minList L)))))

(define (remove2 L n)
  (cond ((null? L) L)
        ((list? (car L)) (append (remove2 (car L) n) (remove2 (cdr L) n)))
        ((equal? (car L) n) (remove2 (cdr L) n))
        (else (cons (car L) (remove2 (cdr L) n)))))

(define (hasanEven L)
  (cond ((null? L) #f)
            ((list? (car L)) (or (hasanEven (car L)) (hasanEven (cdr L))))
            ((even? (car L)) #t)
            (else #f)))

(define (Pairs L)
  (cond ((null? L) 0)
        ((null? (cdr L)) 0)
        ((= (car L) (car (cdr L))) (+ 1 (Pairs (cdr L))))
        (else (Pairs (cdr L)))))

(define (replace-nth k a L)
  (if (= k 1)
      (cons a (cdr L))
      (cons (car L) (replace-nth (- k 1) a (cdr L)))))

(define (sumOdd L)
  (cond ((null? L) 0)
        ((even? (car L)) (sumOdd (cdr L)))
        (else (+ (car L)
                 (sumOdd (cdr L))))))

(define (subsumOdd L)
  (cond ((null? L) 0)
        ((list? (car L)) (+ (subsumOdd (car L))
                            (subsumOdd (cdr L))))
        ((even? (car L)) (subsumOdd (cdr L)))
        (else (+ (car L)
                 (subsumOdd (cdr L))))))

(define (inList? L x)
  (cond ((null? L) #f)
        ((list? (car L)) (or (inlist? (car L) x)
                             (inlist? (cdr L) x)))
        ((equal? (car L) x) #t)
        (else (inlist? (cdr L) x))))