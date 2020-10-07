(begin

(define global-env (list
    ; arithmatic
    (list (string->symbol "+") +)
    (list (string->symbol "*") *)
    (list (string->symbol "-") -)
    (list (string->symbol "/") /)

    ; comparison
    (list (string->symbol "=") =)
    (list (string->symbol ">") >)
    (list (string->symbol "<") <)

    ; constants
    (list (string->symbol "#f") #f)
    (list (string->symbol "#t") #t)

    ; char utility functions
    (list (string->symbol "char>=?") char>=?)
    (list (string->symbol "char<=?") char<=?)

    ; string utility functions
    (list (string->symbol "peek-char") peek-char)
    (list (string->symbol "string->symbol") string->symbol)
    (list (string->symbol "string->list") string->list)
    (list (string->symbol "string=?") string=?)
    (list (string->symbol "string?") string?)
    (list (string->symbol "string-length") string-length)
    (list (string->symbol "substring") substring)
    (list (string->symbol "string-append") string-append)

    ; list utility functions
    (list (string->symbol "list") list)
    (list (string->symbol "fold-left") fold-left)
    (list (string->symbol "map") map)

    ; reflection functions
    (list (string->symbol "trace") (lambda x '()))
))

)