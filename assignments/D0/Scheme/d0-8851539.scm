#lang scheme
;;;Devoir 0 Maxime Côté-Gagné 8851539
(current-directory)
(define fp (build-path "C:" "Users" "Maxime" "Desktop"))
(current-directory fp)
(current-directory)



; (define in (open-input-file "3by3_inputdata.txt"))
; (close-input-port in)
; (file->lines "3by3_inputdata.txt")


(define (readTableau fileIn)  
  (let ((sL (map (lambda s (string-split (car s))) (file->lines fileIn))))
    (map (lambda (L)
           (map (lambda (s)
                  (if (eqv? (string->number s) #f)
                      s
                      (string->number s))) L)) sL)))
    
(readTableau "d.txt")

(define tb (readTableau "d.txt"))

(define (writeTableau tb fileOut)
  (if (eqv? tb '())
      #t
      (begin (display-lines-to-file (car tb) fileOut #:separator #\space #:exists 'append)
             (display-to-file #\newline fileOut #:exists 'append)
             (writeTableau (cdr tb) fileOut))))
                             
; (display-lines-to-file (readTableau "3by3_inputdata.txt") "test.txt")

; (writeTableau tb "test.txt")

;--------------------------------------------------------------------------------------------

;"main" du programme
;(minimumCell “d.txt” “i.txt”)
(define (minimumCell input output)
  (findsupply tb null);;chercher les supply
  (finddemand tb null);;chercher les demand
  (buildmatrix (length demand) (length supply))
  (initcostsmatrix (length demand) (length supply))
  (buildcosts  tb (length demand) (length supply));;chercher le couts de chaque cell de la matrice
  ;(minimumcost(supply demand costs matrix))
  ;;(writeTableau tb output);;Écrit un fichier avec l'output donné
 )

;Définir les supply du fichier description du problème
(define supply null) ;;(list (last (cadr tb)) (last (caddr tb)) (last (cadddr tb)) )
 ; (findsupply tb '())
(define (findsupply lst vide)
  (cond ((string=? (caar lst) "Demand") (set! supply (remove-duplicates (flatten supply))))
    ((string>? (caar lst) "Source") (findsupply (cdr lst) (set! supply (list supply (last (car lst))))))
        (else (findsupply (cdr lst) vide)))
  )
;Definir les demandes du fichiers
(define demand null);((take (cdr(cdr(cdr(readTableau "d.txt")))) (index-of (cdr(cdr(cdr(readTableau "d.txt")))) "Demand"))))
;(finddemand tb null)
(define (finddemand lst vide)
  (cond ((string=? (caar lst) "Demand") (set! demand (cdar lst)))
        (else (finddemand (cdr lst) vide)))
  )

;Définir le couts de chaque cell d'une matrix en input
;;(vector->values (vector-ref matrix 2) 2) ;;valeur de la cell a une position [2,2]
;;(vector-set! (vector-ref matrix 2) 2 10) ;;change la valeur a la position[2,2]
(define costs null)
(define (initcostsmatrix demandl supplyl)
  (set! costs
  (for/vector ([i (in-range supplyl)])
    (for/vector ([j (in-range demandl)])
      0)))
                                          
  )
(define i 0)
(define j 0)
(define (buildcosts desc demandl supplyl);;Je veux ça!!! (vector-set! (vector-ref costs i) j (cadr(cadr tb)))
  (cond((equal? (caar desc) "COSTS") (buildcosts (cdr desc) demandl supplyl))
       ((string>? (caar desc) "Source") (set! j 0)
        (vector-set! (vector-ref costs i) j (car(cdar desc)))
        (vector-set! (vector-ref costs i) (+ 1 j) (car(cddar desc)))
        (vector-set! (vector-ref costs i) (+ 2 j) (car(cdddar desc)))
        (set! i (+ 1 i))
        (buildcosts (cdr desc) demandl supplyl)
        )
  (else costs))
  ;;(set! costs (vector->list costs))
  )

;Définir la matrice à utiliser(sa grandeur x y)
(define matrix null)
(define (buildmatrix demandlenght supplylenght)
  (set! matrix
  (for/vector ([i (in-range supplylenght)])
    (for/vector ([j (in-range demandlenght)])
      0)))
 ;; (set! matrix (vector->list matrix))
  )


;;Chercher le cout minimum
;(define (minimumcost(supply demand costs matrix))
 ; )
(define (apply-list fct L)
  (if (null? L)
      '()
      (cons (fct (car L))
            (apply-list fct (cdr L)))))

(define (prefix_path p L)
  (apply-list (lambda(e) (cons p e)) L))

(define (chemin dim coords)
  (cond
    [(= dim 0) '(())]
    [(null? coords) '()]
    [else
     (append (chemin (car coords)
                          (chemin (- dim 1) (cdr coords)))
             (chemin dim (cdr coords)))]))

(define (valid? x y)
  (if (or (= (point-x x) (point-x y))
          (= (point-y x) (point-y y)))
      #t
      #f)
  )

  ;;;test
(define-struct point (x y c u))
(define coordinates
(list 
(make-point 6 8 10 30)
(make-point 7 11 11 40)
(make-point 4 5 12 50)))



