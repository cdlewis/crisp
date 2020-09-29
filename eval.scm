(load "strings.scm")
(load "parser.scm")

(define global-env (list
    ; arithmatic
    (list (string->symbol "+") +)
    (list (string->symbol "*") *)
    (list (string->symbol "-") -)
    (list (string->symbol "/") /)

    ; comparison
    (list (string->symbol "=") =)
    (list (string->symbol ">") >)
    (list (string->symbol "<") <)

    ; constants
    (list (string->symbol "#f") #f)
    (list (string->symbol "#t") #t)
))

(define resolve-symbol (lambda (key env)
    (let
        ([
            result
            (find (lambda (x)
                (eq? (car x) key)
            ) env)
        ])
        (if (list? result) (list-ref result 1) "hello")
    )
))

(define is-keyword? (lambda (keyword expr)
    (and (list? expr) (symbol? (car expr)) (eq? (car expr) (string->symbol keyword)))
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

(define resolve-load (lambda (expr local-env)
    (let
        ([file-contents (port->string (open-input-file (evalExp (list-ref expr 1) local-env)))])
        (evalExp (parse file-contents) local-env)
    )
))

(define evalExp (lambda (program env)
    (if (null? program) '() 
        (cond
            ; Primitive type
            ((number? program) program)
            ((string? program) program)

            ; Symbol
            ((is-keyword? "begin" program) (resolve-begin program env))
            ((is-keyword? "define" program) (resolve-define program env))
            ((is-keyword? "lambda" program) (resolve-function program env))
            ((is-keyword? "if" program) (resolve-branch program env))
            ((is-keyword? "let" program) (resolve-local-variable program env))
            ((is-keyword? "load" program) (resolve-load program env))
            ((symbol? program) (resolve-symbol program env))

            ; Function call
            (else
                (apply
                    (evalExp (car program) env)
                    (map (lambda (x) (evalExp x env)) (cdr program))
                )
            )
        )
    )
))