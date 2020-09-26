(load "strings.scm")
(load "parser.scm")

(define global-env (list
    ; arithmatic
    (list "+" +)
    (list "*" *)
    (list "-" -)
    (list "/" /)

    ; comparison
    (list "=" =)
    (list ">" >)
    (list "<" <)

    ; constants
    (list "#f" #f)
    (list "#t" #t)
))

(define resolve-symbol (lambda (key env)
    (let
        ([
            result
            (find (lambda (x)
                (string=? (car x) key)
            ) env)
        ])
        (if (list? result) (list-ref result 1) #f)
    )
))

(define is-symbol? (lambda (key env)
    (and (string? key) (resolve-symbol key env))
))

(define is-define? (lambda (expr)
    (and (list? expr) (string? (car expr)) (string=? (car expr) "define"))
))

(define resolve-define (lambda (expr env)
    (append! global-env (list (list
        (list-ref expr 1)
        (evalExp (list-ref expr 2) env)
    )))
))

(define is-function? (lambda (expr) 
    (and (list? expr) (string? (car expr)) (string=? (car expr) "lambda"))
))

(define resolve-function (lambda (expr env)
    (lambda args
        (evalExp
            (list-ref expr 2)
            (append
                (map list (list-ref expr 1) args)
                env
            )
        )
    )
))

(define is-branch? (lambda (expr) 
    (and (list? expr) (string? (car expr)) (string=? (car expr) "if"))
))

(define resolve-branch (lambda (expr env)
    (if
        (evalExp (list-ref expr 1) env)
        (evalExp (list-ref expr 2) env)
        (evalExp (list-ref expr 3) env)
    )
))

(define evalExp (lambda (program env)
    (if (null? program) '() 
        (cond
            ((is-symbol? program env) (resolve-symbol program env))
            ((is-numeric? program) (string->number program))
            ((is-define? program) (resolve-define program env))
            ((is-function? program) (resolve-function program env))
            ((is-branch? program) (resolve-branch program env))
            (else ; function call
                (apply
                    (evalExp (car program) env)
                    (map (lambda (x) (evalExp x env)) (cdr program))
                )
            )
        )
    )
))

; (display (parse "(+ 1 2)"))
; (display (tokenise "(+ (* 1 2) 3)"))
; (display (parse "(+ (* (- 1 0) 2) 3)"))
; (display (string-split ",a,b,c" ","))
; (display (string-indexof "ab,c" "," 0))
; (display (parse "(+ 1 2)"))
; (trace eval apply)
; (display (eval (parse "(+ (* 2 3) (/ 2 2))") global-env))
; (display (string-is-numeric? "1897987"))
; (display (string->number "1"))
; (display (get-env "+" global-env))
; (display (parse "(define a (+ 1 1))"))
; (trace evalExp resolve-symbol)
; (evalExp (parse "(define double (lambda (x) (+ x x)))") global-env)
; (evalExp (parse "(double 2") global-env)
; (display global-env)
; (evalExp (parse (string-replace "(define factorial
;     (lambda (x)
;         (if
;             (> x 1) ; if condition
;             (* x (factorial (- x 1)))
;             1 ; default case
;         )
;     )
; )" "\n" "")) global-env)
(display (evalExp (parse "(define factorial
    (lambda (x)
        (if
            (> x 1) ; test comment
            (* x (factorial (- x 1)))
            1 ; another test comment
        )
    )
)") global-env))
(display (evalExp (parse "(factorial 10") global-env))

