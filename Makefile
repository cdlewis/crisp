TESTS = eval-test.scm parser-test.scm

.PHONY: test

test:
	@for file in $(TESTS); do chez --script $$file; done
	@./integration-tests.sh

repl:
	@chez --script repl.scm 