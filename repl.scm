(begin

(load "eval.scm")

(define read-input (lambda ()
    (begin
        (display "> ")
        (let ([command (get-line (current-input-port))])
            (if
                (or (not (string? command)) (string=? command "(exit)"))
                (display #\newline)
                (begin
                    (display (evalExp (parse command) (list)))
                    (display #\newline)
                    (read-input)
                )
            )
        )
    )
))

(read-input)

)