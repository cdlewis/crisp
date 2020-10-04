![CI](https://github.com/cdlewis/crisp/workflows/CI/badge.svg)

# CRISP - Chris Lisp

Work in progress Lisp interpreter designed to run on Chez Scheme. I'm trying to figure it out with intuition rather than reading ahead so it's... pretty hacky.

The goal is to have CRISP be able to run itself. Currently it can parse, but not properly run, itself.

Currently supports most of what you'd expect from a Lisp dialect, including common types (lists, strings, numbers, etc), operators (>, <, =, etc) named variables, recursion, and comments.

```scheme
(begin
    (define factorial
        (lambda (x)
            (if
                (> x 1)
                (* x (factorial (- x 1)))
                1 ; base case
            )
        )
    )

    (factorial 10)
)
```

## How to run
To start the REPL, run:
```bash
make repl
```

To run the REPL inside the REPL:
```bash
make inception
```
