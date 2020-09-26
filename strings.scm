; string helpers

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

(define string-split (lambda (str delim) 
    (if (eq? (string-length str) 0 ) '()
    (let ([splitIndex (string-indexof str delim 0)])
        (if (eq? splitIndex -1)
            (list str)
            (append
                (list (substring str 0 splitIndex))
                (string-split (substring str (+ splitIndex 1 ) (string-length str)) delim)
            )
        )
    )
)))

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