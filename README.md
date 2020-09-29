# CRISP - Chris Lisp

Work in progress Lisp interpreter designed to run on Chez Scheme. I'm trying to figure it out with intuition rather than reading ahead so it's... pretty hacky.

Currently supports assignment, recursion, comments, etc:

```scheme
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
```

## How to run
To start the REPL, run:
```
make repl
```