#lang racket

; Question 1

(define (degToRad deg)   
  (/ (* deg pi) 180))

(define (distanceGPS lat1 lon1 lat2 lon2)
  (let* ( [latt1 (degToRad lat1)]   ; let* is dynamic, operation on "let" variables must be within let's brackets 
         [latt2 (degToRad lat2)]
         [lonn1 (degToRad lon1)]
         [lonn2 (degToRad lon2)]
         [x (* 2 (asin (sqrt ( + (expt (sin (/ (- latt1 latt2 ) 2)) 2) (* (cos latt1) (cos latt2) (expt (sin (/ (- lonn1 lonn2) 2)) 2) ))))) ])
  (* x 6371.0) 
  ))


; Question 2

(define (absDiffA l1 l2)  ; a)

  ( cond ( (and (null? l1) (null? l2)) `())

         (  (and (null? l1) (not (null? l2))) ( cons (abs (car l2)) (absDiffA l1 (cdr l2)) ) )
         (  (and (null? l2) (not (null? l1))) ( cons (abs (car l1)) (absDiffA (cdr l1) l2) ) )
         (  (and (not (null? l1)) (not (null? l2))) ( cons (abs(- (car l1) (car l2))) (absDiffA (cdr l1) (cdr l2))  ))))


(define (absDiffB l1 l2)  ; b)
  ( cond ( (null? l1) `())
         ( (null? l2) `())
         ( else ( cons (abs(- (car l1) (car l2))) (absDiffB (cdr l1) (cdr l2))  ))))

; Question 3

; a) 

(define (duplicatePair l)
  (if (null? l)
      `list-is-null
      (duplicatePair2 l l `()) ))

(define (duplicatePair2 l lorg lnew)
  (cond ( (null? l) `())
        ( (not (member (car l) lnew)) (cons (my-count (car l) lorg 0) (duplicatePair2 (cdr l) lorg (flatten (list lnew (car l))))))  ; flatten was used to dynamically build a list '(a b c) in this format, otherwise format was messed up like '((() b) c) and member would return false if looking for b
        ( else (duplicatePair2 (cdr l) lorg lnew)) 
     ) )
  
(define (my-count wanted l counter) 
  (cond
    ( (null? l) (cons wanted counter)) 
    ((equal? wanted (car l)) (my-count wanted (cdr l) (+ counter 1)))
    (else (my-count wanted (cdr l) counter))
  ) )

; b)

(define sampleList '(1 a 5 6 2 b a 5 5))

(define (duplicateList l)
  (if (null? l) 
      `list-is-null
      (duplicateList2 l l `()) ))

(define (duplicateList2 l lorg lnew)
  (cond ( (null? l) `())
        ( (not (member (car l) lnew)) (cons (my-count2 (car l) lorg 0) (duplicateList2 (cdr l) lorg (flatten (list lnew (car l))))))  
        ( else (duplicateList2 (cdr l) lorg lnew)) 
     ) )

(define (my-count2 wanted l counter) 
  (cond
    ( (null? l) (list wanted counter)) 
    ((equal? wanted (car l)) (my-count2 wanted (cdr l) (+ counter 1)))
    (else (my-count2 wanted (cdr l) counter))
  ) )

; c)

(define (duplicateListSorted l)
  (if (null? l)
      `list-is-null
      (sort (duplicateList2 l l `() )  (lambda (x y)  (> (cadr x) (cadr y))) ; sort from racket documentation
 ) ))


; if theres a quasiquote `, scheme does not evaluate, otherwise if its just (something), it will try to evaluate a procedure 


(define notesTree
  '(73
     (31 (5 () ()) ())
     (101 (83 () (97 () ()))
          ())
     ) )

(define atree
  '(10
       (2 (4 (9 (3)) (12 (1 (2))) (16)))
       (5 (7) (21))
       (6)
       ))

;Q4
(define (children wanted tree)
 (cond ((null? tree) '())
       ((and (list? (car tree)) (> (length (car tree)) 1)) (append (children wanted (car tree)) (children wanted (cdr tree))) )
       ((equal? wanted (car tree)) (sort (getChildren (cdr tree)) >))
       (else (children wanted (cdr tree)))
         ))

(define (getChildren tree) ; helper function to find a node's children
  (cond ((null? tree) `())
        (else (cons (caar tree) (getChildren (cdr tree))))) )



  
  








