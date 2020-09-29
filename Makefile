TESTS = eval-test.scm parser-test.scm

.PHONY: test

test:
	for file in $(TESTS); do chez --script $$file; done
	./repl-test.sh

repl:
	chez --script repl.scm 