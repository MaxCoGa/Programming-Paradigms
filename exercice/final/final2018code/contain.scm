#lang racket

(define (contain S L)
	(cond
	 ((or (not (list? S)) (not (list? L))) error)
	 ((or (null? S) (null? L) ) (list '() '()))
	 (#t (containAux S L '() '()))))


(define (containAux S L FS FO)
	(cond
	 ((null? S) (list FS FO))
	 ((member (car S) L) (containAux (cdr S) L (cons (car S) FS) FO))
	 (#t (containAux (cdr S) L FS (cons (car S) FO)))))


(contain '(a 7 9 10) '(5 a c 7 10))
