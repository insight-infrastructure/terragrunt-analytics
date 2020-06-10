SHELL := /bin/bash -euo pipefail
.PHONY: all test clean

help: 								## Show help.
	@sed -ne '/@sed/!s/## //p' $(MAKEFILE_LIST)

clear-cache:						## Clear the terragrunt and terraform caches
	@find . -type d -name ".terragrunt-cache" -prune -exec rm -rf {} \; && \
	find . -type d -name ".terraform" -prune -exec rm -rf {} \; && \
	find . -type f -name "*.tfstate*" -prune -exec rm -rf {} \; && echo "cleared cache"

test:								## Run tests
	go test ./test -v -timeout 15m

test-init:							## Initialize the repo for tests
	go mod init test && go mod tidy

install-deps-ubuntu:  				## Install basics to run node on ubuntu - developers should do it manually
	./scripts/install-deps-ubuntu.sh

install-deps-mac:					## Install basics to run node on mac - developers should do it manually
	./scripts/install-deps-brew.sh
