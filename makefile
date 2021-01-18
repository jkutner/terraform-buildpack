.EXPORT_ALL_VARIABLES:

SHELL=/bin/bash -o pipefail

test:
	@bash ./test/simple.sh

package:
	@pack buildpack package jkutner/terraform

.PHONY: test package
