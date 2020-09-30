; parsing logic

(load "strings.scm")

(define remove-comments-and-newlines (lambda (str)
    (fold-left
        string-append
        ""
        (map
            (lambda (x)
                (let ([commentIndex (string-indexof x ";" 0)])
                    (if
                        (= commentIndex -1)
                        x
                        (substring x 0 commentIndex)
                    )
                )
            )
            (string-split str "\n")
        )
    )
))

(define normalise-parens-spacing (lambda (str)
    (fold-left
        (lambda (current needle)
            (string-replace current needle (string-append " " needle " "))
        )
        str
        (list "(" ")" "[" "]")
    )
))

(define tokenise (lambda (str)
    (filter
        (lambda (token) (not (string=? token "")))
        (string-split
            (normalise-parens-spacing (remove-comments-and-newlines str))
            " "
        )
    )
))

(define is-string? (lambda (expr)
    (and
        (string? expr)
        ; Previously any string that starts with `"` will be treated as
        ; an un-parsed string. Try to minimise the damage here by requiring
        ; > 1 length and quotes at start/end.
        (> (string-length expr) 1)
        (char=? (string-ref expr 0) #\")
        (char=? (string-ref expr (- (string-length expr) 1)) #\")
    )
))

(define resolve-string (lambda (expr)
    (substring
        expr
        1
        ; Ensure that a valid substring is always taken (> 0 chars)
        (max 2 (- (string-length expr) 1))
    )
))

(define atomise (lambda (token)
    (cond
        ((is-numeric? token) (string->number token))
        ((is-string? token) (resolve-string token))
        (else (string->symbol token))
    )
))

(define build-ast (lambda (tree remaining_tokens) ; returns (tree remaining_tokens)
    (if (null? remaining_tokens) (list tree remaining_tokens)
        (case (car remaining_tokens)
            (
                ("(" "[")
                (let ([subtree (build-ast '() (cdr remaining_tokens))])
                    (build-ast
                        (append tree (list (car subtree)))
                        (list-ref subtree 1)
                    )
                )
            )
            (
                (")" "]")
                (list tree (cdr remaining_tokens))
            )
            (else
                (build-ast
                    (append
                        tree
                        (list (atomise (car remaining_tokens)))
                    )
                    (cdr remaining_tokens)
                )
            )
        )
    )
))

(define parse (lambda (str) (car (car (build-ast '() (tokenise str))))))