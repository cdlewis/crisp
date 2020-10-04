TESTS = eval-test.scm parser-test.scm

.PHONY: test

SCHEME_COMMAND:=$(shell if [ -z $(command -v chez)]; then echo "scheme"; else echo "chez"; fi;)

test:
	@for file in $(TESTS); do $(SCHEME_COMMAND) --script $$file; done
	@./integration-tests.sh

repl:
	@$(SCHEME_COMMAND) --script repl.scm 

inception:
	@(echo "(load \"./repl.scm\")\n(exit)") | $(SCHEME_COMMAND) --script repl.scm