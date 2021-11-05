;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;q1) Define the function (byTwos n m) that returns the list of integers starting with n such that each successive element is two greater than the previous element and no element is greater than m. 
;For example, 
;> (byTwos 1 20) (1 3 5 7 9 11 13 15 17 19) 
;This function should be around than 3 or 4 lines of code. 

;;;Solution:
;;; base case: n > m
;;; Hypothesis: Assume (byTwos(+ n 2) m) returns the list of every other integer from n+2 to m 
;;; Recursive step: (byTwos n m) returns (cons n (byTwos (+ n 2) m))
(define (byTwos n m) 
		 (if (> n m) 
			'() 
			(cons n (byTwos (+ n 2) m))
		 )
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;q2) Write the function (compress L) that returns a list of all the atoms (non-list values) contained in L or in any nested list within L. For example,
; > (compress '(1 (2 3 (4 5) (6 7 (8)) 9) 10)) 
; (1 2 3 4 5 6 7 8 9 10)

;;;Solution:
;;;Start with an empty list and keep adding elements to this list
;;;base case: if l1 is null, return l2- (null? l1) l2
;;;Hypothesis: assume (comp  (cdr l1) l2) compresses all elements of (cdr l1)
;;;recursive step: (comp l1 l2) returns (comp (cdr l1) (append l2 (list(car l1))))
(define (comp l1 l2)
	(cond ((null? l1) l2)
		  ((list? (car l1)) (comp (cdr l1) (append l2 (comp (car l1) '()))))
		  (else (comp (cdr l1) (append l2 (list(car l1)))))
	) 
)


(define (compress l) (comp l '()))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;q3) Write a linear-time reverse function, (rev-all L) which reverses the elements of a list L and, if the L contains nested lists, reverses those nested lists as well. For example,
; > (rev-all '(1 2 (3 4) (5 6 (7 8) 9) 10))
; (10 (9 (8 7) 6 5) (4 3) 2 1)

;;;Solution:
;;;base case: if l1 is null return l2: ((null? l1) l2)
;;;Hypothesis: (myrev (cdr l1) l2) returns the reverse list of (cdr l1)
;;;recursive step: (myrev l1 l2) returns (myrev (cdr l1) (cons (car l1) l2))
( define (myrev l1 l2)
	(cond ((null? l1) l2)
		  ((list? (car l1)) (myrev (cdr l1) (cons (myrev (car l1) '()) l2)))
		  (else (myrev (cdr l1) (cons (car l1) l2)))
	)
)

(define (reverseList l) (myrev l '()))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;q4)Write your own equality function, (equalTo? x y), which works the same as (equal? x y).
; You can call eq?, but you cannot use equal?.

;;;Solution:
;;;base case: if l1 and l2 are null return #t- (null l1) #t
;;;if only l1 or l2 is null return #f
;;;hypothesis: Assume (equalTo (cdr l1) (cdr l2)) correctly compares (cdr l1) and (cdr l2)
;;;we have to ensure (car l1) = (car l2) AND (cdr l1)=(cdr l2)
;;;if only one of (car l1) and (car l2) is a list return #f
;;;if both (car l1) and (car l2) are lists, return (and (equalTo (car l1) (car l2)) (equalTo (cdr l1) (cdr l2)))
;;;recursion: (equalTo l1 l2) returns (and (= (car l1) (car l2)) (equalTo (cdr l1) (cdr l2)))

(define (equalTo? l1 l2) 
	(cond ((AND (null? l1) (null? l2)) #t)
		  ((null? l1) #f)
		  ((null? l2) #f)
		  ((AND (list? l1) (list? l2)) 
			(cond 
				((AND (list? (car l1)) (list? (car l2))) (AND (equalTo? (car l1) (car l2))  (equalTo? (cdr l1) (cdr l2))))
				((list? (car l1)) #f)
				((list? (car l2)) #f)
				(else (AND (eq? (car l1) (car l2))  (equalTo? (cdr l1) (cdr l2))))
			)
		   )
		  ((list? l1) #f)
		  ((list? l2) #f)
		  (else 
			(cond ((eq? l1 l2) #t)
				(else #f)
			)
		   )
	)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;q5)Write a function (equalFns? fn1 fn2 domain), where the parameters fn1 and fn2 are functions and domain is a list of values, that returns true if fn1 and fn2 always returns the same value when applied to the same element of domain. Don't assume that fn1 and fn2 always return atomic values. For example,
; > (equalFns? (lambda (x) (* x 2)) (lambda (y) (+ y y))
; '(1 2 3 4 5 6 7 8 9 10 11 12))
; #t
; > (equalFns? (lambda (x) (* x 2)) (lambda (y) (+ y 2)) '(2))
; #t
; > (equalFns? (lambda (x) (* x 2)) (lambda (y) (+ y 2)) '(2 3 4 5))
; #f
; > (equalFns? (lambda (L) (car L)) (lambda (L) (cadr L))
; '(((2 3) (2 3)) ((4 5) (4 5))))
; #t

;;;Solution:
;;;base case: if domain is null return #t
;;;hypothesis: Assume equalFns fn1 fn2 (cdr domain) returns correct value for (cdr domain)
;;;recursive step: we have to check if fn1 and fn2 return same value for (car domain) and (all elements of (cdr domain))
;;;(and (equalTo? (map  fn1 (list(car domain))) (map fn2 (list(car domain))))
;;;		(equalFns? fn1 fn2 (cdr domain)))
(define (equalFns? fn1 fn2 domain)
	(cond ((null? domain) #t)
		  (else 
			(AND 
				(equalTo? (map fn1 (list(car domain))) (map fn2 (list(car domain)))) 
				(equalFns? fn1 fn2 (cdr domain))
			)
		  )
	)
)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;q6) Write a function, (same-vals fn1 fn2 domain), that returns the list of all elements x of domain such that (fn1 x) and (fn2 x) return the same value. For example,
; > (same-vals (lambda (x) x)
; (lambda (y) (abs y)) ;; abs give the absolute value
; '(-3 -2 -1 0 1 2 3))
; (0 1 2 3)

;;;Solution:
;;;base case: when domain is null return l
;;;hypothesis: Assume (same-vals fn1 fn2 (cdr domain)) behaves correctly for all elements of (cdr domain)
;;;Recursive step: if (fn1 (car domain)) (fn2 (car domain)) are equal, then (sameval fn1 fn2 domain l) returns (sameval fn1 fn2 (cdr domain) (append l (list(car domain))))
;;; (else (sameval fn1 fn2 (cdr domain) l))
(define (sameval fn1 fn2 domain l)
	(cond ((null? domain) l)
		  ((equal? (fn1 (car domain)) (fn2 (car domain))) (sameval fn1 fn2 (cdr domain) (append l (list(car domain)))))
		  (else (sameval fn1 fn2 (cdr domain) l))
	)
)
(define (same-vals fn1 fn2 domain)
	(sameval fn1 fn2 domain '())
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;q7) Write a function (split x L), where x is a number and L is a list of numbers, that returns a list containing two lists: The rst list contains the numbers in L less than or equal to x and the second list contains the numbers in L greater than x. For example,
; > (split 6 '(1 9 2 8 3 10 4 6 5))
; ((1 2 3 4 6 5) (9 8 10))

;;;Solution:
;;;base case: when L is null return '(()())
;;;hypothesis: split splits (cdr L) correctly. Store this in a variable
;;;recursive: (split x (cdr L)) returns
;;;((>= x (car L)) ((list (cons (car L) (car lst)) (cadr lst)))
;;;(else (mysplit x (cdr L) (append (cdr l2) x)))
(define (split x L)
	(cond ((null? L) '(()()))
		(else 
			(let ((lst (split x (cdr L))))
				(cond ((>= x (car L)) (list (cons (car L) (car lst)) (cadr lst)))
				(else (list (car lst) (cons (car L) (cadr lst)))))
			)
		)
	)
)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;q8) Write a function (psort L) that implements a partition sort (similar to Quicksort). It should use your split function, above. Given a list L, if L is non-empty, then split should be called using the first element of L to partition the rest of L. Then, psort should be called recursively to sort each of the two lists returned by split. Finally, the sorted result is constructed from the elements of the two sorted lists, as well as the rst element of L. For example,
; > (psort '(5 3 8 6 1 0 2))
; (0 1 2 3 5 6 8)

;;;Solution:
;;;base case: When L is null or L has only one element, return L
;;;Hypothesis: use split function to psort cdr L with car L as x, this correctly splits (cdr L) 
;;;(split (car L) (cdr L)) - store this in some variable lstA
;;;Recursively call psort on (car lstA) and append it with (car L)
;;;Recursion: (psort L) returns (append (append (psort (car lstA)) (list (car L))) (psort (cadr lstA)) )

;;;functions used in psort:
;;;(split x L)

(define (split x L)
	(cond ((null? L) '(()()))
		(else 
			(let ((lst (split x (cdr L))))
				(cond ((>= x (car L)) (list (cons (car L) (car lst)) (cadr lst)))
				(else (list (car lst) (cons (car L) (cadr lst)))))
			)
		)
	)
)

(define (psort L)
    (cond ( (null? L) L)
          ( (null? (cdr L)) L )
          (else (let ( (lstA (split (car L) (cdr L))) )
                    (append (append (psort (car lstA)) (list (car L))) (psort (cadr lstA)) )
    ))
    )
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;q9) Write a single function (applyToList f), where f is a parameter that is a function, that returns a function that takes a list L as a parameter and applies f to every element of L,  returning the resulting list as the result.

;;;Solution:
;;The return value of applyToList is a function, which indicates the return value is a lambda function 
;;The calling function can pass a list or single element 
(define (applyToList f)
	(lambda (L) (map f L)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;q10) Write a function (newApplyToList f) which behaves exactly like applyToList above, except that you cannot use the built-in map or any other built-in function except cons, car, and cdr. Also, you cannot define any helper function outside of newApplyToList, but you can define functions within it (Note: do not use (define ...) inside a procedure). You do not need to provide a comment showing your recursive reasoning.

;;;Solution:
(define (newlyApplyToList f)
	(letrec ((map1 
				(lambda (f1 l1) 
						(cond((null? l1) '()) 
							(else (cons (f1 (car l1)) (map1 f1 (cdr l1))))
						)
				)
			))
			(lambda (L) (map1 f L))
	)
)
