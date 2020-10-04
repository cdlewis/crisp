expected="> 2
> "
output=$((echo "(+ 1 1)\n(exit)") | $SCHEME_COMMAND --script repl.scm)
if [ "$output" = "$expected" ]; then
    echo "PASS: repl behaves as expected"
else
    echo "FAIL: expected ($expected) got ($output)"
    exit 1
fi

expected="Exception in resolve-symbol. Missing reference: missing-function"
output=$((echo "(missing-function 1 2)\n(exit)") | $SCHEME_COMMAND --script repl.scm 2>&1 > /dev/null)
if [ "$output" = "$expected" ]; then
    echo "PASS: exception handling behaves as expected"
else
    echo "FAIL: expected ($expected) got ($output)"
    exit 1
fi
