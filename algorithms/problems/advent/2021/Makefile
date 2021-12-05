PART?=1

.PHONY: test
test: fmt
	crystal spec *_spec.cr

.PHONY: fmt
fmt:
	crystal tool format

.PHONY: day%
day%: input/day%.txt fmt
	cat $< | crystal run cli.cr -- --day $* --part=$(PART)

.PHONY: day%.2
day%.2: input/day%.txt fmt
	cat $< | crystal run cli.cr -- --day $* --part=2
