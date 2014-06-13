; Mary Taft, Period 9

(define (semi a b c)
  (/ (+ a b c) 2))

(define (square x)
  (* x x))

(define (howMany a b c)
  (cond ((< (- (square b) (* 4 a c)) 0) 0)
        ((= (- (square b) (* 4 a c)) 0) 1)
        ((> (- (square b) (* 4 a c)) 0) 2)))

(define pi 3.14)
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