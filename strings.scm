; string helpers

(begin

(define string-replace (lambda (str search replace)
    (if (< (string-length str) (string-length search)) str
        (if (string=? (substring str 0 (string-length search)) search)
            (string-append
                replace
                (string-replace
                    (substring str (string-length search) (string-length str))
                    search
                    replace
                )
            )
            (string-append
                (substring str 0 1)
                (string-replace
                    (substring str 1 (string-length str))
                    search
                    replace
                )
            )
        )
    ))
)

(define string-indexof (lambda (str search start) 
    (if (< (- (string-length str) start) (string-length search)) -1
        (if (string=? (substring str start (+ start (string-length search))) search)
            start
            (string-indexof str search (+ start 1))
        )
    )
))

(define context-aware-string-split (lambda (str delim)
    (context-aware-string-split-impl str delim 0 #f #f)
))

(define context-aware-string-split-impl (lambda (str delim index in-quotes escaped)
    (if (>= index (string-length str))
        (list str)
        (let ([current-character (string-ref str index)])
            (if (and
                    (char=? current-character delim)
                    (not in-quotes)
                    (not escaped)
                )
                (append
                    (list (substring str 0 index))
                    (context-aware-string-split-impl
                        (substring
                            str
                            (+ index 1 )
                            (string-length str)
                        )
                        delim
                        0
                        #f
                        #f
                    )
                )
                (context-aware-string-split-impl
                    str
                    delim
                    (+ index 1)
                    (and
                        ; Boils down to logical XOR of in-quotes and whether we just saw a quote
                        (not (eq? in-quotes (char=? current-character #\")))
                        ; Can't be in an escaped sequence
                        (not escaped)
                    )
                    (and
                        (char=? current-character #\\)
                        ; Not an *escaped* escaped character
                        (not escaped)
                        ; Not inside a string
                        (not in-quotes)
                    )
                )
            )
        )
    )
))

(define is-numeric? (lambda (str)
    (and
        (string? str)
        (fold-left
            (lambda (x y) (and x y))
            #t
            (map
                (lambda (char)
                    (and (char>=? char #\0) (char<=? char #\9))
                )
                (string->list str)
            )
        )
    )
))

; from https://groups.csail.mit.edu/mac/ftpdir/scheme-7.4/doc-html/scheme_15.html#SEC129
(define port->string (lambda (input-port)
    (let ((char (peek-char input-port)))
        (if
            (eof-object? char)
            char
            (list->string
                (let loop ((char char))
                    (if
                        (eof-object? char)
                        '()
                        (begin
                            (read-char input-port)
                            (cons char (loop (peek-char input-port)))
                        )
                    )
                )
            )
        )
    )
))

)