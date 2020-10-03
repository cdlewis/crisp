; parsing logic

(begin

(load "strings.scm")

(define find-comment-character (lambda (str index in-quotes)
    (if
        (>= index (string-length str))
        -1
        (let
            ([current-character (string-ref str index)])
            (if
                (and (not in-quotes) (char=? #\; current-character))
                index
                (find-comment-character
                    str
                    (+ index 1)
                    ; Boils down to logical XOR of in-quotes and whether we just saw a quote
                    (not (eq? in-quotes (char=? current-character #\")))
                )
            )
        )
    )
))

(define remove-comments-and-newlines (lambda (str)
    (fold-left
        string-append
        ""
        (map
            (lambda (x)
                (let ([commentIndex (find-comment-character x 0 #f)])
                    (if
                        (= commentIndex -1)
                        x
                        (substring x 0 commentIndex)
                    )
                )
            )
            (context-aware-string-split str #\newline)
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
        (context-aware-string-split
            (normalise-parens-spacing (remove-comments-and-newlines str))
            #\space
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
    ; Ensure that a valid substring is always taken (> 0 chars)
    (if
        (= (string-length expr) 2)
        ""
        (substring
            expr
            1
            (- (string-length expr) 1)
        )
    )
))

(define is-character? (lambda (expr)
    (and
        (string? expr)
        (char=? (string-ref expr 0) #\#)
        (char=? (string-ref expr 1) #\\)
    )
))

(define resolve-character (lambda (expr)
    (if
        (= (string-length expr) 3)
        (string-ref expr 2)
        (let ([sequence (substring expr 2 (string-length expr))])
            (case sequence
                (("newline") #\newline)
                (("space") #\space)
                (else (error "resolve-character. Unrecognised sequence" expr))
            )
        )
    )
))

(define atomise (lambda (token)
    (cond
        ((is-numeric? token) (string->number token))
        ((is-string? token) (resolve-string token))
        ((is-character? token) (resolve-character token))
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

)
