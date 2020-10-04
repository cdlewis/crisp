expected="> 2
> "
output=$((echo "(+ 1 1)\n(exit)") | $SCHEME_COMMAND --script repl.scm)
if [ "$output" = "$expected" ]; then
    echo "PASS: repl behaves as expected"
else
    echo "FAIL: expected ($expected) got ($output)"
    exit 1
fi