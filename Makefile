TESTS = eval-test.scm parser-test.scm

.PHONY: test

SCHEME_COMMAND:=$(shell if [ -z $(command -v chezscheme)]; then echo "chez"; else echo "chezscheme"; fi;)

test:
	@for file in $(TESTS); do $(SCHEME_COMMAND) --script $$file; done
	@./integration-tests.sh

repl:
	@$(SCHEME_COMMAND) --script repl.scm 

inception:
	@(echo "(load \"./repl.scm\")\n(exit)") | $(SCHEME_COMMAND) --script repl.scm