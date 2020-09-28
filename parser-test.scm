(load "parser.scm")
(load "test-utils.scm")

(test-deep-equal
    "Atomise correctly parses numbers"
    (atomise "10")
    10
)

(test-deep-equal
    "Parse nested expression"
    (parse "(+ (* (- 1 0) 2) 3)")
    (list "+" (list "*" (list "-" 1 0) 2) 3)
)

(test-deep-equal
    "Parse square brackets"
    (parse "(+ [* (- 1 0) 2] 3)")
    (list "+" (list "*" (list "-" 1 0) 2) 3)
)

(test-deep-equal
    "Parse recursive factorial function into AST"
    (parse "
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
    ")
    (list "begin"
        (list "define" "factorial"
            (list "lambda"
                (list "x")
                (list "if"
                    (list ">" "x" 1)
                    (list "*" "x"
                        (list "factorial"
                            (list "-" "x" 1)
                        )
                    )
                    1
                )
            )
        )
        (list "factorial" 10)
    )
)

