(define test-deep-equal (lambda (description input expect)
    (if (equal? input expect)
        (display (string-append "PASS: " description "\n"))
        (begin
            (display (string-append "FAIL: " description "\n"))
            (error description input expect)
        )
    )
))