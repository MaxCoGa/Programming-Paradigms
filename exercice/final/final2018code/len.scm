#lang racket


(define (lenGlob L)
	(if (list? L)
			(lengthAux L)
			'error
			))

(define (lengthAux L)
  (if (null? L)
      0
      (+ 1 (lengthAux (cdr L)))))


(define (lenLocal L)
	(if (list? L)
			(let l ((LL (cdr L)) (C 1))
				(if (null? LL)
						C
						(l (cdr LL) (+ C 1)))) 
			'error
			))




(lenGlob '(1 c d 6 7))
(lenLocal '(1 c d 6 7))
