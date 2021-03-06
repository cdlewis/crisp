SCHEME_COMMAND:=$(shell command -v chez || command -v scheme)

TESTS = eval-test.scm strings-test.scm parser-test.scm

.PHONY: test

test:
	@for file in $(TESTS); do $(SCHEME_COMMAND) --script $$file; done
	@SCHEME_COMMAND=$(SCHEME_COMMAND) ./integration-tests.sh

repl:
	@$(SCHEME_COMMAND) --script repl.scm 

inception:
	@(echo "(load \"./repl.scm\")\n(exit)") | $(SCHEME_COMMAND) --script repl.scm