(load "strings.scm")
(load "test-utils.scm")

(test-deep-equal
    "string splitting respects quotation marks"
    (context-aware-string-split "\"the cat jumped over the moon\" \"rats\"" #\space)
    (list "\"the cat jumped over the moon\"" "\"rats\"")
)

(test-deep-equal
    "string splitting ignores escaped characters"
    (context-aware-string-split "\\\\" #\\)
    (list "" "" "")
)
