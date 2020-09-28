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

(define is-keyword? (lambda (keyword expr)
    (and (list? expr) (string? (car expr)) (string=? (car expr) keyword))
))

(define is-symbol? (lambda (key env)
    (and (string? key) (resolve-symbol key env))
))

(define resolve-define (lambda (expr env)
    (append! global-env (list (list
        (list-ref expr 1)
        (evalExp (list-ref expr 2) env)
    )))
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

(define resolve-branch (lambda (expr env)
    (if
        (evalExp (list-ref expr 1) env)
        (evalExp (list-ref expr 2) env)
        (evalExp (list-ref expr 3) env)
    )
))

(define resolve-begin (lambda (expr local-env)
    (car (list-tail (map
        (lambda (sub-expression)
            (evalExp sub-expression local-env)
        )
        (cdr expr)
    ) 1))
))

(define resolve-local-variable (lambda (expr local-env)
    (let ([variable-pairs (list-ref expr 1)] [sub-expression (list-ref expr 2)])
        (evalExp
            sub-expression
            (append
                (map
                    (lambda (pair) (list
                        (car pair)
                        (evalExp (list-ref pair 1) local-env)
                    ))
                    variable-pairs
                )
                local-env
            )
        )
    )
))

(define is-string? (lambda (expr)
    (and (string? expr) (string=? (substring expr 0 1) "\""))
))

(define resolve-string (lambda (expr)
    (substring expr 1 (- (string-length expr) 1))
))

(define evalExp (lambda (program env)
    (if (null? program) '() 
        (cond
            ((is-keyword? "begin" program) (resolve-begin program env))
            ((is-symbol? program env) (resolve-symbol program env))
            ((is-numeric? program) (string->number program))
            ((is-string? program) (resolve-string program))
            ((is-keyword? "define" program) (resolve-define program env))
            ((is-keyword? "lambda" program) (resolve-function program env))
            ((is-keyword? "if" program) (resolve-branch program env))
            ((is-keyword? "let" program) (resolve-local-variable program env))
            (else ; function call
                (apply
                    (evalExp (car program) env)
                    (map (lambda (x) (evalExp x env)) (cdr program))
                )
            )
        )
    )
))
