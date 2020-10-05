(load "eval.scm")
(load "test-utils.scm")

(test-deep-equal
    "resolve-symbol resolves symbols as expected"
    (resolve-symbol (string->symbol "+") global-env)
    +
)

(test-deep-equal
    "Factorial function executes correctly"
    (evalExp (parse "
    (begin
        (define factorial
            (lambda (x)
                (if
                    (> x 1) ; test comment
                    (* x (factorial (- x 1)))
                    1 ; another test comment
                )
            )
        )

        (factorial 10)
    )
    ") global-env)
    3628800
)

(test-deep-equal
    "Local variables are can be referenced within sub-expressions"
    (evalExp (parse "
    (let ([x (+ 2 3)] [y 10])
        (+ x y)
    )
    ") global-env)
    15
)

(test-deep-equal
    "Strings evaluate to themselves"
    (evalExp (parse "\"hello\"") global-env)
    "hello"
)

(test-deep-equal
    "Strings can be passed as arguments"
    (evalExp (parse "(string=? \"cat\" \"hat\")") (list))
    #f
)

(test-deep-equal
    "Other files can be evaluated with `load`"
    (evalExp (parse "(load \"test-programs/simple-addition.scm\"") global-env)
    2
)

(test-deep-equal
    "Logical AND returns true when all elements are true"
    (evalExp (parse "(and #t #t #t") (list))
    #t
)

(test-deep-equal
    "Logical AND returns false when an element is false"
    (evalExp (parse "(and #t #f #t") (list))
    #f
)

(test-deep-equal
    "Logical AND short circuits when falsy statement is seen"
    (evalExp (parse "(and #f (missing-function-call 1 2 3)") (list))
    #f
)