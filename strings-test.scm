(load "strings.scm")
(load "test-utils.scm")

(test-deep-equal
    "string splitting respects quotation marks"
    (string-split "\"the cat jumped over the moon\" \"rats\"" #\space 0 #f)
    (list "\"the cat jumped over the moon\"" "\"rats\"")
)