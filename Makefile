TESTS = main-test.scm parser-test.scm

.PHONY: test

test:
	for file in $(TESTS); do chez --script $$file; done
