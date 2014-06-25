(define L '(Welcome (to the) Jungle (We (got)) fun (and) games))
(car L)
(car (cdr (cdr L)))
(car (car (cdr L)))
(car (cdr (cdr (cdr (cdr L)))))

(define f (lambda (a b)
   (if (or (even? a) (even? b))
       (* a b)
       (f (+ a 1) (- b 2)))))
(f 7 8)
(f 3 9)

(define (square x)
  (* x x))
(square 2)

(define (howMany a b c)
  (cond ((> (* b b) (* 4 a c)) 2)
        ((< (* b b) (* 4 a c)) 0)
        (else 1)))
(howMany 2 6 3); returns 2
(howMany 1 -8 16); returns 1
(howMany 4 5 3); returns 0

(define (count L a)
  (cond ((null? L) 0)
        ((equal? (car L) a) (+ 1 (count (cdr L) a)))
        (else (count (cdr L) a))))
(count '( ) 5); returns 0
(count '(3 1 boy girl 15 3) 3); returns 2
(count '(pulled pork is delicious) 'pork); returns 1
(count '(7 bag 91 2 donkey) 'shrek); returns 0

(define (dc L a)
  (cond ((null? L) 0)
        ((list? (car L)) (+ (dc (car L) a)
                            (dc (cdr L) a)))
        ((equal? (car L) a) (+ 1 (dc (cdr L) a)))
        (else (dc (cdr L) a))))
(dc '() 7); returns 0
(dc '(let (the games) begin) 'let); returns 1
(dc '((ball 4) means (take a walk)) 4); returns 1
(dc '((you say) goodbye (and I) say hello) 'say); returns 2
(dc '(1 (a b cat) a (a 34)) 'a); returns 3

(define (RLZ L)
  (cond ((null? L) '())
        ((= (car L) 0) (RLZ (cdr L)))
        (else L)))
(RLZ '(0 0 0 2 3 0 1)); returns (2 3 0 1)
(RLZ '(1 2 0 0 0)); returns (1 2 0 0 0)
(RLZ '(0 0 0 0)); returns ()

(define (laundry n)
  (cond ((<= n 8) 8)
        ((<= n 30) (+ 8 (* .5 (- n 8))))
        (else (+ 8 (* .5 22) (* .1 (- n 30))))))
(laundry 9)
(laundry 30)
(laundry 34)

(define (allYour base are belong tous)
(cond ((= base 0) (+ belong tous ))
      ((> base 0) (allYour (- base 1) base base are ))
      (else (allYour (+ base 1) are are belong ))))

;Evaluate each expression:
(allYour 1 2 3 4)
(allYour -1 -2 3 4)

(define (MilitaryTime a b)
  (if (= b 0)
      (modulo a 12)
      (+ 12 (modulo a 12))))
(MilitaryTime 12 0)
(MilitaryTime 12 1)
(MilitaryTime 3 0)
(MilitaryTime 3 1)