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