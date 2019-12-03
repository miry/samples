.PHONY: test
test:
	crystal run *_spec.cr

.PHONY: day%
day%: input/day%.txt
	cat $< | crystal run cli.cr -- -d $*
