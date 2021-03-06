(begin

(load "strings.scm")
(load "parser.scm")
(load "global-environment.scm")

(define resolve-symbol (lambda (key local-env)
    (let
        (
            [local-env-result (find (lambda (x) (eq? (car x) key)) local-env)]
            [global-env-result (find (lambda (x) (eq? (car x) key)) global-env)]
        )
        (cond
            ((list? local-env-result) (list-ref local-env-result 1))
            ((list? global-env-result) (list-ref global-env-result 1))
            (else (error "resolve-symbol. Missing reference" (symbol->string key)))
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
    (for-each
        (lambda (sub-expression)
            (evalExp sub-expression local-env)
        )
        (cdr expr)
    )
))

(define resolve-local-variable (lambda (expr local-env)
    (let ([variable-pairs (list-ref expr 1)] [sub-expression (list-ref expr 2)])
        (evalExp
            sub-expression
            (append
                (map
                    (lambda (pair) (list
                        (list-ref pair 0)
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

(define resolve-logical-and (lambda (expr local-env)
    (fold-left
        (lambda (current-result next-expr)
            (if
                ; Short-circuit if we've already evaluated to false
                (not current-result)
                #f
                ; Otherwise evaluate the next component
                (evalExp next-expr local-env)
            )
        )
        #t
        (cdr expr)
    )
))

(define evalExp (lambda (expr env)
    (if (null? expr) '() 
        (cond
            ; Primitive types
            ((number? expr) expr)
            ((string? expr) expr)
            ((boolean? expr) expr)
            ((char? expr) expr)

            ; Symbol
            ((is-keyword? "begin" expr) (resolve-begin expr env))
            ((is-keyword? "define" expr) (resolve-define expr env))
            ((is-keyword? "lambda" expr) (resolve-function expr env))
            ((is-keyword? "if" expr) (resolve-branch expr env))
            ((is-keyword? "let" expr) (resolve-local-variable expr env))
            ((is-keyword? "load" expr) (resolve-load expr env))
            ((is-keyword? "and" expr) (resolve-logical-and expr env))
            ((symbol? expr) (resolve-symbol expr env))

            ; Function call
            (else
                (let
                    (
                        [function (evalExp (list-ref expr 0) env)]
                        [args (map (lambda (x) (evalExp x env)) (cdr expr))]
                    )
                    (apply function args)
                )
            )
        )
    )
))

)