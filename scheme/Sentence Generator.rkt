(define nouns '(book tissue porpoise wrestler pillow))

(define verbs '(scuttles flies speculates explodes  weeps))

(define adjectives '(oozing broken mudslinging sticky loatheful))

(define (one-of L)
  (list-ref L (random 5)))

(define noun (one-of nouns))

(define verb (one-of verbs))

(define adjective (one-of adjectives))

(define articles '(a () the a the))

(define article? (one-of articles))

(define adjective* 