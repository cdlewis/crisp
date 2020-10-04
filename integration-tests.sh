expected="> 2
> "
output=$(echo "(+ 1 1)\n(exit)" | $SCHEME_COMMAND --script repl.scm)