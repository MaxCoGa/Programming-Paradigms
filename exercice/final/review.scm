#lang scheme
;traitement de listes 
;(contain '(a 7 9 10) '(5 a c 7 10))
(define (contain S L)
  (cond
    ((or (not (list? S)) (not (list? L))) error)
    ((or (null? S) (null? L) ) (list '() '()))
    (#t (containAux S L '() '()))))

(define (containAux S L FS FO)
  (cond
    ((null? S) (list FS FO))
    ((member (car S) L)
     (containAux (cdr S) L (append FS (list(car S))) FO))
    (#t (containAux (cdr S) L FS (append FO (list(car S)))))
    )
  )


;-------------------------------------------------------------
;calcul
;(area (cons -2 2) (cons 1 5))
;area = (Bx-AX)(AY-BY)
;AX=(car A)
;AY=(cdr A)
;BX=(car B)
;BY=(cdr B)
(define (area A B)
  (abs (* (- (car B)(car A)) (- (cdr A)(cdr B)) ))
  )

;-------------------------------------------------------------
;;let
;(fct 5 7)
(define (fct x y)
  (let ((diff (- x y)))
    (let ((diff-squared (* diff diff)))
      (let ((diff-cubed (* diff-squared diff)))
        diff-cubed))))


;b.
(define (fctb x y)
  (let* ([diff (- x y)]
         [diff-square (* diff diff)]
         [diff-cubed (* diff-square diff)])
    diff-cubed)
         )

;c.
(define (abc x y)
  (let loop ((i x) (s 0))
    (if (< i y)
        (loop (+ i 1) (+ s i)) s)))

;d.
(define (len L)
  (if (list? L)
      (lengthAux L)
      'error ))
(define (lengthAux L)
  (if (null? L)
      0
      (+ 1 (lengthAux (cdr L)))))

(define (len2 L)
  (if (list? L)
      (letrec
          ([l (lambda (L)
                       (if (null? L)
                           0
                           (+ 1 (l (cdr L)))))])
        (l L)
           )
        'error))


;-----------------------------------------------------
(define pTree (list (cons 2 -3)
                    (list (list (cons 5 1) (list (list (cons 7 2) '())))
                          (list (cons -3 4) '())
                          (list (cons 2 4) (list (list (cons -1 1) '())
                                                 (list (cons -2 3) '()))))))

(define (traverse T)
  (cond
    ((null? T) '())
    ((null? (cdr T)) (car T))
    (#t (cons (car T) (traverseTail (cadr T))))))
		
		
(define (traverseTail T)
  (cond
    ((null? T) '())
    (#t (append (traverse (car T)) (traverseTail (cdr T))))))
				  				  
				  
(define (findPoint? T U V)
  (cond
    ((null? T) #f)
    ((and (equal? (caar T) U) (equal? (cdar T) V)) #t)
    ((null? (cdr T)) #f)
    (#t (findPointTail? (cadr T) U V))))


(define (findPointTail? TL U V)
  (if (null? TL)
      #f
      (or (findPoint? (car TL) U V) (findPointTail? (cdr TL) U V))))




