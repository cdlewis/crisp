(load "parser.scm")
(load "test-utils.scm")

(test-deep-equal
    "Atomise correctly parses numbers"
    (atomise "10")
    10
)

(test-deep-equal
    "Atomise correctly parses strings"
    (atomise "\"hello\"")
    "hello"
)

(test-deep-equal
    "Parse nested expression"
    (parse "(+ (* (- 1 0) 2) 3)")
    (list (string->symbol "+") (list (string->symbol "*") (list (string->symbol "-") 1 0) 2) 3)
)

(test-deep-equal
    "Parse square brackets"
    (parse "(+ [* (- 1 0) 2] 3)")
    (list (string->symbol "+") (list (string->symbol "*") (list (string->symbol "-") 1 0) 2) 3)
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
    (list (string->symbol "begin")
        (list (string->symbol "define") (string->symbol "factorial")
            (list (string->symbol "lambda")
                (list (string->symbol "x"))
                (list (string->symbol "if")
                    (list (string->symbol ">") (string->symbol "x") 1)
                    (list (string->symbol "*") (string->symbol "x")
                        (list (string->symbol "factorial")
                            (list (string->symbol "-") (string->symbol "x") 1)
                        )
                    )
                    1
                )
            )
        )
        (list (string->symbol "factorial") 10)
    )
)

