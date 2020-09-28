(load "main.scm")
(load "test-utils.scm")

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
