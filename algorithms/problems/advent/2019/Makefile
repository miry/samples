.PHONY: test
test: fmt
	crystal run *_spec.cr

.PHONY: fmt
fmt:
	crystal tool format

.PHONY: day%
day%: input/day%.txt
	cat $< | crystal run cli.cr -- -d $*
