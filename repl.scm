(begin

(load "eval.scm")

(define read-input (lambda ()
    (begin
        (display "> ")
        (let ([command (get-line (current-input-port))])
            (if
                (string=? command "(exit)")
                (display #\newline)
                (begin
                    (display (evalExp (parse command) global-env))
                    (display #\newline)
                    (read-input)
                )
            )
        )
    )
))

(read-input)

)