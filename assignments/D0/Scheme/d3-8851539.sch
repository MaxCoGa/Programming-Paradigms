#lang scheme
;;;Devoir 3 Maxime Côté-Gagné 8851539
;;;Question1
;(1over '(0 2 3 4 12 0 0 1 0))
(define (lover n)
    (map (lambda (n) (if (equal? 0 n) n (/ 1 n)))
         n))
;--------------------------------------------
;;;Question 2
(define TOL 1e-6);tolerence definit pour la question 2 et 3
;(newtonRhap x f fx)
;(newtonRhap 0.1 sin cos)=>0
;(newtonRhap 2.0 (lambda (x) (- (* x x) x 6))
;(lambda (x) (- (* 2 x) 1)))=>3

 (define (newtonRhap x (f x) (fx x))
   ((> (abs (- x (- x (/ (f x) (fx x))))) TOL)
    (newtonRhap (- x (/ (f x) (fx x))) (f x) (fx x))
    (list x))
   ) 

;--------------------------------------------
;;;Question 3
;(p_cos 0)
;(p_cos (/ pi 2))


(define (p_cos x)
  (for/product ([TOL (in-range 1 100)])
    (p_cos_aux x TOL)))

(define (p_cos_aux x n)
  (- 1 (/ (* 4 (* x x)) (* (* pi pi) (* (- (* 2 n) 1) (- (* 2 n) 1))))))

;-------------------------------------------
;;;Question4
;a (separator? #\space) (separator? #\tab) (separator? #\newline)
(define (separator? x)
  (cond ((char=? x #\space) #t)
        ((char=? x #\tab) #t)
        ((char=? x #\newline) #t)
   (else #f)
  ))
;b
;(cpy '(#\H #\e #\l #\l #\o #\space #\W #\o #\r #\l #\d))
;(cpy '(#\H #\e #\l #\l #\o #\tab #\W #\o #\r #\l #\d))
;(cpy '(#\H #\e #\l #\l #\o #\newline #\W #\o #\r #\l #\d))
;(cpy '(#\H #\e #\l #\l #\o #\n #\W #\o #\r #\l #\d))
(define (cpy x)
  (cond ((member #\space x);;Regarde si le separator est membre de la liste
          (take x (index-of x #\space)));;retourne la liste sans le separateur a partir de l'index de ce dernier
        ((member #\tab x)
          (take x (index-of x #\tab)))
        ((member #\newline x)
          (take x (index-of x #\newline)))
          (else x));; retourne la liste si aucun separateur
  )

;c (drop '(#\H #\e #\l #\l #\o #\newline #\W #\o #\r #\l #\d))
(define (drop x)
  (cond ((member #\newline x)
         (list-tail x (+ (index-of x #\newline) 1)))
        ((member #\tab x)
         (list-tail x (+ (index-of x #\tab) 1)))
        ((member #\space x)
         (list-tail x (+ (index-of x #\space) 1)))
          (else x))
  )

;d (same? '(#\H #\e #\l #\l #\o #\tab #\W #\o #\r #\l #\d)'(#\H #\e #\l #\l #\o))
;(member (car '(#\H #\e #\l #\l #\o)) (car '(#\H #\e #\l #\l #\o)))
(define (same? x y)
  (cond ((char=? (car x) #\tab) #t)
        ((char=? (car x) #\space) #t)
        ((char=? (car x) #\newline) #t)
        ((null? y) #f)
        ((char=? (car x) (car y)) (same? (cdr x) (cdr y)))
        (else #f))
  )

;e (replace '(#\a #\space #\b #\i #\r #\d #\space #\e #\a #\t #\s #\space #\a #\space #\t #\o #\m #\a #\t #\o) '(#\a) '(#\t #\h #\e))
(define (replace x y yy)
  (cond ((char=? (car x) #\space) (replace (cdr x) y yy))
        ((char=? (car x) #\tab) (replace (cdr x) y yy))
        ((char=? (car x) #\newline) (replace (cdr x) y yy))
        ((and (char=? (car x) (car y)) (char=? (car(cdr(cdr x))) #\space) (replace (append yy (cdr x)) y yy)))
        (else x))
  )
