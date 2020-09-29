expected="> 2
> "
output=$((echo "(+ 1 1)\n(exit)") | chez --script /Users/clewless/Code/crisp/repl.scm)
if [ "$output" = "$expected" ]; then
    echo "PASS: repl behaves as expected"
    exit 0
fi
echo "Error! Expected ($expected) got ($output)"
exit 1