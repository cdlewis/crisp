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
        (if
            (list? result)
            (list-ref result 1)
            (error "resolve-symbol. Missing reference" (symbol->string key))
        )
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

(define evalExp (lambda (expr env)
    (if (null? expr) '() 
        (cond
            ; Primitive types
            ((number? expr) expr)
            ((string? expr) expr)
            ((boolean? expr) expr)

            ; Symbol
            ((is-keyword? "begin" expr) (resolve-begin expr env))
            ((is-keyword? "define" expr) (resolve-define expr env))
            ((is-keyword? "lambda" expr) (resolve-function expr env))
            ((is-keyword? "if" expr) (resolve-branch expr env))
            ((is-keyword? "let" expr) (resolve-local-variable expr env))
            ((is-keyword? "load" expr) (resolve-load expr env))
            ((symbol? expr) (resolve-symbol expr env))

            ; Function call
            (else
                (let
                    (
                        [function (evalExp (car expr) env)]
                        [args (map (lambda (x) (evalExp x env)) (cdr expr))]
                    )
                    (apply function args)
                )
            )
        )
    )
))